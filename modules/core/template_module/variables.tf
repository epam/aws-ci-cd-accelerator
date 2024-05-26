variable "aws_account_id" {
  description = "The AWS account ID where the infrastructure will be deployed"
  type        = string
}

variable "root_directory" {
  description = "The root directory of the project"
  type        = string
}

variable "repo_name" {
  description = "The name of the repository"
  type        = string
}

variable "region" {
  description = "The AWS region for the deployment"
  type        = string
}

variable "stages" {
  description = "A map of stage configurations, including accounts and regions"
  type = map(object({
    account      = string
    regions      = list(string)
    region_names = list(string)
  }))
}

variable "target_type" {
  description = "The target type for the deployment"
  type        = string
}
