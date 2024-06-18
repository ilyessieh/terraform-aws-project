


# RDS subnet group name
variable "wordpressdb_subnet_grp" {
  type        = string
}


# Subnets availability zones
variable "az" {
  type        = list(string)
}

# Type of RDS instance
variable "db_instance_type" {
  type        = string
}

# RDS instance name
variable "database_name" {
  type        = string
}

# RDS instance username
variable "database_user" {
  type        = string
}

# RDS instance password
variable "database_password" {
  type        = string
}

# RDS primary instance identity
variable "primary_rds_identifier" {
  type        = string
}

# RDS replica identity
variable "replica_rds_identifier" {
  type        = string
}

# private subnets ids
variable "private_db_subnets_ids" {
  type        = any
}

# security group database
variable "db_server_security_group" {
  type        = any
}

#efs file system
variable "efs_file_system_wordpress" {
  type        = any
}

#efs mount target
variable "efs_mount_target_wordpress" {
  type        = any
}
