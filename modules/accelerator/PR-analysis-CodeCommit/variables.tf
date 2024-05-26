variable "service_role" {
  description = "The service role for the deployment"
  type        = string
}

variable "repo_name" {
  description = "The name of the repository"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID where the infrastructure will be deployed"
  type        = string
}

variable "region" {
  description = "The AWS region for the deployment"
  type        = string
}

variable "project" {
  description = "The project name used for resource tagging and naming"
  type        = string
}

variable "organization_name" {
  description = "The name of the organization"
  type        = string
}
variable "sonarcloud_token_name" {
  description = "The name of the SonarCloud token"
  type        = string
}

variable "codeartifact_domain" {
  description = "The AWS CodeArtifact domain"
  type        = string
  default     = ""
}

variable "codeartifact_repo" {
  description = "The AWS CodeArtifact repository"
  type        = string
  default     = ""
}

variable "build_image" {
  description = "The image used for the CodeBuild environment"
  type        = string
}
