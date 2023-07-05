# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A CI/CD PIPELINE WITH CODECOMMIT USING AWS
# This module creates a CodePipeline with CodeBuild that is linked to a GitHub repository.
# ---------------------------------------------------------------------------------------------------------------------

# AWS Account ID
data "aws_caller_identity" "current" {}

# CodeBuild Section for the Package stage
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
    privileged_mode = var.build_privileged_override

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.image_repo_name
    }
    environment_variable {
      name  = "BUCKET"
      value = var.storage_bucket
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
    buildspec = var.package_buildspec
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.package.name
    }
  }
}

# CodeBuild Section for the Test stage
resource "aws_cloudwatch_log_group" "test" {
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-test"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "test_project" {
  name           = "${var.repo_name}-${var.region_name}-test"
  description    = "The CodeBuild project for ${var.repo_name}"
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
      name  = "BUCKET"
      value = var.storage_bucket
    }
    environment_variable {
      name  = "SONAR_TOKEN"
      value = var.sonarcloud_token_name
    }
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
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
  }
  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = var.security_groups
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.test_buildspec
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.test.name
    }
  }
}

# CodeBuild for the Func Test
resource "aws_cloudwatch_log_group" "test_selenium" {
#  count             = 2
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-selenium-${var.environments[1]}"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "test_selenium" {
#  count          = 2
  name           = "${var.repo_name}-${var.region_name}-selenium-${var.environments[1]}"
  description    = "The CodeBuild func test project for ${var.repo_name}"
  service_role   = var.codebuild_role
  build_timeout  = var.build_timeout
  encryption_key = var.aws_kms_key

  source {
    type      = "CODEPIPELINE"
    buildspec = var.test_func_buildspec
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = "LINUX_CONTAINER"
    privileged_mode = var.build_privileged_override
    environment_variable {
      name  = "APP_TARGET_URL"
      value = "https://${var.app_fqdn[1]}"
    }
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
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.test_selenium.name
    }
  }
}

# CodeBuild for the Perf Test
resource "aws_cloudwatch_log_group" "performance" {
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-performance"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "test_perf" {
  name           = "${var.repo_name}-${var.region_name}-performance"
  service_role   = var.codebuild_role
  build_timeout  = var.build_timeout
  encryption_key = var.aws_kms_key
  source {
    type      = "CODEPIPELINE"
    buildspec = var.test_perf_buildspec
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = "LINUX_CONTAINER"
    privileged_mode = var.build_privileged_override
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
      value = "${var.repo_name}-dlt.${var.route53_zone_name}"
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
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.performance.name
    }
  }
}