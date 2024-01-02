# variable "vpc_cidr" {
#   description = "This is VPC CIDR"
#   type        = string
# }
# variable "prefix" {
#   description = "This is Prefix Name"
#   type        = string
# }

# variable "env" {
#   description = "Seperate dev, stg, prod, test"
#   type        = string
# }

# variable "public_subnet_cidr" {
#   description = "This is Public Subnet CIDR"
#   type        = list(string)
# }

# variable "private_subnet_cidr" {
#   description = "This is Private Subnet CIDR"
#   type        = list(string)
# }

# variable "availability_zones" {
#   description = "This is Availability Zones"
#   type        = list(string)
# }

# variable "enable_nat_gateway" {
#   description = "This is Enable NAT Gateway"
#   type        = bool
#   default     = true
# }

# variable "enable_single_nat_gateway" {
#   description = "This is Enable Single NAT Gateway"
#   type        = bool
#   default     = true
# }

# # Check if there is only one NAT gateway
# run "single_nat_gateway" {
#   command = plan

#   count = length(data.aws_subnet_ids.existing_private_subnets.ids) == 1 ? 1 : 0

#   condition = count > 0

#   message = "There should be only one NAT gateway"
# }

# # Check if there is a routing table for each private subnet
# run "routing_table_per_private_subnet" {
#   command = plan

#   count = length(data.aws_subnet_ids.existing_private_subnets.ids)

#   condition = count == length(data.aws_route_table.existing_route_table.ids)

#   message = "There should be a routing table for each private subnet"
# }
# # END: Test for single NAT gateway and multiple private subnets