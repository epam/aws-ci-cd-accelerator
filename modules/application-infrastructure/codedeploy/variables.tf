variable "asg_name" {
  description = "A list of Auto Scaling group names"
  type        = list(string)
}

variable "target_group_green_names" {
  description = "A list of green target group names"
  type        = list(string)
}

variable "target_group_blue_names" {
  description = "A list of blue target group names"
  type        = list(string)
}

variable "desired_capacity" {
  description = "The desired capacity of the resources"
  type        = list(string)
}

variable "conf_all_at_once" {
  description = "Configuration for deploying all instances at once"
  type        = string
}

variable "conf_one_at_time" {
  description = "Configuration for deploying one instance at a time"
  type        = string
}

variable "target_type" {
  description = "The target type of the resources"
  type        = string
}

variable "main_listener" {
  description = "The main listener configuration"
  type        = string
}

variable "termination_wait_time_in_minutes" {
  description = "The termination wait time in minutes for instances"
  type        = number
  default     = 0
}

variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo)"
  type        = string
}

variable "environments" {
  description = "A list of environment names for the resources"
  type        = list(string)
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "A list of ECS service names"
  type        = list(string)
}

variable "accelerator_account_id" {
  description = "The AWS account ID for the Accelerator CI/CD"
  type        = string
}

variable "codedeploy_role_arns" {
  description = "A list of CodeDeploy role ARNs"
  type        = list(string)
}

variable "artifact_bucket_prefix" {
  description = "The prefix for the artifacts bucket"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "codedeploy_role_create" {
  description = "Whether to create a new CodeDeploy IAM role"
  type        = bool
}
