# # BEGIN: Test for single NAT gateway and multiple private subnets
# data "aws_vpc" "existing_vpc" {
#   id = aws_vpc.myvpc.id
# }

# data "aws_subnet_ids" "existing_private_subnets" {
#   vpc_id = data.aws_vpc.existing_vpc.id
#   tags = {
#     "Type" = "private"
#   }
# }

# data "aws_nat_gateway" "existing_nat_gateway" {
#   subnet_id = data.aws_subnet_ids.existing_private_subnets.ids[0]
# }

# data "aws_route_table" "existing_route_table" {
#   vpc_id = data.aws_vpc.existing_vpc.id
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