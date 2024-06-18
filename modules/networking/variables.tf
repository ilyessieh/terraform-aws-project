# VPC name
variable "vpc_name" {
  type        = string
}

# VPC CIDR
variable "vpc_cidr" {
  type        = string
}

# Public subnets CIDR list
variable "public_subnets_cidr" {
  type        = list(string)
}

# Private app subnets CIDR list
variable "private_app_subnets_cidr" {
  type        = list(string)
}

/* # Private db subnets CIDR list
variable "private_db_subnets_cidr" {
  type        = list(string)
}
*/

# Subnets availability zones
variable "az" {
  type        = list(string)
}