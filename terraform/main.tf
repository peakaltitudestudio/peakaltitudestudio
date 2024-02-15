resource "aws_acm_certificate" "pas_acm_cert" {
  domain_name       = "${local.env_dot}peakaltitudestudio.com"
  subject_alternative_names = ["www.${local.env_dot}peakaltitudestudio.com"]
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "pas_cert_validation" {
  certificate_arn = aws_acm_certificate.pas_acm_cert.arn
  validation_record_fqdns = aws_acm_certificate.pas_acm_cert.domain_validation_options.*.resource_record_name
}

resource "aws_route53_record" "pas_cert_cname_record" {
  zone_id = var.manually_created_zone_id
  name    = "${element(aws_acm_certificate.pas_acm_cert.domain_validation_options[*].resource_record_name, 0)}"
  type    = "CNAME"
  ttl     = 300
  records = [element(aws_acm_certificate.pas_acm_cert.domain_validation_options[*].resource_record_value, 0)]
}

resource "aws_route53_record" "www_pas_cert_cname_record" {
  zone_id = var.manually_created_zone_id
  name    = "${element(aws_acm_certificate.pas_acm_cert.domain_validation_options[*].resource_record_name, 1)}"
  type    = "CNAME"
  ttl     = 300
  records = [element(aws_acm_certificate.pas_acm_cert.domain_validation_options[*].resource_record_value, 1)]
}

resource "aws_route53_record" "pas_record" {
  zone_id = var.manually_created_zone_id
  name    = "${local.env_dot}peakaltitudestudio.com"
  type    = "A"

  alias {
    zone_id                 = aws_lb.pas_elb.zone_id
    name                    = aws_lb.pas_elb.dns_name
    evaluate_target_health  = true
  }
}

resource "aws_route53_record" "www_pas_record" {
  zone_id = var.manually_created_zone_id
  name    = "www.${local.env_dot}peakaltitudestudio.com"
  type    = "A"

  alias {
    zone_id                 = aws_lb.pas_elb.zone_id
    name                    = aws_lb.pas_elb.dns_name
    evaluate_target_health  = true
  }
}

resource "aws_subnet" "main_pas_subnet" {
  vpc_id                  = aws_vpc.pas_main_vpc.id
  cidr_block              = local.main_subnet_cidr_block
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true

  tags = "${local.default_tags}"
}

resource "aws_subnet" "alt_pas_subnet" {
  vpc_id                  = aws_vpc.pas_main_vpc.id
  cidr_block              = local.alt_subnet_cidr_block
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = true

  tags = "${local.default_tags}"
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

  tags = "${local.default_tags}"

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
  name               = "${local.env_noblank}-pas"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.main_pas_subnet.id,
    aws_subnet.alt_pas_subnet.id
  ]

  enable_deletion_protection = false
  enable_http2 = true

  security_groups = [aws_security_group.allow_http_and_https_sg.id]
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

  depends_on = [aws_acm_certificate_validation.pas_cert_validation]
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
  name        = "${local.env_noblank}-pas-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.pas_main_vpc.id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "pas-target-group-attachment" {
  target_group_arn = aws_lb_target_group.pas_target_group.arn
  target_id         = aws_instance.pas_website_ec2_instance.id
}
