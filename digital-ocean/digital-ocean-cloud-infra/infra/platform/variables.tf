variable "region" {
  description = "DigitalOcean region"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR range for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}



variable "project_name" {
  description = "Project prefix used for DigitalOcean resources"
  type        = string
}

variable "admin_cidrs" {
  description = "Public CIDR addresses allowed to access SSH and Kubernetes API"
  type = list(string)
  validation {
    condition     = length(var.admin_cidrs) > 0
    error_message = "At least one admin CIDR must be provided."
  }
}

variable "cpu_image" {
  description = "CPU node operating system"
  type        = string
  default     = "ubuntu-24-04-x64"
}


variable "cpu_size" {
  description = "CPU node Droplet size"
  type        = string
  default     = "s-4vcpu-8gb"
}


variable "gpu_image" {
  description = "GPU node image"
  type        = string
  default     = "ubuntu-24-04-x64"
}


variable "gpu_size" {
  description = "GPU Droplet size"
  type        = string
  default     = "gpu-l40sx1-48gb"
}


variable "platform_volume_size" {
  description = "Persistent platform block storage size in GiB"
  type        = number
  default     = 200
}


variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/do-ai-lab.pub"
}