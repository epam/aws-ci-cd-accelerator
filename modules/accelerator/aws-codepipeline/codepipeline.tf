#======================= CodePipeline for EC2 =======================#
locals {
  regions = [
    for region in distinct(flatten(var.stage_regions)) : region
  ]
  filtered_regions = [
    for region in distinct(flatten(var.stage_regions)) : region if region != var.region
  ]
}
resource "aws_codepipeline" "codepipeline" {
  count    = var.target_type == "instance" ? 1 : 0
  name     = "${var.repo_name}-${var.region_name}"
  role_arn = var.codepipeline_role

  dynamic "artifact_store" {
    for_each = local.regions
    content {
      location = "${var.artifact_bucket_prefix}-${var.repo_name}-${artifact_store.value}"
      type     = "S3"
      encryption_key {
        id   = "arn:aws:kms:${artifact_store.value}:${var.aws_account_id}:alias/${var.repo_name}-${artifact_store.value}-key"
        type = "KMS"
      }
      region = length(local.filtered_regions) == 0 ? null : artifact_store.value
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = local.provider
      version          = "1"
      output_artifacts = ["source"]
      namespace        = "SourceVariables"
      configuration    = local.provider == "CodeStarSourceConnection" ? local.codestarconnection : local.codecommit
    }
  }
  stage {
    name = "Test"
    action {
      run_order       = 1
      name            = "Test-Sonar"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.test_project.name
      }
    }
    action {
      run_order       = 2
      name            = "Unit-Tests"
      category        = "Test"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source"]
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.unit_project.name
      }
    }
  }
  stage {
    name = "Build"
    action {
      name             = "Package"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["packaged"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }
  stage {
    name = "DEV"
    dynamic "action" {
      for_each = var.stage_regions[0]
      content {
        region    = action.value
        name      = "Deploy-to-DEV-${action.value}"
        run_order = 1
        category  = "Deploy"
        owner     = "AWS"
        provider  = "CodeDeploy"
        namespace = "DEV-${action.value}"
        role_arn  = var.codedeploy_role_arns[0]
        input_artifacts = [
          "packaged"
        ]
        version = "1"
        configuration = {
          DeploymentGroupName = var.deployment_group_names[0]
          ApplicationName     = var.application_name
        }
      }
    }
  }
  stage {
    name = "QA"
    dynamic "action" {
      for_each = var.stage_regions[1]
      content {
        region    = action.value
        name      = "Deploy-to-QA-${action.value}"
        run_order = 1
        category  = "Deploy"
        owner     = "AWS"
        provider  = "CodeDeploy"
        namespace = "QA-${action.value}"
        role_arn  = var.codedeploy_role_arns[1]
        input_artifacts = [
          "packaged"
        ]
        version = "1"
        configuration = {
          DeploymentGroupName = var.deployment_group_names[1]
          ApplicationName     = var.application_name
        }
      }
    }
    dynamic "action" {
      for_each = var.selenium_create ? [1] : []
      content {
        name      = "Selenium-QA"
        run_order = 2
        category  = "Build"
        owner     = "AWS"
        provider  = "CodeBuild"
        input_artifacts = [
          "packaged"
        ]
        version = "1"
        configuration = {
          ProjectName = aws_codebuild_project.test_selenium[0].name
        }
      }
    }
    dynamic "action" {
      for_each = var.synthetics_create ? [1] : []
      content {
        category  = "Invoke"
        name      = "Canary-Synthetics-QA"
        run_order = 2
        owner     = "AWS"
        provider  = "StepFunctions"
        version   = "1"
        configuration = {
          StateMachineArn = var.statemachine_arn
        }
      }
    }
    dynamic "action" {
      for_each = var.dlt_create ? [1] : []
      content {
        category  = "Test"
        name      = "DLT-QA"
        run_order = 3
        owner     = "AWS"
        provider  = "CodeBuild"
        version   = "1"
        input_artifacts = [
          "packaged"
        ]
        configuration = {
          ProjectName = aws_codebuild_project.dlt[0].name
        }
      }
    }
    dynamic "action" {
      for_each = var.carrier_create ? [1] : []
      content {
        category  = "Test"
        name      = "Carrier-QA"
        run_order = 3
        owner     = "AWS"
        provider  = "CodeBuild"
        version   = "1"
        input_artifacts = [
          "packaged"
        ]
        configuration = {
          ProjectName = aws_codebuild_project.carrier_project[0].name
        }
      }
    }
  }
  stage {
    name = "UAT"
    action {
      run_order = 1
      name      = "Manual-Approve"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      configuration = {
        NotificationArn = var.approve_sns_arn
        CustomData      = "Approve action needed"
        #        ExternalEntityLink = var.approve_url
      }
    }
    dynamic "action" {
      for_each = var.stage_regions[2]
      content {
        region    = action.value
        name      = "Deploy-to-UAT-${action.value}"
        run_order = 2
        category  = "Deploy"
        owner     = "AWS"
        provider  = "CodeDeploy"
        namespace = "UAT-${action.value}"
        role_arn  = var.codedeploy_role_arns[2]
        input_artifacts = [
          "packaged"
        ]
        version = "1"
        configuration = {
          DeploymentGroupName = var.deployment_group_names[2]
          ApplicationName     = var.application_name
        }
      }
    }
  }
}
