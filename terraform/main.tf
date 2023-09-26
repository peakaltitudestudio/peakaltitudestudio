provider "aws" {
  region = "us-west-1"
}

variable "PREFIX" {
  type        = string
  default     = ""
}

resource "aws_acm_certificate" "pas-acm-cert" {
  domain_name       = "peakaltitudestudio.com"
  validation_method = "DNS"
}

output "acm_dns_validation" {
  value = {
    for option in aws_acm_certificate.pas-acm-cert.domain_validation_options :
    option.resource_record_name => option.resource_record_value
  }
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

resource "aws_instance" "pas-website-ec2-instance" {
  ami           = "ami-073e64e4c237c08ad"
  instance_type = "t2.micro"
  key_name      = "ec2sshkeypair"
  subnet_id     = "subnet-0a0cc0c37d9ff6214"

  vpc_security_group_ids = [
    aws_security_group.allow-ssh-security-group.id,
    aws_security_group.allow-app-port-security-group.id,
    aws_security_group.allow-http-security-group.id,
    "sg-03ae4b8c506121cb1"
  ]

  tags = {
    Name = "${var.PREFIX}pas-instance"
  }

  # Install docker and nginix
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo systemctl enable docker
    sudo yum install nginx  -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo python3 -m venv /opt/certbot/
    sudo /opt/certbot/bin/pip install --upgrade pip
    sudo /opt/certbot/bin/pip install certbot certbot-nginx
    sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    sudo yum-config-manager --enable epel
    sudo yum install certbot python3-certbot-nginx
    sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot
    sudo certbot --nginx
    EOF
}

resource "aws_eip" "elastic-ip" {
  instance = aws_instance.pas-website-ec2-instance.id
}

output "public_ip" {
  value = aws_instance.pas-website-ec2-instance.public_ip
}

output "elastic-ip" {
  value = aws_eip.elastic-ip.instance
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

resource "aws_security_group" "allow-http-security-group" {
  name = "${var.PREFIX}allow-http"
  vpc_id = "vpc-0782912bff4064977"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-https-security-group" {
  name = "${var.PREFIX}allow-https"
  vpc_id = "vpc-0782912bff4064977"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}