provider "aws" {
  region = "us-west-1"
}

variable "PREFIX" {
  type    = string
  default = ""
}

resource "aws_acm_certificate" "pas-acm-cert" {
  domain_name       = "peakaltitudestudio.com"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "pas-cert-validation" {
  certificate_arn = aws_acm_certificate.pas-acm-cert.arn
}

resource "aws_route53_zone" "pas-zone" {
  name = "peakaltitudestudio.com"
  comment = "DNS zone for peakaltitudestudio.com"
}

resource "aws_route53_record" "pas-record" {
  zone_id = aws_route53_zone.pas-zone.zone_id
  name    = "peakaltitudestudio.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.elastic-ip.public_ip]
  depends_on = [aws_route53_zone.pas-zone]
}

resource "aws_subnet" "second-pas-subnet" {
  vpc_id                  = "vpc-0782912bff4064977"  # Specify your VPC ID
  cidr_block              = "172.31.2.0/24" # Specify the CIDR block for the subnet
  availability_zone       = "us-west-1c" # Specify the Availability Zone
  map_public_ip_on_launch = true         # Specify if instances in this subnet receive public IPs
}


resource "aws_instance" "pas-website-ec2-instance" {
  ami           = "ami-073e64e4c237c08ad"
  instance_type = "t2.micro"
  key_name      = "ec2sshkeypair"
  subnet_id     = "subnet-0a0cc0c37d9ff6214"

  vpc_security_group_ids = [
    aws_security_group.allow-ssh-security-group.id,
    aws_security_group.allow-app-port-security-group.id,
    aws_security_group.allow-http-and-https-security-group.id,
    aws_security_group.allow-elb-security-group.id,
    "sg-03ae4b8c506121cb1"
  ]

  tags = {
    Name = "${var.PREFIX}pas-instance"
  }

  # Install docker and nginx
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

resource "aws_eip" "elastic-ip" {
  instance = aws_instance.pas-website-ec2-instance.id
}

output "public_ip" {
  value = aws_instance.pas-website-ec2-instance.public_ip
}

output "elastic-ip" {
  value = aws_eip.elastic-ip.public_ip
}

resource "aws_security_group" "allow-ssh-security-group" {
  name = "${var.PREFIX}allow-ssh"
  vpc_id = "vpc-0782912bff4064977"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
}

resource "aws_security_group" "allow-app-port-security-group" {
  name = "${var.PREFIX}allow-app-port"
  vpc_id = "vpc-0782912bff4064977"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-http-and-https-security-group" {
  name = "${var.PREFIX}allow-http-and-https"
  vpc_id = "vpc-0782912bff4064977"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "pas-elb" {
  name               = "${var.PREFIX}pas-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.second-pas-subnet.id,
    "subnet-0a0cc0c37d9ff6214"
  ]

  enable_deletion_protection = false

  enable_http2 = true
}

output "elb_dns_name" {
  value = aws_lb.pas-elb.dns_name
}

resource "aws_security_group" "allow-elb-security-group" {
  name = "${var.PREFIX}allow-elb"
  vpc_id = "vpc-0782912bff4064977"

  # Add ingress rule to allow ELB to communicate with EC2 instances
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.allow-http-and-https-security-group.id]
  }

  # Optionally, add ingress rule for HTTP to ELB if needed
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.pas-elb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.pas-acm-cert.arn

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "pas-target-group" {
  name        = "${var.PREFIX}pas-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0782912bff4064977" # Your VPC ID
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "pas-target-group-attachment" {
  target_group_arn = aws_lb_target_group.pas-target-group.arn
  target_id         = aws_instance.pas-website-ec2-instance.id
}
