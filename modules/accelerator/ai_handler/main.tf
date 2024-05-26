#======================= Services for running the AI handler =======================#
resource "aws_cloudwatch_log_group" "ai_handler" {
  name              = "/aws/codebuild/ai-handler-${var.repo_name}"
  retention_in_days = 7
}

resource "aws_iam_role" "codebuild_role" {
  name = "ai-handler-codebuild-${var.repo_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "codebuild_policy" {
  name = "AiHandler-${var.repo_name}-${var.region_name}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ]
        Resource = [
          "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:report-group/ai-codebuild-*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:GetParametersByPath",
          "ssm:DescribeParameters"
        ]
        Resource = [
          "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  policy_arn = aws_iam_policy.codebuild_policy.arn
  role       = aws_iam_role.codebuild_role.name
}

#Codebuild for AI request handling
resource "aws_codebuild_project" "ai_handler" {
  name          = "${var.repo_name}-ai-handler"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  source {
    type            = var.connection_provider == "GitHub" ? "GITHUB" : "BITBUCKET"
    location        = join("/", concat(["https://github.com"], [var.git_owner], [var.repo_name]))
    git_clone_depth = 1
    buildspec       = "buildspec_with_ai.yml"
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
      value = var.repo_name
    }
    environment_variable {
      name  = "OPENAI_TOKEN_NAME"
      value = var.openai_token_name
    }
    environment_variable {
      name  = "GITHUB_TOKEN_NAME"
      value = var.git_token_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.ai_handler.name
    }
  }
  depends_on = [aws_iam_role.codebuild_role]
}

resource "aws_codebuild_source_credential" "access_token_github" {
  count       = var.connection_provider == "GitHub" ? 1 : 0
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.git_token
}

#resource "aws_codebuild_source_credential" "access_token_bitbucket" {
#  count       = var.connection_provider == "Bitbucket" ? 1 : 0
#  auth_type   = "BASIC_AUTH"
#  server_type = "BITBUCKET"
#  token       = var.bitbucket_token
#  user_name   = var.bitbucket_user
#}

resource "aws_codebuild_webhook" "webhook" {
  project_name = aws_codebuild_project.ai_handler.name
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_REOPENED, PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED"
    }
  }
}
