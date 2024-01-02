variable "tags" {
  type = map(string)
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr

  tags = merge(
    {
      Name = "${var.prefix}-${var.env}-vpc"
    },
    var.tags
  )
}

# Public Subnet #1
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${var.prefix}-${var.env}-public-subnet-${substr("${var.availability_zones[count.index]}", -1, 1)}-${count.index}"
    },
    var.tags
  )
}

# Routing Table for Public Subnets
resource "aws_route_table" "public" {
  count = length(aws_subnet.public)

  vpc_id = aws_vpc.myvpc.id

  tags = merge (
    {
      Name = "${var.prefix}-${var.env}-public-rt-${count.index}"
    },
    var.tags
  )
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.myvpc.id

  tags = merge(
    {
      Name = "${var.prefix}-${var.env}-igw"
    },
    var.tags
  )
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  count = length(aws_subnet.public)

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
}

# Associate Public Subnets with the Routing Table
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

# Private Subnet #1
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${var.prefix}-${var.env}-private-subnet-${substr("${var.availability_zones[count.index]}", -1, 1)}-${count.index}"
    },
    var.tags
  )
}

# Routing Table for Private Subnets
resource "aws_route_table" "private" {
  count = length(aws_subnet.private)
  vpc_id = aws_vpc.myvpc.id

  tags = merge(
    {
      Name = "${var.prefix}-${var.env}-private-rt-${count.index}"
    },
    var.tags
  )
}

# Route for Local Network
resource "aws_route" "private_local" {
  count = length(aws_subnet.private)

  vpc_endpoint_id           = aws_vpc.myvpc.id
  vpc_peering_connection_id = null
  carrier_gateway_id        = null
  gateway_id                = null
  egress_only_gateway_id    = null
  transit_gateway_id        = null
  core_network_arn          = null
  local_gateway_id          = null
  nat_gateway_id            = null
  network_interface_id      = null

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = var.vpc_cidr
}

# EIP for NAT Gateway
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? length(aws_subnet.private) : 0

  tags = merge(
    {
      Name = "${var.prefix}-${var.env}-nat-gw-eip-${count.index}"
    },
    var.tags
  )
}

# NAT Gateway for Private Subnets
resource "aws_nat_gateway" "private" {
  count = var.enable_nat_gateway ? length(aws_subnet.private) : 0

  subnet_id     = aws_subnet.private[count.index].id
  allocation_id = aws_eip.nat[count.index].id
}

# Route for NAT Gateway
resource "aws_route" "private_nat_gateway" {
  count = var.enable_nat_gateway ? length(aws_subnet.private) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = var.vpc_cidr
  nat_gateway_id         = aws_nat_gateway.private[count.index].id
}

# Associate Private Subnets with the Routing Table
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}