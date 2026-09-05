resource "digitalocean_loadbalancer" "platform" {
  name     = "${var.project_name}-lb"
  region   = var.region
  size     = "lb-small"
  vpc_uuid = digitalocean_vpc.main.id
  forwarding_rule {
    entry_protocol  = "https"
    entry_port      = 443
    target_protocol = "https"
    target_port     = 443
  }
  healthcheck {
    port     = 22
    protocol = "tcp"
  }
  droplet_ids = [digitalocean_droplet.cpu_node.id]
}