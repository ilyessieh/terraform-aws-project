#subnets privés database
output "private_db_subnets_ids" {
  #value = aws_subnet.private_db_subnets.*.id
  value = aws_subnet.private_app_subnets.*.id
}

#subnets privés app
output "private_app_subnets_ids" {
  value = aws_subnet.private_app_subnets.*.id
}


#subnets publics id
output "public_subnets_ids" {
  value = aws_subnet.public_subnets.*.id
}

#vpc id
output "project_vpc_id" {
  value = aws_vpc.project_vpc.id
}


