
# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.env}-${random_pet.petname.id}-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.env}-${random_pet.petname.id}-Pub-Subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-${random_pet.petname.id}-IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.env}-${random_pet.petname.id}-Pub-Route-Table"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# IP Prefix List
resource "aws_ec2_managed_prefix_list" "allowed_ips" {
  name           = "${var.env}-${random_pet.petname.id}-allowed-ips"
  address_family = "IPv4"
  max_entries    = 2

  entry {
    cidr = "192.168.2.66/32"
  }

  entry {
    cidr = "173.66.77.88/32"
  }
}


# Elastic IPs for NLB
resource "aws_eip" "natgw-eip1" {
  #count = 2
  domain = "vpc"

  tags = {
    Name = "${var.env}-${random_pet.petname.id}-NATGW-EIP"
  }
}

resource "aws_nat_gateway" "nat_az_a" {
  allocation_id = aws_eip.natgw-eip1.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "nat-gw-az-a"
  }
  depends_on = [aws_internet_gateway.main]
}

## Private network
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.env}-${random_pet.petname.id}-Priv-Subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_az_a.id
  }

  tags = {
    Name = "${var.env}-${random_pet.petname.id}-PRI-Route-Table"
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


