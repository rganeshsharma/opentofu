resource "digitalocean_droplet" "gpu_node" {

  name     = "${var.project_name}-gpu-node"
  region   = var.region
  image    = var.gpu_image
  size     = var.gpu_size
  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [
    digitalocean_ssh_key.ai_lab.fingerprint
  ]
  tags = [
    digitalocean_tag.rke2_gpu.name
  ]
  monitoring        = false
  backups           = false
  graceful_shutdown = true
}