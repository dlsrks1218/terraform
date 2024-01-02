# resource "aws_vpc" "eks_vpc" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_internet_gateway" "gateway" {
#   vpc_id = aws_vpc.eks_vpc.id
# }

# # Public Subnets
# resource "aws_subnet" "public_subnet_01" {
#   vpc_id            = aws_vpc.eks_vpc.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "ap-northeast-2a"
# }

# resource "aws_subnet" "public_subnet_02" {
#   vpc_id            = aws_vpc.eks_vpc.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "ap-northeast-2c"
# }

# # Private Subnets
# resource "aws_subnet" "private_subnet_01" {
#   vpc_id            = aws_vpc.eks_vpc.id
#   cidr_block        = "10.0.3.0/24"
#   availability_zone = "ap-northeast-2a"
# }

# resource "aws_subnet" "private_subnet_02" {
#   vpc_id            = aws_vpc.eks_vpc.id
#   cidr_block        = "10.0.4.0/24"
#   availability_zone = "ap-northeast-2c"
# }

# # Public Routing Table
# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.eks_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gateway.id
#   }
# }

# # Associate Public Subnets with Public Routing Table
# resource "aws_route_table_association" "public_subnet_01" {
#   subnet_id      = aws_subnet.public_subnet_01.id
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_route_table_association" "public_subnet_02" {
#   subnet_id      = aws_subnet.public_subnet_02.id
#   route_table_id = aws_route_table.public_rt.id
# }

# # Private Routing Table
# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.eks_vpc.id

#   route {
#     cidr_block = "10.0.0.0/16"
#   }
# }

# # Associate Private Subnets with Private Routing Table
# resource "aws_route_table_association" "private_subnet_01" {
#   subnet_id      = aws_subnet.private_subnet_01.id
#   route_table_id = aws_route_table.private_rt.id
# }

# resource "aws_route_table_association" "private_subnet_02" {
#   subnet_id      = aws_subnet.private_subnet_02.id
#   route_table_id = aws_route_table.private_rt.id
# }

# ## Default NACL for Public & Private Subnets
# resource "aws_network_acl" "public_nacl" {
#   vpc_id = aws_vpc.eks_vpc.id

#   subnet_ids = [
#     aws_subnet.public_subnet_01.id,
#     aws_subnet.public_subnet_02.id
#   ]

#   egress {
#     protocol   = "-1"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/32"
#   }

#   egress {
#     protocol   = "-1"
#     rule_no    = 101
#     action     = "allow"
#     cidr_block = "::/0"
#   }

#   ingress {
#     protocol   = "-1"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/32"
#   }

#   ingress {
#     protocol   = "-1"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "::/0"
#   }
# }

# # module "vpc" {
# #   source = "terraform-aws-modules/vpc/aws"

# #   name = "myeks-vpc"
# #   cidr = "10.0.0.0/16"

# #   azs             = [ "ap-northeast-1a", "ap-northeast-1c" ]
# #   private_subnets = [ "10.0.1.0/24", "192.168.2.0/24" ]
# #   public_subnets  = [ "10.0.3.0/24", "192.168.4.0/24" ]

# #   enable_nat_gateway = false
# #   enable_vpn_gateway = false

# #   tags = {
# #     Terraform = "true"
# #     Environment = "test"
# #   }
# # }

module "vpc" {
  source = "../../modules/vpc"

  prefix              = "myeks-vpc"
  cidr_block            = "10.0.0.0/16"
  env                 = "test"
  public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr = ["10.0.3.0/24", "10.0.4.0/24"]

  availability_zones        = ["ap-northeast-2a", "ap-northeast-2c"]
  enable_nat_gateway        = true
  enable_single_nat_gateway = true

}