resource "aws_vpc" "pas_main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "pas_internet_gateway" {
  vpc_id = aws_vpc.pas_main_vpc.id
}