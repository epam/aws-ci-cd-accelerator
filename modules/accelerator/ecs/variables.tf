variable "repo_name" { type = string }
variable "region_name" { type = string }
variable "security_groups" { type = list(string) }
variable "private_subnet_ids" { type = list(string)}
variable "environments" { type = list(string) }
variable "desired_capacity" { type = list(string) }
variable "target_group_blue_arn" {}
variable "docker_container_port" {}
variable "container_name" {
  default = "application"
}
variable "cpu" {}
variable "memory" {}
variable "aws_account_id" {}
variable "package_buildspec" {}
variable "connection_provider" {}
variable "organization_name" {}
variable "repo_default_branch" {}
variable "storage_bucket" {}
variable "codeartifact_domain" {}
variable "codeartifact_repo" {}
variable "vpc_id" {}
variable "aws_kms_key" {}
variable "aws_kms_key_arn" {}
variable "region" {}
variable "execution_role" {}
variable "task_role" {}