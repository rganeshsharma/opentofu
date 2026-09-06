resource "digitalocean_vpc_nat_gateway" "main" {
  name   = "blr-ai-nat-gateway"
  type   = "PUBLIC"
  region = var.region
  size   = "1"

  vpcs {
    vpc_uuid        = digitalocean_vpc.main.id
    default_gateway = true
  }

  tcp_timeout_seconds  = 300
  udp_timeout_seconds  = 30
  icmp_timeout_seconds = 30
}