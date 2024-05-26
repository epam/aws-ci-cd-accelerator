#======================= Sect parameters for Atlantis ===========================#
resource "aws_ssm_parameter" "atlantis_git_token" {
  name        = "/atlantis/git/user/token"
  description = "GitHub Token"
  type        = "SecureString"
  value       = var.git_token
}

resource "aws_ssm_parameter" "atlantis_webhook_secret" {
  name        = "/atlantis/webhook/secret"
  description = "Atlantis webhook secret"
  type        = "SecureString"
  value       = random_password.webhook_secret.result
}
