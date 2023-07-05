provider "github" {
  token = var.atlantis_github_user_token
  owner = var.organization_name
}

resource "github_repository_webhook" "atlantis" {
  repository = var.infra_repo_name

  configuration {
    url          = var.atlantis_url_events
    content_type = "application/json"
    insecure_ssl = false
    secret       = var.atlantis_webhook_secret
  }

  active = true

  events = ["pull_request", "push", "pull_request_review", "issue_comment"]
}