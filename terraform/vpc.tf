resource "aws_vpc" "pas_main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  
  tags = {
    Name = "${local.env_noblank}"
  }
}

resource "aws_internet_gateway" "pas_internet_gateway" {
  vpc_id = aws_vpc.pas_main_vpc.id

  tags = {
    Name = "${local.env_noblank}"
  }
}

resource "aws_route" "pas_internet_gateway_route" {
  route_table_id         = aws_vpc.pas_main_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pas_internet_gateway.id
}
