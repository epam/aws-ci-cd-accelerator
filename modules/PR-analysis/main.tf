data "aws_ssm_parameter" "vcs_token" {
  name = "/${var.repo_name}/user/token"
}

resource "aws_cloudwatch_log_group" "test" {
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-pull-request-analysis"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key
}
#Codebuild for pull request testing
resource "aws_codebuild_project" "pull-request" {
  name          = "${var.repo_name}-${var.region_name}-pull-request-analysis"
  build_timeout = var.build_timeout
  service_role  = var.service_role
  encryption_key = var.aws_kms_key
  artifacts {
    type = "NO_ARTIFACTS"
  }
  source {
    type            = var.connection_provider == "GitHub" ? "GITHUB" : "BITBUCKET"
    location        = var.location
    git_clone_depth = 1
    buildspec       = "buildspec_pr.yml"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
    environment_variable {
      name  = "DOMAIN"
      value = var.codeartifact_domain
    }
    environment_variable {
      name  = "ART_REPO_ID"
      value = var.codeartifact_repo
    }
    environment_variable {
      name  = "REGION"
      value = var.region
    }
    environment_variable {
      name  = "PROJECT"
      value = var.project
    }
    environment_variable {
      name  = "REPO_NAME"
      value = var.repo_name
    }
    environment_variable {
      name  = "ORGANIZATION"
      value = var.organization_name
    }
    environment_variable {
      name  = "SONAR_TOKEN"
      value = var.sonarcloud_token_name
    }
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.test.name
    }
  }
}

resource "aws_codebuild_source_credential" "access_token_github" {
  count       = var.connection_provider == "GitHub" ? 1 : 0
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_ssm_parameter.vcs_token.value
}

resource "aws_codebuild_source_credential" "access_token_bitbucket" {
  count       = var.connection_provider == "Bitbucket" ? 1 : 0
  auth_type   = "BASIC_AUTH"
  server_type = "BITBUCKET"
  token       = data.aws_ssm_parameter.vcs_token.value
  user_name   = var.bitbucket_user
}

resource "aws_codebuild_webhook" "webhook" {
  project_name = aws_codebuild_project.pull-request.name
  filter_group {
    filter {
      type    = "EVENT"
      pattern = var.webhook_pattern
    }
  }
}