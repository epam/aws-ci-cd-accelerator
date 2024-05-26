variable "admin_name" {
  description = "Login to access to the DLT WEB UI"
  type        = string
}

variable "admin_email" {
  description = "Email of the administrator responsible for managing the DLT framework"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to be used for the infrastructure"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to be used within the VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks to be used within the VPC"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "region" {
  description = "The region where infrastructure resources will be deployed"
  type        = string
}

variable "project" {
  description = "Project name used for resource tagging and naming"
  type        = string
}

variable "route53_zone_name" {
  description = "The name of the Route53 zone to be used for DNS records"
  type        = string
}

variable "region_name" {
  description = "The name of the region where infrastructure resources will be deployed (used for tagging and naming)"
  type        = string
}

variable "storage_bucket_prefix" {
  description = "The prefix to be used for naming storage bucket"
  type        = string
}

variable "enable_waf" {
  description = "Enable or disable WAF for DLT web interface"
  type        = bool
  default     = false
}
