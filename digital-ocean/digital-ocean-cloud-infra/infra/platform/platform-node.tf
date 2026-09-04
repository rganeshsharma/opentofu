resource "digitalocean_droplet" "cpu_node" {
  name   = "${var.project_name}-platform-droplet"
  region = var.region
  image  = var.cpu_image
  size   = var.cpu_size
  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [
    digitalocean_ssh_key.ai_lab.fingerprint
  ]
  tags = [
    digitalocean_tag.rke2_cpu.name
  ]
  monitoring = false
  backups = false
  graceful_shutdown = true

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: false
    packages:
      - curl
      - wget
      - git
      - jq
      - unzip
      - vim
      - htop
      - nfs-common
      - open-iscsi
    runcmd:
      - systemctl enable --now iscsid
  EOF
}