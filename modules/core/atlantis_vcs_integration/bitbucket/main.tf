#======================= BitBucket integration with Atlantis ===========================#
# Bitbucket providers https://registry.terraform.io/providers/zahiar/bitbucket/latest/docs or https://registry.terraform.io/providers/DrFaust92/bitbucket/latest/docs
# We use https://registry.terraform.io/providers/DrFaust92/bitbucket/latest/docs
provider "bitbucket" {
  username = var.git_user
  password = var.git_token # you can also use app passwords
}

# Manage your repositories hooks
resource "bitbucket_hook" "this" {
  count       = length(var.repo_names)
  description = "Deploy the code via my webhook"
  owner       = var.git_owner
  repository  = var.repo_names[count.index]
  url         = var.atlantis_url_events
  #  secret          = var.atlantis_webhook_secret
  history_enabled = true
  events = [
    "pullrequest:created",
    "pullrequest:fulfilled",
    "pullrequest:rejected",
    "pullrequest:updated",
    "pullrequest:comment_created",
  ]
}

# Manage your repositories hooks
resource "bitbucket_hook" "ai_handler" {
  count       = var.ai_handler_create ? length(var.repo_names) : 0
  description = "Deploy the code via my webhook"
  owner       = var.git_owner
  repository  = var.repo_names[count.index]
  url         = var.function_url[count.index]
  #  secret          = var.atlantis_webhook_secret
  history_enabled = true
  events = [
    "pullrequest:comment_updated",
    "pullrequest:comment_created",
  ]
}
