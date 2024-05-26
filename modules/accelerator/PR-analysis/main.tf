#======================= Codebuild for pull request analysis =======================#
data "aws_ssm_parameter" "vcs_token" {
  name = "/${var.repo_name}/git/token"
}

resource "aws_cloudwatch_log_group" "test" {
  name              = "/aws/codebuild/${var.repo_name}-sonar-pull-request-analysis"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "pull_request" {
  name           = "${var.repo_name}-sonar-pull-request-analysis"
  build_timeout  = var.build_timeout
  service_role   = var.service_role
  encryption_key = var.aws_kms_key_arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  source {
    type            = var.connection_provider == "GitHub" ? "GITHUB" : "BITBUCKET"
    location        = var.connection_provider == "GitHub" ? "https://github.com/${var.git_owner}/${var.repo_name}" : "https://bitbucket.org/${var.git_owner}/${var.repo_name}"
    git_clone_depth = 1
    buildspec       = "buildspec_pr.yml"
  }
  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
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
      name  = "PROJECT_KEY"
      value = var.project_key
    }
    environment_variable {
      name  = "SONAR_URL"
      value = var.sonar_url
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
      name  = "SONAR_TOKEN_NAME"
      value = var.sonarcloud_token_name
    }
    environment_variable {
      name  = "LLM_MODEL"
      value = var.llm_model
    }
    environment_variable {
      name  = "OPENAI_API_ENDPOINT"
      value = var.openai_api_endpoint
    }
    environment_variable {
      name  = "OPENAI_TOKEN_NAME"
      value = var.openai_token_name
    }
    environment_variable {
      name  = "GITHUB_TOKEN_NAME"
      value = "/${var.repo_name}/git/token"
    }
    dynamic "environment_variable" {
      for_each = var.report_portal_environments
      content {
        name  = environment_variable.value["name"]
        value = environment_variable.value["value"]
      }
    }
  }
  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = var.security_groups
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.test.name
    }
  }
}

resource "aws_codebuild_source_credential" "access_token_github" {
  count       = contains(["GitHub", "GitHubEnterpriseServer"], var.connection_provider) ? 1 : 0
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = var.connection_provider == "GitHub" ? "GITHUB" : "GITHUB_ENTERPRISE"
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
  project_name = aws_codebuild_project.pull_request.name
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_REOPENED, PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED"
    }
  }
}
