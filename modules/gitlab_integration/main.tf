## Integration GitLab with AWS CodePipeline
provider "gitlab" {
  base_url = "https://${var.gitlab_hostname}/api/v4/"
  token    = var.gitlab_token
}

## Create AWS CodeCommit Repository for mirroring
resource "aws_codecommit_repository" "gitlab_repo_name" {
  description     = "Mirroring repo if we use GitLab for applications"
  repository_name = var.aws_repo_name
  default_branch  = "master"
}
resource "aws_iam_user_policy" "codecommit_allow" {
  user   = var.aws_user_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codecommit:*",
        ]
        Effect   = "Allow"
        Resource = aws_codecommit_repository.gitlab_repo_name.arn
      },
    ]
  })
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
## Add SSH Public key to IAM User
resource "aws_iam_user_ssh_key" "user" {
  username   = var.aws_user_name
  encoding   = "SSH"
  public_key = tls_private_key.ssh.public_key_openssh
}

## Add variables to CI/CD Pipeline variables
resource "gitlab_project_variable" "ssh_key" {
  project   = var.project_id
  key       = "CODECOMMIT_SSH_KEY"
  value     = tls_private_key.ssh.private_key_pem
  protected = false
  variable_type = "file"
}
resource "gitlab_project_variable" "user_name" {
  project   = var.project_id
  key       = "CODECOMMIT_USER_NAME"
  value     = aws_iam_user_ssh_key.user.ssh_public_key_id
  protected = false
}
resource "gitlab_project_variable" "repo_url" {
  project   = var.project_id
  key       = "CODECOMMIT_REPO_URL"
  value     = "ssh://git-codecommit.${var.region}.amazonaws.com/v1/repos/${var.aws_repo_name}"
  protected = false
}

resource "gitlab_project_variable" "sonar_url" {
  project   = var.project_id
  key       = "SONAR_HOST_URL"
  value     = var.sonar_url
  protected = false
}
resource "gitlab_project_variable" "sonar_login" {
  project   = var.project_id
  key       = "SONAR_LOGIN"
  value     = var.sonarcloud_token
  protected = false
}
resource "gitlab_project_variable" "sonar_organization_name" {
  project   = var.project_id
  key       = "SONAR_ORGANIZATION_NAME"
  value     = var.organization_name
  protected = false
}
resource "gitlab_project_variable" "sonar_project_key" {
  project   = var.project_id
  key       = "SONAR_PROJECT_KEY"
  value     = var.project_key
  protected = false
}
resource "gitlab_project_variable" "sonar_project_name" {
  project   = var.project_id
  key       = "SONAR_PROJECT_NAME"
  value     = var.project
  protected = false
}
resource "gitlab_project_variable" "sonar_qg_timeout" {
  project   = var.project_id
  key       = "SONAR_QG_TIMEOUT"
  value     = var.sonar_timeout
  protected = false
}

resource "gitlab_project_variable" "app_language" {
  project   = var.project_id
  key       = "APP_LANGUAGE"
  value     = var.app_language
  protected = false
}