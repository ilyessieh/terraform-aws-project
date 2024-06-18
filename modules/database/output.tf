#wordpress db endpoint
output "wordpress_db_endpoint" {
  value = aws_db_instance.wordpress_db.endpoint
}

#user data
output "user_data_rendered" {
  value = data.template_file.user_data.rendered
}

#wordpress db instance
output "wordpress_db_instance" {
  value = aws_db_instance.wordpress_db
}



