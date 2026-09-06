# Tags
resource "digitalocean_tag" "rke2_cpu" {
  name = "${var.project_name}-rke2-cpu"
}
resource "digitalocean_tag" "rke2_gpu" {
  name = "${var.project_name}-rke2-gpu"
}

# RKE2 Cloud Firewall
resource "digitalocean_firewall" "rke2" {
  name = "${var.project_name}-rke2-fw"
  # Any future Droplet with either tag automatically receives
  # this firewall policy.
  tags = [
    digitalocean_tag.rke2_cpu.name,
    digitalocean_tag.rke2_gpu.name
  ]

  # INBOUND SSH
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.admin_cidrs
  }

  # Kubernetes API Server
  # Allows kubectl from your workstation.
  inbound_rule {
    protocol   = "tcp"
    port_range = "6443"

    source_addresses = concat(
      var.admin_cidrs,
      [digitalocean_vpc.main.ip_range]
    )
  }


  # RKE2 supervisor / registration
  inbound_rule {
    protocol   = "tcp"
    port_range = "9345"
    source_addresses = [
      digitalocean_vpc.main.ip_range
    ]
  }

  # Kubernetes internal TCP
  inbound_rule {
    protocol   = "tcp"
    port_range = "1-65535"
    source_addresses = [
      digitalocean_vpc.main.ip_range
    ]
  }

  # Kubernetes internal UDP
  inbound_rule {
    protocol   = "udp"
    port_range = "1-65535"
    source_addresses = [
      digitalocean_vpc.main.ip_range
    ]
  }

  # ICMP within the VPC
  inbound_rule {
    protocol = "icmp"

    source_addresses = [
      digitalocean_vpc.main.ip_range
    ]
  }

  # OUTBOUND
  # HTTPS / package repositories / container registries / APIs
  outbound_rule {
    protocol   = "tcp"
    port_range = "1-65535"
    destination_addresses = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # DNS / Kubernetes / overlay networking / etc.
  outbound_rule {
    protocol   = "udp"
    port_range = "1-65535"
    destination_addresses = [
      "0.0.0.0/0",
      "::/0"
    ]
  }


  # Troubleshooting / PMTU / ping
  outbound_rule {
    protocol = "icmp"
    destination_addresses = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}