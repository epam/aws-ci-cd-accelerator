variable "environments" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "project" {}
variable "region" {}

variable "security_groups" {
  type = list(string)
}

variable "lb_id" {}

variable "elb_target_group_arn" {}
variable "repo_name" {}
variable "instance_type" {}
variable "region_name" {}
# Numbers of instances in ASG or containers in ECS
variable "desired_capacity" { type = list(string) }
variable "max_size" { type = list(string) }
variable "min_size" { type = list(string) }
variable "artifact_bucket" {}
variable "aws_kms_key_arn" {}