terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.100.0"
    }
  }
}

provider "digitalocean" {
  # Configuration options
}

resource "digitalocean_domain" "main" {
  name = var.domain_name
}

resource "digitalocean_record" "dev_wildcard" {
  domain = digitalocean_domain.main.id
  type   = "A"
  name   = "*.dev"
  value  = digitalocean_loadbalancer.platform.ip
  ttl    = 300
}


resource "digitalocean_record" "dev" {
  domain = digitalocean_domain.main.id
  type   = "A"
  name   = "dev"
  value  = digitalocean_loadbalancer.platform.ip
  ttl    = 300
}