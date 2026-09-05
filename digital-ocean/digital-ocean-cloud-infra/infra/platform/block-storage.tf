resource "digitalocean_volume" "platform_data" {
  region                   = var.region
  name                     = "${var.project_name}-platform-data"
  size                     = var.platform_volume_size
  initial_filesystem_type  = "xfs"
  initial_filesystem_label = "platform-data"
  description              = "Persistent storage for AI platform lab"
  tags = [
    digitalocean_tag.rke2_cpu.name
  ]
}

resource "digitalocean_volume_attachment" "platform_data" {

  droplet_id = digitalocean_droplet.cpu_node.id
  volume_id  = digitalocean_volume.platform_data.id
}