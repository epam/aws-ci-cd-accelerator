variable "project" { type = string}
variable "repo_name" { type = string }
variable "security_groups" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }
variable "vpc_id" { type = string }
variable "route53_zone_name" { type = string }
variable "health_path" {type = string}
variable "environments" { type = list(string) }
variable "target_type" { type = string }
variable "aws_acm_certificate_arn" {}
variable "region_name" {}
variable "target_port" {}