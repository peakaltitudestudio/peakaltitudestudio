resource "aws_acm_certificate" "pas_acm_cert" {
  domain_name       = "peakaltitudestudio.com"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "pas_cert_validation" {
  certificate_arn = aws_acm_certificate.pas_acm_cert.arn
}

resource "aws_route53_zone" "pas_zone" {
  name = "peakaltitudestudio.com"
  comment = "DNS zone for peakaltitudestudio.com"
}

output "name_servers" {
  value = aws_route53_zone.pas_zone.name_servers
}

resource "aws_route53_record" "pas_record" {
  zone_id = aws_route53_zone.pas_zone.zone_id
  name    = "peakaltitudestudio.com"
  type    = "A"

  alias {
    zone_id                 = aws_lb.pas_elb.zone_id
    name                    = aws_lb.pas_elb.dns_name
    evaluate_target_health  = true
  }

  depends_on = [aws_route53_zone.pas_zone]
}

resource "aws_route53_record" "www_pas_record" {
  zone_id = aws_route53_zone.pas_zone.zone_id
  name    = "www.peakaltitudestudio.com"
  type    = "A"

  alias {
    zone_id                 = aws_lb.pas_elb.zone_id
    name                    = aws_lb.pas_elb.dns_name
    evaluate_target_health  = true
  }

  depends_on = [aws_route53_zone.pas_zone]
}

resource "aws_subnet" "main_pas_subnet" {
  vpc_id                  = aws_vpc.pas_main_vpc.id
  cidr_block              = local.main_subnet_cidr_block
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "alt_pas_subnet" {
  vpc_id                  = aws_vpc.pas_main_vpc.id
  cidr_block              = local.alt_subnet_cidr_block
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = true
}


resource "aws_instance" "pas_website_ec2_instance" {
  ami           = "ami-073e64e4c237c08ad"
  instance_type = "t2.micro"
  key_name      = "ec2sshkeypair"
  subnet_id     = aws_subnet.main_pas_subnet.id

  vpc_security_group_ids = [
    aws_security_group.allow_ssh_sg.id,
    aws_security_group.allow_app_port_sg.id,
    aws_security_group.allow_http_and_https_sg.id
  ]

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo systemctl enable docker
    sudo yum install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF
}

resource "aws_eip" "elastic_ip" {
  instance = aws_instance.pas_website_ec2_instance.id
}

output "public_ip" {
  value = aws_eip.elastic_ip.public_ip
}

resource "aws_lb" "pas_elb" {
  name               = "${local.env}-pas"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.main_pas_subnet.id,
    aws_subnet.alt_pas_subnet.id
  ]

  enable_deletion_protection = false

  enable_http2 = true
}

resource "aws_lb_listener" "https_listener_forward" {
  load_balancer_arn = aws_lb.pas_elb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.pas_acm_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pas_target_group.arn
  }
}

resource "aws_lb_listener" "http_listener_redirect" {
  load_balancer_arn = aws_lb.pas_elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "pas_target_group" {
  name        = "${local.env}-pas-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.pas_main_vpc.id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "pas-target-group-attachment" {
  target_group_arn = aws_lb_target_group.pas_target_group.arn
  target_id         = aws_instance.pas_website_ec2_instance.id
}
