#======================= CodePipeline for EKS(k8s) =======================#
resource "aws_codepipeline" "codepipeline_eks" {
  count    = var.target_type == "eks" || var.target_type == "kube_cluster" ? 1 : 0
  name     = "${var.repo_name}-${var.region_name}-eks"
  role_arn = var.codepipeline_role

  artifact_store {
    location = "${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}"
    type     = "S3"

    encryption_key {
      id   = var.aws_kms_key_arn
      type = "KMS"
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
      name             = "Docker-Image"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["packaged"]
      version          = "1"
      namespace        = "Test"
      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }
  stage {
    name = "DEV"
    action {
      name      = "Deploy-to-EKS-DEV"
      run_order = 1
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      input_artifacts = [
        "packaged"
      ]
      version = "1"
      configuration = {
        ProjectName = aws_codebuild_project.build_deploy_to_eks[0].name
      }
    }
  }
  stage {
    name = "QA"
    action {
      name      = "Deploy-to-EKS-QA"
      run_order = 1
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      input_artifacts = [
        "packaged"
      ]
      version = "1"
      configuration = {
        ProjectName = aws_codebuild_project.build_deploy_to_eks[1].name
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
      }
    }
    action {
      name      = "Deploy-to-EKS-UAT"
      run_order = 2
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      input_artifacts = [
        "packaged"
      ]
      version = "1"
      configuration = {
        ProjectName = aws_codebuild_project.build_deploy_to_eks[2].name
      }
    }
  }
}
