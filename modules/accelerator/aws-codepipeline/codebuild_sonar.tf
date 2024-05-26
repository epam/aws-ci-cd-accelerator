#======================= CodeBuild for the Sonar Test =======================#
resource "aws_cloudwatch_log_group" "test" {
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-test"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "test_project" {
  name           = "${var.repo_name}-${var.region_name}-sonar-test"
  description    = "The CodeBuild project for Sonar Test ${var.repo_name}"
  service_role   = var.codebuild_role
  build_timeout  = var.build_timeout
  encryption_key = var.aws_kms_key

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = var.build_compute_type
    image        = var.build_image
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.id
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

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_sonar
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.test.name
    }
  }
}
