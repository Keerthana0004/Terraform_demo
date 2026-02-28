#Vpc
resource "aws_vpc" "splunk-vpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "splunk-vpc"
    env  = "Dev"
  }
}
## Subnet

resource "aws_subnet" "public_subnet1" {
  availability_zone       = "us-east-1a"
  vpc_id                  = aws_vpc.splunk-vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-public-vpc"
    env  = "Dev"
  }
}

resource "aws_subnet" "public_subnet2" {
  availability_zone       = "us-east-1b"
  vpc_id                  = aws_vpc.splunk-vpc.id
  cidr_block              = "10.10.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-public-vpc"
    env  = "Dev"
  }
}
## Private subnet

resource "aws_subnet" "private_subnet1" {
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.splunk-vpc.id
  cidr_block        = "10.10.3.0/24"
  tags = {
    Name = "subnet-private-vpc"
    env  = "Dev"
  }

}
resource "aws_subnet" "private_subnet2" {
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.splunk-vpc.id
  cidr_block        = "10.10.4.0/24"
  tags = {
    Name = "subnet-private-vpc"
    env  = "Dev"
  }

}
## route table 
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.splunk-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gtw1.id
  }
  #depends_on = [ aws_internet_gateway.gtw1 ]
}

## Gateway 
resource "aws_internet_gateway" "gtw1" {
  vpc_id = aws_vpc.splunk-vpc.id
  tags = {
    Name = "IGW"
  }

}
##Route association

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rt1.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.rt1.id
}