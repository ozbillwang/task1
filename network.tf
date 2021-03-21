#Create VPC
resource "aws_vpc" "MyFirstVPC" {

  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MyFirstVPC"
  }

}

#Create EIP
resource "aws_eip" "nat" {
  vpc = true
}


#Create IGW
resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.MyFirstVPC.id
  tags = {
    "Name" = "IGW"
  }
}

#Create NGW
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet_private.id
  tags = {
    "Name" = "NGW"
  }
}


#Create route table for private subnet
resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.MyFirstVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
}



#Associate the  route table to private subnet

resource "aws_route_table_association" "nat_gateway" {
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.nat_gateway.id
}




#Create route table for public subnet
resource "aws_route_table" "internet_gateway" {
  vpc_id = aws_vpc.MyFirstVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}



#Associate the  route table to public subnet

resource "aws_route_table_association" "internet_gateway" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.internet_gateway.id
}










#Get all available AZ's in VPC
data "aws_availability_zones" "azs" {

  state = "available"
}


#Create public subnet
resource "aws_subnet" "subnet_public" {

  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.MyFirstVPC.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    "Name" = "public_subnet"
  }
}


#Create private subnet
resource "aws_subnet" "subnet_private" {

  vpc_id            = aws_vpc.MyFirstVPC.id
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  cidr_block        = "10.0.2.0/24"
  tags = {
    "Name" = "private_subnet"
  }
}
