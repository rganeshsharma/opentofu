output "vpc_id" {
  description = "DigitalOcean VPC ID"
  value       = digitalocean_vpc.main.id
}

output "vpc_name" {
  description = "DigitalOcean VPC name"
  value       = digitalocean_vpc.main.name
}

output "vpc_cidr" {
  description = "DigitalOcean VPC CIDR"
  value       = digitalocean_vpc.main.ip_range
}

output "nat_gateway_id" {
  description = "DigitalOcean NAT Gateway ID"
  value       = digitalocean_vpc_nat_gateway.main.id
}

output "nat_gateway_egresses" {
  description = "NAT Gateway public egress information"
  value       = digitalocean_vpc_nat_gateway.main.egresses
}