#=========================== BitBucket Integration =====================#
# TODO Investigate Bitbucket providers https://registry.terraform.io/providers/zahiar/bitbucket/latest/docs or https://registry.terraform.io/providers/DrFaust92/bitbucket/latest/docs
#provider "bitbucket" {
#  username = var.bitbucket_user
#  password = var.atlantis_bitbucket_user_token # you can also use app passwords
#}

# Manage your repositories hooks
#resource "bitbucket_hook" "example" {
#  description = "Deploy the code via my webhook"
#  owner       = var.bitbucket_user
#  repository  = var.infra_repo_name
#  url         = var.atlantis_url_events
#
#  events = [
#    "pool_request:create", "pullrequest:fulfilled", "pullrequest:rejected",
#  ]
#}