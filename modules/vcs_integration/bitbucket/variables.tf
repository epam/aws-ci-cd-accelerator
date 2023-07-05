#=================================== Bitbucket Variables ===========================#
variable "bitbucket_user" {
  description = "Bitbucket username that is running the Atlantis command"
  type        = string
}

variable "atlantis_bitbucket_user_token" {
  description = "Bitbucket token of the user that is running the Atlantis command"
  type        = string
}

variable "atlantis_bitbucket_base_url" {
  description = "Base URL of Bitbucket Server, use for Bitbucket on prem (Stash)"
  type        = string
}
variable "infra_repo_name" {
}

variable "atlantis_webhook_secret" {}
variable "atlantis_url_events" {}