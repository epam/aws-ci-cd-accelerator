variable "project" {
  description = "The project name"
  type        = string
}

variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository"
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs in the VPC"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy resources"
  type        = string
}

variable "route53_zone_name" {
  description = "The Route53 zone name"
  type        = string
}

variable "dns_record_names" {
  description = "Route53 Record Name for Stages"
  type        = list(string)
}

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "health_path" {
  description = "The health check PATH for the application"
  type        = string
}

variable "environments" {
  description = "A list of environment names for the resources"
  type        = list(string)
}

variable "target_type" {
  description = "The target type of the resources"
  type        = string
}

variable "aws_acm_certificate_arn" {
  description = "The Amazon Resource Name (ARN) of the AWS Certificate Manager certificate"
  type        = string
}

variable "target_port" {
  description = "The target port for the resources"
  type        = string
}

variable "allowed_prefix_list_ids" {
  description = "Allowed prefix list IDs for access to the application"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks for access to the application"
  type        = list(string)
}

variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
}

variable "nat_security_group_id" {
  description = "The security group ID of the NAT gateway"
  type        = string
}

variable "alb_access_logs" {
  description = "Enabled ALB Access Logs"
  type        = bool
}

variable "kms_key_arn" {
  type        = string
  description = "KMS Key to encrypt logs "
}
