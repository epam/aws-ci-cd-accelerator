variable "atlantis_name" {
  description = "Name to use on all resources created (VPC, ALB, etc)"
  type        = string
  default     = "atlantis"
}

variable "vpc_id" {
  description = "ID of an existing VPC where resources will be created"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC which will be created if `vpc_id` is not specified"
  type        = string
  default     = "10.0.0.0/16"
}

variable "route53_zone_name" {
  description = "Route53 zone name to create ACM certificate in and main A-record, without trailing dot"
  type        = string
}

variable "git_hostname" {
  description = "Hostname of your Git, https://www.runatlantis.io/docs/server-configuration.html#repo-allowlist"
  type        = string
  default     = "github.com"
}

variable "git_owner" {
  description = "GitHub: 'owner', GitLab: 'namespace' or Bitbucket: 'workspace'"
  type        = string
}

variable "repo_names" {
  description = "List of allowed repositories Atlantis can be used with, https://www.runatlantis.io/docs/server-configuration.html#repo-allowlist"
  type        = list(string)
}

variable "git_user" {
  description = "GitHub username that is running the Atlantis command"
  type        = string
}

variable "git_token" {
  description = "GitHub token of the user that is running the Atlantis command"
  type        = string
}


variable "vpc_nat_security_group" {
  description = "VPC NAT Security Group Id"
  type        = string
}
variable "private_subnet_ids" {
  description = "VPC private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "VPC public subnet IDs"
  type        = list(string)
}

variable "aws_account_id" {
  description = "The AWS account ID where the infrastructure will be deployed"
  type        = string
}

variable "region" {
  description = "The AWS region where the infrastructure will be deployed"
  type        = string
}

variable "atlantis_prefix_list_ids" {
  description = "Prefix lists with IPs for VCS where Terraform code is stored to connect to Atlantis"
  type        = list(string)
  default     = []
}

variable "allowed_prefix_list_ids" {
  description = "Prefix lists with IPs allowed to access to Atlantis"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB."
  type        = list(string)
  default     = []
}

variable "github_webhooks_cidr_blocks" {
  description = "List of IPv4 CIDR blocks used by GitHub webhooks"
  # This is hardcoded to avoid dependency on github provider. Source: https://api.github.com/meta
  type    = list(string)
  default = ["140.82.112.0/20", "185.199.108.0/22", "192.30.252.0/22", "143.55.64.0/20"]
}

variable "gitlab_webhooks_cidr_blocks" {
  description = "List of IPv4 CIDR blocks used by GitLab webhooks"
  type        = list(string)
  default     = ["174.128.60.0/24"]
}

variable "bitbucket_webhooks_cidr_blocks" {
  description = "List of IPv4 CIDR blocks used by BitBucket webhooks"
  type        = list(string)
  default     = ["104.192.136.0/21", "185.166.140.0/22", "18.205.93.0/25", "18.234.32.128/25", "13.52.5.0/25"]
}

variable "c7n_user" {
  type        = string
  description = "C7N User Name"
}

variable "project" {
  type        = string
  description = "Name of Project"
}

variable "storage_bucket_prefix" {
  description = "The prefix to be used for naming storage bucket"
  type        = string
}

variable "vcs" {
  type        = string
  description = "To chose module for WebHook creation. Can be: github, gitlab  or bitbucket"
}
