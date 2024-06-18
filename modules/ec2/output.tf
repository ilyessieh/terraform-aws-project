#alb dns name
output "alb_dns_name" {
  value = aws_lb.wordpress_alb.dns_name
}

#alb zone id
output "alb_zone_id" {
  value = aws_lb.wordpress_alb.zone_id
}

#efs file system
output "efs_file_system_wordpress" {
  value = aws_efs_file_system.wordpress_EFS.id
}

#efs mount target
output "efs_mount_target_wordpress" {
  value = aws_efs_mount_target.efs_mount
}




