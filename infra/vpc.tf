# create our VPC.
resource "aws_vpc" "wp_vpc" {
  cidr_block = "172.16.0.0/16"
}

# get available AZ's.
data "aws_availability_zones" "azs_in_region" {
}

# create two public subnets. 
resource "aws_subnet" "wp_public_subnet_0" {
  vpc_id = aws_vpc.wp_vpc.id
  cidr_block = cidrsubnet(aws_vpc.wp_vpc.cidr_block, 8, 1)
  availability_zone = data.aws_availability_zones.azs_in_region.names[1]
}

resource "aws_subnet" "wp_public_subnet_1" {
  vpc_id = aws_vpc.wp_vpc.id
  cidr_block = cidrsubnet(aws_vpc.wp_vpc.cidr_block, 8, 2)
  availability_zone = data.aws_availability_zones.azs_in_region.names[2]
}

# create an internet gateway, so anything in our public subnets can access the internet.
resource "aws_internet_gateway" "wp_igw" {
  vpc_id = aws_vpc.wp_vpc.id
}

# create two private subnets.
resource "aws_subnet" "wp_private_subnet_0" {
  vpc_id = aws_vpc.wp_vpc.id
  cidr_block = cidrsubnet(aws_vpc.wp_vpc.cidr_block, 8, 3)
  availability_zone = data.aws_availability_zones.azs_in_region[1]
}

resource "aws_subnet" "wp_private_subnet_1" {
  vpc_id = aws_vpc.wp_vpc.id
  cidr_block = cidrsubnet(aws_vpc.wp_vpc.cidr_block, 8, 4)
  availability_zone = data.aws_availability_zones.azs_in_region[2]
}

# create elastic ip interface for each nat gateway.
resource "aws_eip" "wp_nat_gw_ip_0" {
  vpc = true
}
resource "aws_eip" "wp_nat_gw_ip_1" {
  vpc = true
}

# create nat gateway for each private subnet. this is used for the private subnets to access the internet.
resource "aws_nat_gateway" "wp_nat_gw_0" {
  subnet_id = aws_subnet.wp_public_subnet_0.id
  allocation_id = aws_subnet.wp_private_subnet_0.id
  depends_on = [aws_eip.wp_nat_gw_ip_0, aws_subnet.wp_private_subnet_0, aws_subnet.wp_public_subnet_0]
}

resource "aws_nat_gateway" "wp_nat_gw_1" {
  subnet_id = aws_subnet.wp_public_subnet_1.id
  allocation_id = aws_subnet.wp_private_subnet_1.id
  depends_on = [aws_eip.wp_nat_gw_ip_1, aws_subnet.wp.wp_private_subnet_1, aws_subnet.wp_public_subnet_1]
}

# create a route table, routing all non local traffic through the nat gateway.
resource "aws_route" "wp_private_route_table_0" {
  cidr_block = "0.0.0.0/0"
  vpc_id = aws_vpc.wp_vpc.id
  nat_gateway_id = aws_nat_gateway.wp_nat_gw_0
}

# set this route table as default, so it doesn't default to the default route table.
resource "aws_route_table_association" "wp_private_route_table_association_0" {
  subnet_id = aws_subnet.wp_private_subnet_0.id
  route_table_id = aws_route_table.wp_private_route_table_0.id
}

# same as above, but for different NAT gateway and subnet.
resource "aws_route_table" "wp_private_route_table_1" {
  vpc_id = aws_vpc.wp_vpc.id
  cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.wp_nat_gw_1
}

resource "aws_route_table_association" "wp_private_route_table_association_1" {
  subnet_id = aws_subnet.wp_private_subnet_1.id
  route_table_id = aws_route_table.wp_private_route_table_1.id
}