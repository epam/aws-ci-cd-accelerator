#======================= # CodeBuild for the DLT Performance Test =======================#
resource "aws_cloudwatch_log_group" "dlt" {
  count             = var.dlt_create ? 1 : 0
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-dlt"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "dlt" {
  count          = var.dlt_create ? 1 : 0
  name           = "${var.repo_name}-${var.region_name}-dlt"
  service_role   = var.codebuild_role
  build_timeout  = var.build_timeout
  encryption_key = var.aws_kms_key
  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_dlt
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = var.build_compute_type
    image        = var.build_image
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "APP_TARGET_URL"
      value = "https://${var.app_fqdn[1]}"
    }
    environment_variable {
      name  = "DLT_UI_URL"
      value = var.dlt_ui_url
    }
    environment_variable {
      name  = "COGNITO_PASSWORD_NAME"
      value = var.cognito_password_name
    }
    environment_variable {
      name  = "COGNITO_USER"
      value = var.admin_name
    }
    environment_variable {
      name  = "DLT_API_HOST"
      value = var.dlt_api_host
    }
    environment_variable {
      name  = "DLT_ALIAS"
      value = var.dlt_fqdn
    }
    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }
    environment_variable {
      name  = "COGNITO_USER_POOL_ID"
      value = var.cognito_user_pool_id
    }
    environment_variable {
      name  = "COGNITO_CLIENT_ID"
      value = var.cognito_client_id
    }
    environment_variable {
      name  = "COGNITO_IDENTITY_POOL_ID"
      value = var.cognito_identity_pool_id
    }
    environment_variable {
      name  = "TEST_NAME"
      value = var.dlt_test_name
    }
    environment_variable {
      name  = "TEST_ID"
      value = var.dlt_test_id
    }
    environment_variable {
      name  = "TEST_TYPE"
      value = var.dlt_test_type
    }
    environment_variable {
      name  = "TASK_COUNT"
      value = var.dlt_task_count
    }
    environment_variable {
      name  = "CONCURRENCY"
      value = var.concurrency
    }
    environment_variable {
      name  = "RAMP_UP"
      value = var.ramp_up
    }
    environment_variable {
      name  = "HOLD_FOR"
      value = var.hold_for
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
      group_name = aws_cloudwatch_log_group.dlt[0].name
    }
  }
}
