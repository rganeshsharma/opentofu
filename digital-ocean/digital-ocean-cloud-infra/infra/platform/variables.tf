variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "blr1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "blr-ai-vpc"
}

variable "vpc_cidr" {
  description = "CIDR range for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}