# ID of EC2 instance AMI
variable "ami" {
  type        = string
}

# Type of instance
variable "instance_type" {
  type        = string
}

# AWS keypair
variable "ssh_key_pair" {
  type        = string
}

# subnets privés app
variable "private_app_subnets_ids" {
  type        = any
}

#security group app
variable "app_server_security_group" {
  type        = any
  
}

#efs security group
variable "efs_security_group" {
  type        = any
}

#efs sg id
variable "efs_security_group_id" {
  type        = any
}

#bastionhost sg id
variable "bastionhost_security_group_id" {
  type        = any
}

#alb sg id
variable "alb_security_group_id" {
  type        = any
}

# subnets publics ids
variable "public_subnets_ids" {
  type        = any
}

# vpc id
variable "project_vpc_id" {
  type        = any
}

#user data
variable "user_data_rendered" {
  type        = any
}

#wordpress db instance
variable "wordpress_db_instance" {
  type        = any
}



