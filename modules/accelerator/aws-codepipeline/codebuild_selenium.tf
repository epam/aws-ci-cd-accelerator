#======================= CodeBuild for Functional Test =======================#
resource "aws_cloudwatch_log_group" "test_selenium" {
  count             = var.selenium_create ? 1 : 0
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-selenium-${var.environments[1]}"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "test_selenium" {
  count          = var.selenium_create ? 1 : 0
  name           = "${var.repo_name}-${var.region_name}-selenium-${var.environments[1]}"
  description    = "The CodeBuild func test project for ${var.repo_name}"
  service_role   = var.codebuild_role
  build_timeout  = var.build_timeout
  encryption_key = var.aws_kms_key

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_selenium
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "APP_TARGET_URL"
      value = "https://${var.app_fqdn[1]}"
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
      group_name = aws_cloudwatch_log_group.test_selenium[0].name
    }
  }
}
