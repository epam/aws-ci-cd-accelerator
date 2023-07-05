variable "project" {}
variable "region_name" {}
variable "aws_account_id" {}
variable "repo_name" {}
variable "region" {}
variable "private_subnet_ids" {
  type = list(string)
}

variable "aws_kms_key" {}
variable "aws_kms_key_arn" {}
variable "target_type" {}
variable "eks_role_arn" {}
variable "connection_provider" {}
variable "vpc_id" {}
variable "storage_bucket_arn" {}
variable "build_artifact_bucket_arn" {}