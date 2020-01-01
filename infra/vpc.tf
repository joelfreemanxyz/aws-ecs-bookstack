# create our VPC.
resource "aws_vpc" "app_vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
}

# Create IGW, so this VPC can access the internet.
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
}

# create public subnet 0
resource "aws_subnet" "app_public_subnet_0" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = "true"

  depends_on              = [aws_vpc.app_vpc]
}

# create public subnet 1 
resource "aws_subnet" "app_public_subnet_1" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "172.16.2.0/24"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = "true"

  depends_on              = [aws_vpc.app_vpc]
}

# create route table to send all traffic from public subnet through IGW
resource "aws_route_table" "app_public_rt" {
  vpc_id       = aws_vpc.app_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  depends_on   = [aws_vpc.app_vpc, aws_internet_gateway.app_igw]
}

# associate route table app_public_0_rt with subnet app_public_subnet_0 so they know to use eachother
resource "aws_route_table_association" "app_public_0_rta" {
  subnet_id      = aws_subnet.app_public_subnet_0.id
  route_table_id = aws_route_table.app_public_rt.id

  depends_on     = [aws_vpc.app_vpc, aws_route_table.app_public_rt, aws_subnet.app_public_subnet_0]
}

# associate route table app_public_rt with subnet app_public_subnet_1 so they know to use eachother
resource "aws_route_table_association" "app_public_1_rta" {
  subnet_id      = aws_subnet.app_public_subnet_1.id
  route_table_id = aws_route_table.app_public_rt.id

  depends_on     = [aws_vpc.app_vpc, aws_route_table.app_public_rt, aws_subnet.app_public_subnet_1]
}

# create 2 elastic IPs so we can assign them to our NAT gateways.
resource "aws_eip" "app_eip_0" {
  vpc        = true
  depends_on = [aws_vpc.app_vpc]
}
resource "aws_eip" "app_eip_1" {
  vpc        = true
  depends_on = [aws_vpc.app_vpc]
}

# create nat gateway for each private subnet. this is used for the private subnets to access the internet.
resource "aws_nat_gateway" "app_nat_gw_0" {
  subnet_id     = aws_subnet.app_public_subnet_0.id
  allocation_id = aws_eip.app_eip_0.id

  depends_on    = [aws_subnet.app_public_subnet_0, aws_eip.app_eip_0]
}

resource "aws_nat_gateway" "app_nat_gw_1" {
  subnet_id     = aws_subnet.app_public_subnet_1.id
  allocation_id = aws_eip.app_eip_1.id

  depends_on    = [aws_subnet.app_public_subnet_1, aws_eip.app_eip_1]
}

# create two private subnets.
resource "aws_subnet" "app_private_subnet_0" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "172.16.3.0/24"
  availability_zone = "ap-southeast-2a"

  depends_on        = [aws_vpc.app_vpc]
}

resource "aws_subnet" "app_private_subnet_1" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "172.16.4.0/24"
  availability_zone = "ap-southeast-2b"

  depends_on        = [aws_vpc.app_vpc]
}

resource "aws_route_table" "app_private_rt_0" {
  vpc_id           = aws_vpc.app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.app_nat_gw_0.id
  }

  depends_on       = [aws_vpc.app_vpc, aws_nat_gateway.app_nat_gw_0]
}

resource "aws_route_table" "app_private_rt_1" {
  vpc_id           = aws_vpc.app_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.app_nat_gw_1.id
  }

  depends_on       = [aws_vpc.app_vpc, aws_nat_gateway.app_nat_gw_1]
}

resource "aws_route_table_association" "app_private_rta_0" {
  subnet_id      = aws_subnet.app_private_subnet_0.id
  route_table_id = aws_route_table.app_private_rt_0.id

  depends_on     = [aws_vpc.app_vpc, aws_route_table.app_private_rt_0, aws_subnet.app_private_subnet_0]
}

resource "aws_route_table_association" "app_private_rta_1" {
  subnet_id      = aws_subnet.app_private_subnet_1.id
  route_table_id = aws_route_table.app_private_rt_1.id

  depends_on     = [aws_vpc.app_vpc, aws_route_table.app_private_rt_1, aws_subnet.app_private_subnet_1]
}