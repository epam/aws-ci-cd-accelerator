# CodeBuild Section for the Package stage
resource "aws_cloudwatch_log_group" "unit" {
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-unit"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "unit_project" {
  name           = "${var.repo_name}-${var.region_name}-unit-tests"
  description    = "The CodeBuild project for unit tests from ${var.repo_name}."
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
    privileged_mode = var.build_privileged_override

    environment_variable {
      name  = "RP_ENDPOINT"
      value = var.rp_endpoint
    }
    environment_variable {
      name  = "RP_TOKEN_NAME"
      value = var.rp_token_name
    }
    environment_variable {
      name  = "RP_PROJECT"
      value = var.rp_project
    }
  }
  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = var.security_groups
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.unit_buildspec
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.unit.name
    }
  }
}