variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository"
  type        = string
}

variable "ecs_security_groups" {
  description = "A list of security group IDs to use for the ECS resources"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs in the VPC"
  type        = list(string)
}

variable "environments" {
  description = "A list of environment names for the resources"
  type        = list(string)
}

variable "desired_capacity" {
  description = "The desired capacity of the application"
  type        = list(string)
}

variable "target_group_blue_arns" {
  description = "The Amazon Resource Name (ARN) of the blue target group"
  type        = list(string)
}

variable "application_port" {
  description = "The application port for the ECS task definition"
  type        = string
}

variable "container_name" {
  description = "The container name for the ECS task definition"
  type        = string
}

variable "cpu" {
  description = "The CPU units for the ECS task definition"
  type        = number
}

variable "memory" {
  description = "The memory for the ECS task definition"
  type        = number
}

variable "aws_account_id" {
  description = "The AWS account ID to deploy to"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "accelerator_account_id" {
  description = "The AWS account ID for the global accelerator"
  type        = string
}

variable "accelerator_region" {
  description = "The AWS region for the global accelerator"
  type        = string
}

variable "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the AWS KMS key"
  type        = string
}
