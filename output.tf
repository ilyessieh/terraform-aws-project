# EFS ID
output "EFS_ID" {
  value = module.ec2.efs_file_system_wordpress
}

# RDS endpoint
output "RDS_endpoint" {
  value = module.database.wordpress_db_endpoint
}

# Loadbalancer DNS name
output "ALB_DNS" {
  value = module.ec2.alb_dns_name
}

# NS records
output "name_servers" {
  value       = module.route53.route53_name_servers
  description = "records of domain name servers"
}