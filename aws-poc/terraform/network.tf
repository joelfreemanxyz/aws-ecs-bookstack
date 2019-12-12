## THIS IS NOT 100% MINE - BASED OFF https://medium.com/@bradford_hamilton/deploying-containers-on-amazons-ecs-using-fargate-and-terraform-part-2-2e6f6a3a957f

# get available AZ's
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "wikijs_vpc" {
  cidr_block = "172.17.0.0/16"
}

# create 2 private subnets in seperate availability zones
resource "aws_subnet" "wikijs_private_subnet" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id            = "${aws_vpc.wikijs_vpc.vpc_id}"
}

# create 2 public subnets in seperate availability zones
resource "aws_subnet" "wikijs_public_subnet" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 2 + count.index)
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id                  = "${aws_vpc.wikijs_vpc.vpc_id}"
  map_public_ip_on_launch = true
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "wikijs_gw" {
  vpc_id = "${aws_vpc.wikijs_vpc.vpc_id}"
}

# Route the public subnet traffic through the IGW
resource "aws_route" "wikijs_public_subnet_route" {
  route_table_id         = "${aws_vpc.wikijs_vpc.route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.wikijs_gw.gateway_id}"
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "wikijs_private_subnet_gw_eip" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.wikijs_gw]
}

resource "aws_nat_gateway" "wikijs_private_subnet_gw" {
  count         = 2
  subnet_id     = element(aws_subnet.wikijs_public_subnet.*.id, count.index)
  allocation_id = element(aws_eip.wikijs_private_subnet_gw_eip.*.id, count.index)
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "wikijs_private_subnet_route" {
  count  = 2
  vpc_id = "${aws_vpc.wikijs_vpc.vpc_id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.wikijs_private_subnet_gw.*.id, count.index)
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.wikijs_private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.wikijs_private_subnet_route.*.id, count.index)
}