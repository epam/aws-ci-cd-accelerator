#======================= GitLab integration with Atlantis ===========================#
provider "gitlab" {
  base_url = "https://${var.git_hostname}/api/v4/"
  token    = var.git_token
}

resource "gitlab_project_hook" "this" {
  count                   = length(var.repo_names)
  project                 = "${var.git_owner}/${var.repo_names[count.index]}"
  url                     = var.atlantis_url_events
  merge_requests_events   = true
  push_events             = true
  note_events             = true
  enable_ssl_verification = true
  token                   = var.atlantis_webhook_secret
}

resource "gitlab_project_hook" "ai_handler" {
  count   = var.ai_handler_create ? length(var.repo_names) : 0
  project = "${var.git_owner}/${var.repo_names[count.index]}"

  url                   = var.function_url[count.index]
  push_events           = false
  issues_events         = false
  merge_requests_events = false
  tag_push_events       = false
  note_events           = true

  enable_ssl_verification = true
}
