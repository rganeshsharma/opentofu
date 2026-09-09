resource "digitalocean_volume" "platform_data" {
  region      = var.region
  name        = "platform-data"
  size        = 20
  description = "RKE2 platform persistent storage"
}

resource "digitalocean_volume_attachment" "platform_data" {

  droplet_id = digitalocean_droplet.cpu_node.id
  volume_id  = digitalocean_volume.platform_data.id
}