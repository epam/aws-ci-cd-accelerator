#======================= GitHub integration with Atlantis ===========================#
provider "github" {
  token = var.git_token
  owner = var.git_owner
}

resource "github_repository_webhook" "this" {
  count = length(var.repo_names)

  repository = var.repo_names[count.index]

  configuration {
    url          = var.atlantis_url_events
    content_type = "application/json"
    insecure_ssl = false
    secret       = var.atlantis_webhook_secret
  }

  events = [
    "issue_comment",
    "pull_request",
    "pull_request_review",
    "pull_request_review_comment",
  ]
}

resource "github_repository_webhook" "ai_handler" {
  count      = var.ai_handler_create ? length(var.repo_names) : 0
  repository = var.repo_names[count.index]

  configuration {
    url          = var.function_url[count.index]
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["issue_comment", "pull_request_review_comment"]
}
