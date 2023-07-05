#=============================== GitHub Variables ==========================#
variable "atlantis_url_events" {}

variable "infra_repo_name" {
}
variable "atlantis_webhook_secret" {}

#==================================== GitLab Variables =======================#
variable "atlantis_gitlab_user_token" {
  sensitive = true
}
variable "atlantis_gitlab_hostname" {
}
variable "project_id" {
}