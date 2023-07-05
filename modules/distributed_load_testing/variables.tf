variable "admin_name" {}
variable "admin_email" {}
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "vpc_cidr_block" {}
variable "storage_bucket" {}
variable "region" {}
variable "repo_name" {}
variable "aws_acm_certificate_arn" {}
variable "route53_zone_name" {}
variable "region_name" {}