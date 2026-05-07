resource "aws_vpc" "viva_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "Viva-VPC" }
}

resource "aws_subnet" "viva_subnet" {
  vpc_id     = aws_vpc.viva_vpc.id
  cidr_block = "10.0.1.0/24"
}
