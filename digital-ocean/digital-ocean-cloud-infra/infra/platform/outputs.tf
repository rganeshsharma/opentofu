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

output "rke2_firewall_id" {
  description = "DigitalOcean RKE2 Cloud Firewall ID"
  value       = digitalocean_firewall.rke2.id
}


output "rke2_cpu_tag" {
  description = "Tag assigned to RKE2 CPU nodes"
  value       = digitalocean_tag.rke2_cpu.name
}


output "rke2_gpu_tag" {
  description = "Tag assigned to RKE2 GPU nodes"
  value       = digitalocean_tag.rke2_gpu.name
}