data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

##======================= Resources for AI handler =======================#
resource "aws_cloudwatch_log_group" "ai_handler" {
  count             = length(var.repo_names)
  name              = "/aws/codebuild/ai-handler-${var.repo_names[count.index]}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "comment_handler" {
  count             = length(var.repo_names)
  name              = "/aws/codebuild/comment-handler-${var.repo_names[count.index]}"
  retention_in_days = 7
}

##====================== Codebuild for AI request handling ======================##
resource "aws_codebuild_project" "ai_handler" {
  count         = var.vcs == "bitbucket" || var.vcs == "github" ? length(var.repo_names) : 0
  name          = "ai-error-handler-${var.repo_names[count.index]}"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild_role[count.index].arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  source {
    type            = var.server_type
    location        = join("/", concat(["https://${var.git_hostname}"], [var.git_owner], [var.repo_names[count.index]]))
    git_clone_depth = 1
    buildspec       = "modules/core/ai_handler/buildspec_error.yml"
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
      name  = "REPO_NAME"
      value = var.repo_names[count.index]
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
      name  = "GIT_USER"
      value = var.git_user
    }
    environment_variable {
      name  = "REPO_OWNER"
      value = var.git_owner
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
  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = var.security_groups
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.ai_handler[count.index].name
    }
  }
  depends_on = [aws_iam_role.codebuild_role]
}

##====================== CodeBuild for PR Comments processing ======================##
resource "aws_codebuild_project" "comment_handler" {
  count         = var.vcs == "bitbucket" || var.vcs == "github" ? length(var.repo_names) : 0
  name          = "ai-comment-handler-${var.repo_names[count.index]}"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild_role[count.index].arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  source {
    type            = var.server_type
    location        = join("/", concat(["https://${var.git_hostname}"], [var.git_owner], [var.repo_names[count.index]]))
    git_clone_depth = 1
    buildspec       = "modules/core/ai_handler/buildspec_comment.yml"
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
      name  = "REPO_NAME"
      value = var.repo_names[count.index]
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
      name  = "GIT_USER"
      value = var.git_user
    }
    environment_variable {
      name  = "REPO_OWNER"
      value = var.git_owner
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
  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = var.security_groups
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.comment_handler[count.index].name
    }
  }
  depends_on = [aws_iam_role.codebuild_role]
}

resource "aws_codebuild_source_credential" "access_token_github" {
  count       = var.server_type == "GITHUB" ? 1 : 0
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.git_token
}

resource "aws_codebuild_source_credential" "access_token_bitbucket" {
  count       = var.server_type == "BITBUCKET" ? 1 : 0
  auth_type   = "BASIC_AUTH"
  server_type = "BITBUCKET"
  token       = var.git_token
  user_name   = var.git_user
}
