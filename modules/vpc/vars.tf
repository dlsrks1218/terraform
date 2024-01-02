variable "vpc_cidr" {
  description = "This is VPC CIDR"
  type        = string
}
variable "prefix" {
  description = "This is Prefix Name"
  type        = string
}

variable "env" {
  description = "Seperate dev, stg, prod, test"
  type        = string
}

variable "public_subnet_cidr" {
  description = "This is Public Subnet CIDR"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "This is Private Subnet CIDR"
  type        = list(string)
}

variable "availability_zones" {
  description = "This is Availability Zones"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "This is Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_single_nat_gateway" {
  description = "This is Enable Single NAT Gateway"
  type        = bool
  default     = true
}