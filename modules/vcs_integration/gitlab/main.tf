provider "gitlab" {
  base_url = "https://${var.atlantis_gitlab_hostname}/api/v4/"
  token    = var.atlantis_gitlab_user_token
}

resource "gitlab_project_hook" "example" {
  project                 = var.project_id
  url                     = var.atlantis_url_events
  merge_requests_events   = true
  push_events             = true
  note_events             = true
  enable_ssl_verification = true
  token                   = var.atlantis_webhook_secret
}