variable "atlantis_url_events" {
  description = "The URL for handling Atlantis events on GitHub"
  type        = string
}

variable "git_token" {
  description = "GitHub token to use when creating a webhook"
  type        = string
}

variable "git_owner" {
  description = "GitHub owner name to use when creating a webhook"
  type        = string
}

variable "repo_names" {
  description = "The name of the infrastructure repositories on GitHub"
  type        = list(string)
}

variable "atlantis_webhook_secret" {
  description = "The secret used for securing Atlantis webhook communication on GitHub"
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
