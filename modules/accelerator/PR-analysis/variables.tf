variable "vpc_id" {
  description = "The ID of the VPC to deploy resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs in the VPC"
  type        = list(string)
}

variable "security_groups" {
  description = "A list of security group IDs for the resources"
  type        = list(string)
}

variable "project_key" {
  description = "The project key identifier"
  type        = string
}

variable "organization_name" {
  description = "The name of the organization"
  type        = string
}

variable "sonar_url" {
  description = "The URL of the SonarQube server"
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

variable "git_owner" {
  type        = string
  description = "Git Repository Owner"
}

variable "build_timeout" {
  description = "The build timeout for the CodeBuild project"
  type        = string
}

variable "service_role" {
  description = "The service IAM role for the resources"
  type        = string
}

variable "connection_provider" {
  description = "The connection provider for the CodeStar connections"
  type        = string
}

variable "bitbucket_user" {
  description = "The Bitbucket username for the connection"
  type        = string
}

variable "sonarcloud_token_name" {
  description = "The name of the SonarCloud token"
  type        = string
}

variable "codeartifact_domain" {
  description = "The CodeArtifact domain name"
  type        = string
  default     = ""
}

variable "codeartifact_repo" {
  description = "The CodeArtifact repository name"
  type        = string
  default     = ""
}

variable "aws_kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the AWS KMS key"
  type        = string
}

variable "report_portal_environments" {
  description = "A list of Report Portal environments"
  type        = list(map(string))
}

variable "build_image" {
  description = "The image used for the CodeBuild environment"
  type        = string
}

variable "build_compute_type" {
  description = "The compute type used for the CodeBuild environment"
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
}
