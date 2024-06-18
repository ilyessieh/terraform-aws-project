#security group db
output "db_server_security_group" {
  value = aws_security_group.db_server_sg.id
}

#security group app
output "app_server_security_group" {
  value = aws_security_group.app_server_sg.id
}

#efs security group
output "efs_security_group" {
  value = aws_security_group.efs_sg.id
}


#efs sg id
output "efs_security_group_id" {
  value = aws_security_group.efs_sg.id
}

#bastionhost sg id
output "bastionhost_security_group_id" {
  value = aws_security_group.bastionhost_sg.id
}

#alb sg id
output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}