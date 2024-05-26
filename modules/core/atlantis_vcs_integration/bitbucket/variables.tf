variable "git_owner" {
  description = "Repository Owner, Workspace ID"
  type        = string
}
variable "git_user" {
  description = "The Bitbucket username associated with the Atlantis command"
  type        = string
}

variable "git_token" {
  description = "The Bitbucket token for the user running the Atlantis command"
  type        = string
}

variable "repo_names" {
  description = "Names of the infrastructure repository"
  type        = list(string)
}

variable "atlantis_url_events" {
  description = "The URL for handling Atlantis events"
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
