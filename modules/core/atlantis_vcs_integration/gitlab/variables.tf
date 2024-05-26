variable "atlantis_url_events" {
  description = "The URL for handling Atlantis events on Git platforms"
  type        = string
}

variable "atlantis_webhook_secret" {
  description = "The secret used for securing Atlantis webhook communication on Git platforms"
  type        = string
}

variable "git_token" {
  description = "The GitLab user token for Atlantis integration"
  type        = string
  sensitive   = true
}

variable "git_hostname" {
  description = "The GitLab hostname"
  type        = string
}

variable "repo_names" {
  description = "The GitLab projects names"
  type        = list(string)
}

variable "git_owner" {
  description = "GitLab Namespace"
  type        = string
}

variable "ai_handler_create" {
  description = "To chose if deploy AI Handler module"
  type        = bool
}

variable "function_url" {
  description = "Lambda function to be triggered if PR Comment is updated"
  type        = list(string)
}
