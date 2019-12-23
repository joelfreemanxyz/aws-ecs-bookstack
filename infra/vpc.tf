# create our VPC.
resource "aws_vpc" "app_vpc" {
  cidr_block = "172.16.0.0/16"
}

# get available AZ's.
data "aws_availability_zones" "azs_in_region" {
}

# create 2 public subnets in seperate AZs.
resource "aws_subnet" "app_public_subnet_0" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, 1)
  availability_zone = data.aws_availability_zones.azs_in_region.names[1]
}

resource "aws_subnet" "app_public_subnet_1" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, 2)
  availability_zone = data.aws_availability_zones.azs_in_region.names[2]
}

# create an IGW for VPC so our public subnets can access the internet.
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
}

# create 2 private subnets. 
resource "aws_subnet" "app_private_subnet_0" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, 3)
  availability_zone = data.aws_availability_zones.azs_in_region[1]
}

resource "aws_subnet" "app_private_subnet_1" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, 4)
  availability_zone = data.aws_availability_zones.azs_in_region[2]
}

# create elastic ip interface. this is attached to the nat gateway.
resource "aws_eip" "app_nat_gw_ip_0" {
  vpc = true
}
resource "aws_eip" "app_nat_gw_ip_1" {
  vpc = true
}

# create nat gateways.
resource "aws_nat_gateway" "app_nat_gw_0" {
  subnet_id = aws_subnet.app_public_subnet_0.id
  allocation_id = aws_subnet.app_private_subnet_0.id

  depends_on = [aws_eip.app_nat_gw_ip_0, aws_subnet.app_private_subnet_0, app]
}
resource "aws_nat_gateway" "app_nat_gw_1" {
  subnet_id = aws_subnet.app_public_subnet_1.id
  allocation_id = aws_subnet.app_private_subnet_1.id

  depends_on = [aws_eip.app_nat_gw_ip_1]
}


