variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID to deploy to"
  type        = string
}

variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo)"
  type        = string
}

variable "force_destroy" {
  description = "Whether to forcefully destroy resources (default: false)"
  type        = bool
  default     = false
}

variable "target_type" {
  description = "The target type of the deployed resources"
  type        = string
}

variable "key_service_users" {
  description = "A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration)"
  type        = list(string)
}

variable "account_identifiers" {
  description = "A list of AWS account identifiers"
  type        = list(string)
}

variable "kms_identifiers" {
  description = "A list of role ARNs for KMS"
  type        = list(string)
}

variable "artifact_bucket_identifiers" {
  description = "A list of identifiers for the artifact bucket"
  type        = list(string)
}

variable "artifact_bucket_prefix" {
  description = "The prefix for the artifacts bucket"
  type        = string
}

variable "service_bucket_prefix" {
  description = "The prefix for the service bucket where we store task definition files for ECS or EC2 script"
  type        = string
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

variable "stages" {
  description = "A map of stage configurations, including AWS accounts, regions, and region names"
  type = map(object({
    account      = string
    regions      = list(string)
    region_names = list(string)
  }))
}

variable "env_vars" {
  description = "A map of environment variables for the ECS task definition"
  type        = map(list(map(string)))
}

variable "secrets" {
  description = "A map of secret values for the ECS task definition"
  type        = map(list(map(string)))
}

variable "image_tag_mutability" {
  description = "Mutability of docker image tag of application"
  type        = string
}
