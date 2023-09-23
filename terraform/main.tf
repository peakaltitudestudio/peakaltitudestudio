provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-storage"
    key            = "state-storage/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
  }
}

variable "CI_PREFIX" {
  type        = string
  default     = ""
}

resource "aws_instance" "pas-website-ec2-instance" {
  ami           = "ami-073e64e4c237c08ad"  # Replace with your desired AMI
  instance_type = "t2.micro"              # Replace with your desired instance type
  key_name      = "ec2sshkeypair"    # Replace with your EC2 key pair name

  tags = {
    Name = "${var.CI_PREFIX}pas-instance"
  }

  # Install docker
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo systemctl enable docker
    EOF
}

output "public_ip" {
  value = aws_instance.pas-website-ec2-instance.public_ip
}

resource "aws_security_group" "allow-ssh-security-group" {
  name = "${var.CI_PREFIX}allow-ssh"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
}

resource "aws_security_group" "allow-app-port-security-group" {
  name = "${var.CI_PREFIX}allow-app-port"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface_sg_attachment" "security-group-attachment-ssh" {
  security_group_id    = "${aws_security_group.allow-ssh-security-group.id}"
  network_interface_id = "${aws_instance.pas-website-ec2-instance.primary_network_interface_id}"
}

resource "aws_network_interface_sg_attachment" "security-group-attachment-app-port" {
  security_group_id    = "${aws_security_group.allow-app-port-security-group.id}"
  network_interface_id = "${aws_instance.pas-website-ec2-instance.primary_network_interface_id}"
}