#======================= ParameterStore parameters for  Applications ===========================#

resource "aws_ssm_parameter" "any" {
  count       = length(var.parameter_store)
  name        = var.parameter_store[count.index].parameter_name
  description = var.parameter_store[count.index].parameter_description
  type        = "SecureString"
  value       = var.parameter_store[count.index].parameter_value
  tier        = var.parameter_store[count.index].parameter_tier
}

resource "aws_ssm_parameter" "git_token" {
  name        = "/${var.repo_name}/git/token"
  description = "Token for VCS: GitHub, Bitbucket or GitLab"
  type        = "SecureString"
  value       = var.git_token
}

resource "aws_ssm_parameter" "sonar_token" {
  name        = "/${var.repo_name}/sonar/token"
  description = "SonarCloud token for accessing sonar cloud project while code quality testing within AWS CodePipeline"
  type        = "SecureString"
  value       = var.sonarcloud_token
}

resource "aws_ssm_parameter" "teams_webhook" {
  count       = var.teams_web_hook != "" ? 1 : 0
  name        = "/${var.repo_name}/teams/web/hook"
  description = "Teams Web Hook"
  type        = "SecureString"
  value       = var.teams_web_hook
}

resource "aws_ssm_parameter" "slack_webhook" {
  count       = var.slack_web_hook != "" ? 1 : 0
  name        = "/${var.repo_name}/slack/web/hook"
  description = "Slack Web Hook"
  type        = "SecureString"
  value       = var.slack_web_hook
}

resource "aws_ssm_parameter" "rp_token" {
  count       = var.rp_token == "" ? 0 : 1
  name        = "/${var.repo_name}/report/portal/token"
  description = "Token for Report Portal"
  type        = "SecureString"
  value       = var.rp_token
}
