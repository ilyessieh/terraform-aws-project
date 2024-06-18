# Domain name
variable "domain" {
  type        = string
}

# Sub-domain name
variable "subdomain" {
  type        = string
}

# alb dns name
variable "alb_dns_name" {
  type        = any
}

# alb zone id
variable "alb_zone_id" {
  type        = any
}