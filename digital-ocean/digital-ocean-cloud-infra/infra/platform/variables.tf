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

variable "s3endpoint" {
  description = "Tofu backend Spaces Bucket URL"
  type        = string
  sensitive   = true
}

variable "spaces-tofu-state-bucket" {
  description = "Tofu backend Spaces Bucket Name"
  type        = string
}

variable "project_name" {
  description = "Project prefix used for DigitalOcean resources"
  type        = string
}

variable "admin_cidrs" {
  description = "Public CIDR addresses allowed to access SSH and Kubernetes API"
  type        = list(string)
  validation {
    condition     = length(var.admin_cidrs) > 0
    error_message = "At least one admin CIDR must be provided."
  }
}