variable "project" {
  description = "Identifier for the project"
  type        = string
}
variable "region_name" {
  description = "The name of the AWS region"
  type        = string
}
variable "aws_account_id" {
  description = "The AWS account ID where resources will be created"
  type        = string
}
variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository"
  type        = string
}
variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
}
variable "private_subnet_ids" {
  description = "List of VPC Private Subnet IDs"
  type        = list(string)
}
variable "target_type" {
  description = "Type of the deployment target (i.e., instance, lambda, or ecs)"
  type        = string
}
variable "eks_role_arn" {
  description = "ARN of the IAM role used by EKS"
  type        = string
}
variable "service_bucket_arn" {
  description = "ARN of the S3 bucket where service files are stored"
  type        = string
}
variable "codedeploy_role_arns" {
  description = "List of Role ARNs for AWS CodeDeploy"
  type        = list(string)
}
variable "stages" {
  description = "Map of stage settings. Each stage is a map including account id, regions, and region names"
  type = map(object({
    account      = string
    regions      = list(string)
    region_names = list(string)
  }))
}
variable "artifact_bucket_prefix" {
  description = "Prefix for the S3 bucket where the artifacts are stored"
  type        = string
}
