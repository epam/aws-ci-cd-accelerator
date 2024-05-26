#======================= CodeBuild for the Carier stage =======================#
resource "aws_cloudwatch_log_group" "carrier" {
  count             = var.carrier_create ? 1 : 0
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-carrier"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "carrier_project" {
  count          = var.carrier_create ? 1 : 0
  name           = "${var.repo_name}-${var.region_name}-carrier"
  description    = "The CodeBuild project for carrier tests from ${var.repo_name}."
  service_role   = var.codebuild_role
  build_timeout  = var.build_timeout
  encryption_key = var.aws_kms_key
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    dynamic "environment_variable" {
      for_each = var.report_portal_environments
      content {
        name  = environment_variable.value["name"]
        value = environment_variable.value["value"]
      }
    }
    environment_variable {
      name  = "CARRIER_URL"
      value = var.carrier_url
    }
    environment_variable {
      name  = "PROJECT_ID"
      value = var.carrier_project_id
    }
    environment_variable {
      name  = "CARRIER_TOKEN_NAME"
      value = var.carrier_token_name
    }
    environment_variable {
      name  = "TEST_ID"
      value = var.carrier_test_id
    }
  }
  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = var.security_groups
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_carrier
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.carrier[0].name
    }
  }
}
