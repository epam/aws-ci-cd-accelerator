variable "project" {
}
variable "region" {}
variable "vpc_range" {
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "route53_zone_name" {}

variable "tf_state_bucket" {}

variable "enable_eip" {
  description = "If you don't use your EIP by default"
  default = true
}
variable "eip" {
  description = "Your EIP"
  default = ""
}

variable "app_cidr_blocks" {
  type = list(string)
  default = []
}
variable "nat_prefix_list_ids" {
  type = list(string)
  default = []
}
variable "allowed_prefix_list_ids" {
  description = "Allowed PL to connect to AWS VPC"
  type = list(string)
  default = []
}
variable "atlantis_prefix_list_ids" {
  description = "PL for VCS, for example: EPAM GitLab IP "
  type = list(string)
  default = []
}
variable "atlantis_cidr_blocks" {
  description = "Cidr blocks for Atlantis: VCS and admin locations"
  type = list(string)
  default = []
}

variable "github_user" {
  default = ""
}
variable "gitlab_user" {
  default = ""
}
variable "bitbucket_user" {
  default = ""
}