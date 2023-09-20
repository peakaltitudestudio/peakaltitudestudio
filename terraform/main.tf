provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "pas-website-ec2-instance" {
  ami           = "ami-073e64e4c237c08ad"  # Replace with your desired AMI
  instance_type = "t2.micro"              # Replace with your desired instance type
  key_name      = "ec2keypair"    # Replace with your EC2 key pair name

  tags = {
    Name = "pas-instance"
  }
}
