variable "region_name" {
  description = "The name of the AWS region"
  type        = string
}
variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository (e.g. new-repo)."
  type        = string
}
variable "build_timeout" {
  description = "The time to wait for a CodeBuild to complete before timing out in minutes (default: 5)"
  type        = string
  default     = "10"
}
variable "connection_provider" {
  type        = string
  description = "Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer."
}

variable "git_owner" {
  type        = string
  description = "GitHub Repository Owner"
}

variable "github_base_url" {
  description = "GitHub base URL to use when creating a webhook (for GitHub Enterprise users)"
  type        = string
  default     = null
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
variable "git_token_name" {
  type        = string
  description = "Parameter Store Variable Name for GitHub"
}
variable "git_token" {
  type        = string
  description = "GitHub Token"
}
