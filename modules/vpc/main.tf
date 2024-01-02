resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.prefix}-${var.env}-vpc"
  }
}

# Public Subnet #1
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.prefix}-${var.env}-public-${substr("${var.availability_zones[count.index]}", -1, 1)}-${count.index}"
  }
}

# Routing Table for Public Subnets
resource "aws_route_table" "public" {
  count = length(aws_subnet.public)

  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "${var.prefix}-${var.env}-public-rt-${count.index}"
  }
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

  tags = {
    Name = "${var.prefix}-${var.env}-public-${substr("${var.availability_zones[count.index]}", -1, 1)}-${count.index}"
  }
}

# Routing Table for Private Subnets
resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "${var.prefix}-${var.env}-private-rt-${count.index}"
  }
}

# # Route for Local Network
# resource "aws_route" "private_local" {
#   count = length(aws_subnet.private)

#   route_table_id            = aws_route_table.private[count.index].id
#   destination_cidr_block    = aws_vpc.myvpc.cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
# }

# # NAT Gateway for Private Subnets
# resource "aws_nat_gateway" "private" {
#   count = var.enable_nat_gateway && var.enable_single_nat_gateway ? 1 : 0

#   subnet_id     = aws_subnet.private[0].id
#   allocation_id = aws_eip.nat[0].id
# }

# # Route for NAT Gateway
# resource "aws_route" "private_nat_gateway" {
#   count = var.enable_nat_gateway && var.enable_single_nat_gateway ? 1 : 0

#   route_table_id         = aws_route_table.private[0].id
#   destination_cidr_block = aws_vpc.myvpc.cidr_block
#   nat_gateway_id         = aws_nat_gateway.private[0].id
# }

# # Associate Private Subnets with the Routing Table
# resource "aws_route_table_association" "private" {
#   count          = length(aws_subnet.private)
#   route_table_id = aws_route_table.private[count.index].id
# }


# Route for Local Network
resource "aws_route" "private_local" {
  count = length(aws_subnet.private)

  route_table_id            = aws_route_table.private[count.index].id
  destination_cidr_block    = myvpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
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
  destination_cidr_block = myvpc.cidr_block
  nat_gateway_id         = aws_nat_gateway.private[count.index].id
}

# Associate Private Subnets with the Routing Table
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# EIP for NAT Gateway
resource "aws_eip" "nat_eip" {
  count = var.enable_nat_gateway ? length(aws_subnet.private) : 0

  tags = {
    Name = "${var.prefix}-${var.env}-nat-eip-${count.index}"
  }
}
