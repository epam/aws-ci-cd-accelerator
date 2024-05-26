#======================= The GitHub webhook for AI handler =======================#
provider "github" {
  base_url = var.github_base_url
  token    = var.git_token
  owner    = var.git_owner
}

resource "github_repository_webhook" "ai_handler" {
  repository = var.repo_name

  configuration {
    url          = aws_lambda_function_url.webhook_url.function_url
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["issue_comment"]
}
