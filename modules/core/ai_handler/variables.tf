variable "project" {
  description = "Project name used for resource tagging and naming"
  type        = string
}

variable "region" {
  description = "The AWS Region where infrastructure resources will be deployed"
  type        = string
}

variable "storage_bucket_prefix" {
  description = "The prefix to be used for naming storage buckets"
  type        = string
}
variable "region_name" {
  type        = string
  description = "AWS Region Name for better naming, e.g. frankfurt, ireland"
}
variable "repo_names" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repositories connected with Atlantis"
  type        = list(string)
}

variable "git_user" {
  description = "Bitbucket User Name"
  type        = string
}

variable "vcs" {
  description = "VCS for AI: github, bitbucket or gitlab. "
  type        = string
}

variable "git_owner" {
  type        = string
  description = "GitHub Repository Owner"
}

variable "git_hostname" {
  description = "Git URL"
  type        = string
}
variable "llm_model" {
  description = "LLM Model for AI"
  type        = string
}
variable "openai_api_endpoint" {
  type        = string
  description = "Open AI Endpoint"
}
variable "openai_token_name" {
  type        = string
  description = "Parameter Store Variable Name for OPEN AI API KEY"
  default     = "/accelerator/openai_token"
}
variable "git_token_name" {
  type        = string
  description = "Parameter Store Variable Name for Git Token"
  default     = "/atlantis/git/user/token"
}
variable "git_token" {
  type        = string
  description = "GitHub Token"
}

variable "vpc_id" {
  description = "ID of an existing VPC where resources will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "VPC Private Subnet IDs"
  type        = list(string)
}

variable "security_groups" {
  description = "Security Groups for Lambda-Git Connection"
  type        = list(string)
}

variable "server_type" {
  type        = string
  description = "Valid values are BITBUCKET, GITHUB"
}

variable "root_directory" {
  type        = string
  description = "Root directory of terragrunt"
}

variable "project_ids" {
  type        = list(string)
  description = "List of GitLab projects for working with API"
}
