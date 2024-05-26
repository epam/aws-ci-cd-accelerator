#======================= CodeBuild for AI handler integration with GitLab =======================#
resource "aws_codebuild_project" "ai_handler_gitlab" {
  count         = var.vcs == "gitlab" ? length(var.repo_names) : 0
  name          = "ai-error-handler-${var.repo_names[count.index]}"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild_role[count.index].arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  source {
    type      = "NO_SOURCE"
    buildspec = templatefile("${var.root_directory}/../modules/core/ai_handler/buildspec_tpl/buildspec_gitlab_error.yml.tpl", {})
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "PROJECT_ID"
      value = var.project_ids[count.index]
    }
    environment_variable {
      name  = "LLM_MODEL"
      value = var.llm_model
    }
    environment_variable {
      name  = "REPO_NAME"
      value = var.repo_names[count.index]
    }
    environment_variable {
      name  = "REPO_OWNER"
      value = var.git_owner
    }
    environment_variable {
      name  = "OPENAI_TOKEN_NAME"
      value = var.openai_token_name
    }
    environment_variable {
      name  = "GIT_USER"
      value = var.git_user
    }
    environment_variable {
      name  = "GIT_TOKEN_NAME"
      value = var.git_token_name
    }
    environment_variable {
      name  = "GIT_HOSTNAME"
      value = var.git_hostname
    }
    environment_variable {
      name  = "BUCKET_NAME"
      value = local.storage_bucket
    }
    environment_variable {
      name  = "VCS"
      value = var.vcs
    }
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.ai_handler[count.index].name
    }
  }
  depends_on = [aws_iam_role.codebuild_role]
}

resource "aws_codebuild_project" "comment_handler_gitlab" {
  count         = var.vcs == "gitlab" ? length(var.repo_names) : 0
  name          = "ai-comment-handler-${var.repo_names[count.index]}"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild_role[count.index].arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  source {
    type      = "NO_SOURCE"
    buildspec = templatefile("${var.root_directory}/../modules/core/ai_handler/buildspec_tpl/buildspec_gitlab_comment.yml.tpl", {})
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "LLM_MODEL"
      value = var.llm_model
    }
    environment_variable {
      name  = "OPENAI_API_ENDPOINT"
      value = var.openai_api_endpoint
    }
    environment_variable {
      name  = "PROJECT_ID"
      value = var.project_ids[count.index]
    }
    environment_variable {
      name  = "OPENAI_TOKEN_NAME"
      value = var.openai_token_name
    }
    environment_variable {
      name  = "GIT_TOKEN_NAME"
      value = var.git_token_name
    }
    environment_variable {
      name  = "GIT_HOSTNAME"
      value = var.git_hostname
    }
    environment_variable {
      name  = "GIT_USER"
      value = var.git_user
    }
    environment_variable {
      name  = "REPO_OWNER"
      value = var.git_owner
    }
    environment_variable {
      name  = "REPO_NAME"
      value = var.repo_names[count.index]
    }
    environment_variable {
      name  = "BUCKET_NAME"
      value = local.storage_bucket
    }
    environment_variable {
      name  = "VCS"
      value = var.vcs
    }
  }
  #  vpc_config {
  #    vpc_id             = var.vpc_id
  #    subnets            = var.private_subnet_ids
  #    security_group_ids = var.security_groups
  #  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.comment_handler[count.index].name
    }
  }
  depends_on = [aws_iam_role.codebuild_role]
}
