resource "aws_vpc" "pas_main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  
  tags = "${local.default_tags}"
}

resource "aws_internet_gateway" "pas_internet_gateway" {
  vpc_id = aws_vpc.pas_main_vpc.id

  tags = "${local.default_tags}"
}

resource "aws_route" "pas_internet_gateway_route" {
  route_table_id         = aws_vpc.pas_main_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pas_internet_gateway.id
}
