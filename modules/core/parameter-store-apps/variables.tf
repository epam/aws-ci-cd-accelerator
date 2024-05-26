variable "parameter_store" {
  description = "List of additional AWS Parameter Store configurations"
  type = list(object({
    parameter_name        = string
    parameter_value       = string
    parameter_tier        = string
    parameter_description = string
  }))
}

variable "repo_name" {
  description = "The name of the repository"
  type        = string
}

variable "git_token" {
  description = "Token for VCS: GitHub, BitBucket or GitLab"
  type        = string
}

variable "sonarcloud_token" {
  description = "The API token for SonarCloud integration"
  type        = string
}

variable "teams_web_hook" {
  description = "The Microsoft Teams webhook URL for notifications"
  type        = string
}

variable "slack_web_hook" {
  description = "The Slack webhook URL for notifications"
  type        = string
}

variable "rp_token" {
  description = "The API token for ReportPortal integration"
  type        = string
}
