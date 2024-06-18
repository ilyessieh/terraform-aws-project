terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["~/.aws/credentials"]
  
}

# appel du module s3-bucket
module "s3-bucket" {
  source    = "./modules/s3-bucket"

}

# appel du module security_groups
module "security_groups" {
  source    = "./modules/security_groups"
  project_vpc_id = module.networking.project_vpc_id

}

# appel du module networking
module "networking" {
  source    = "./modules/networking"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  private_app_subnets_cidr = var.private_app_subnets_cidr
  #private_db_subnets_cidr = var.private_db_subnets_cidr
  az = var.az

}

# appel du module ec2
module "ec2" {
  source    = "./modules/ec2"
  ami = var.ami
  instance_type = var.instance_type
  ssh_key_pair = var.ssh_key_pair
  project_vpc_id = module.networking.project_vpc_id
  private_app_subnets_ids = module.networking.private_app_subnets_ids
  public_subnets_ids = module.networking.public_subnets_ids
  efs_security_group_id = module.security_groups.efs_security_group_id
  bastionhost_security_group_id = module.security_groups.bastionhost_security_group_id
  alb_security_group_id = module.security_groups.alb_security_group_id
  app_server_security_group = module.security_groups.app_server_security_group
  efs_security_group = module.security_groups.efs_security_group
  user_data_rendered = module.database.user_data_rendered
  wordpress_db_instance = module.database.wordpress_db_instance

}

# appel du module database
module "database" {
  source    = "./modules/database"
  wordpressdb_subnet_grp = var.wordpressdb_subnet_grp
  az = var.az
  db_instance_type = var.db_instance_type
  database_name = var.database_name
  database_user = var.database_user
  database_password = var.database_password
  primary_rds_identifier = var.primary_rds_identifier
  replica_rds_identifier = var.replica_rds_identifier
  private_db_subnets_ids = module.networking.private_db_subnets_ids
  db_server_security_group = module.security_groups.db_server_security_group
  efs_file_system_wordpress = module.ec2.efs_file_system_wordpress
  efs_mount_target_wordpress = module.ec2.efs_mount_target_wordpress

}

# appel du module route53
module "route53" {
  source    = "./modules/route53"
  domain = var.domain
  subdomain = var.subdomain
  alb_dns_name = module.ec2.alb_dns_name
  alb_zone_id = module.ec2.alb_zone_id

}