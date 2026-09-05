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

output "load_balancer_ip" {
  value = digitalocean_loadbalancer.platform.ip
}

output "domain" {
  value = digitalocean_domain.main.name
}

output "wildcard_record" {
  value = "*.${digitalocean_record.dev_wildcard.name}.${digitalocean_domain.main.name}"
}

output "platform_volume_id" {
  value = digitalocean_volume.platform_data.id
}


output "ssh_command_cpu" {
  value = "ssh -i ~/.ssh/do-ai-lab root@${digitalocean_droplet.cpu_node.ipv4_address}"
}


output "ssh_command_gpu" {
  value = "ssh -i ~/.ssh/do-ai-lab root@${digitalocean_droplet.gpu_node.ipv4_address}"
}