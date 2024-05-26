#======================= CodeBuild for the Package stage =======================#
data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "package" {
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-package"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "build_project" {
  name           = "${var.repo_name}-${var.region_name}-package"
  description    = "The CodeBuild project for creating artifact from ${var.repo_name}."
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

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
    dynamic "environment_variable" {
      for_each = var.target_type != "instance" ? [1] : [0]
      content {
        name  = "TRIVY_SEVERITY"
        value = var.tryvi_severity
      }
    }
    dynamic "environment_variable" {
      for_each = var.target_type != "instance" ? [1] : [0]
      content {
        name  = "IMAGE_REPO_NAME"
        value = var.ecr_repo_name
      }
    }
    environment_variable {
      name  = "BUCKET"
      value = var.service_bucket
    }
    environment_variable {
      name  = "DOMAIN"
      value = var.codeartifact_domain
    }
    environment_variable {
      name  = "ART_REPO_ID"
      value = var.codeartifact_repo
    }
  }
  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = var.security_groups
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_package
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.package.name
    }
  }
}
