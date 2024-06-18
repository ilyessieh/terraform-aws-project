#route53 name servers
output "route53_name_servers" {
  value = aws_route53_zone.wp_zone.name_servers
}