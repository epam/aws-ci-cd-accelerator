# Full CodePipeline
resource "aws_codepipeline" "codepipeline_ecs" {
  count    = var.target_type == "ip" ? 1 : 0
  name     = "${var.repo_name}-${var.region_name}"
  role_arn = var.codepipeline_role

  artifact_store {
    location = var.build_artifact_bucket
    type     = "S3"

    encryption_key {
      id   = var.aws_kms_key
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = var.source_provider
      version          = "1"
      output_artifacts = ["source"]
      namespace        = "SourceVariables"
      configuration    = var.source_provider == "CodeStarSourceConnection" ? data.template_file.github_bitbucket_config[0].vars : local.codecommit
    }
  }
  stage {
    name = "Test"
    action {
      run_order        = 1
      name             = "Test-Sonar"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["tested"]
      version          = "1"
      configuration    = {
        ProjectName = aws_codebuild_project.test_project.name
      }
    }
    action {
      run_order        = 2
      name             = "Unit-Tests"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source"]
      output_artifacts = ["unit_tested"]
      version          = "1"
      configuration    = {
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
      configuration    = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }
  stage {
    name = "DEV"
    action {
      name            = "Deploy-to-DEV"
      run_order       = 1
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      namespace       = "Deploy-to-DEV"
      version         = "1"
      input_artifacts = ["packaged"]
      configuration   = {
        ApplicationName                = aws_codedeploy_app.application[0].name
        DeploymentGroupName            = aws_codedeploy_deployment_group.ecs[0].deployment_group_name
        TaskDefinitionTemplateArtifact = "packaged"
        AppSpecTemplateArtifact        = "packaged"
        TaskDefinitionTemplatePath     = "taskdef_dev.json"
        AppSpecTemplatePath            = "appspec_ecs.yml"
        Image1ArtifactName             = "packaged"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
#    action {
#      name            = "Selenium-Dev"
#      run_order       = 2
#      category        = "Build"
#      owner           = "AWS"
#      provider        = "CodeBuild"
#      input_artifacts = [
#        "tested"
#      ]
#      version       = "1"
#      configuration = {
#        ProjectName = aws_codebuild_project.test_selenium.name
#      }
#    }
  }
  stage {
    name = "QA"
    action {
      name            = "Deploy-to-QA"
      run_order       = 1
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      namespace       = "Deploy-to-QA"
      version         = "1"
      input_artifacts = ["packaged"]
      configuration   = {
        ApplicationName                = aws_codedeploy_app.application[0].name
        DeploymentGroupName            = aws_codedeploy_deployment_group.ecs[1].deployment_group_name
        TaskDefinitionTemplateArtifact = "packaged"
        AppSpecTemplateArtifact        = "packaged"
        TaskDefinitionTemplatePath     = "taskdef_qa.json"
        AppSpecTemplatePath            = "appspec_ecs.yml"
        Image1ArtifactName             = "packaged"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
    action {
      name            = "Selenium-QA"
      run_order       = 2
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = [
        "packaged"
      ]
      version       = "1"
      configuration = {
        ProjectName = aws_codebuild_project.test_selenium.name
      }
    }
    action {
      category        = "Test"
      name            = "DLT-QA"
      run_order       = 3
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = [
        "packaged"
      ]
      configuration = {
        ProjectName = aws_codebuild_project.test_perf.name
      }
    }
  }
  stage {
    name = "UAT"
    action {
      run_order     = 1
      name          = "Manual-Approve"
      category      = "Approval"
      owner         = "AWS"
      provider      = "Manual"
      version       = "1"
      configuration = {
        NotificationArn = var.approve_sns_arn
        CustomData      = "Approve action needed"
        #        ExternalEntityLink = var.approve_url
      }
    }
    action {
      name            = "Deploy-to-UAT"
      run_order       = 2
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      namespace       = "Deploy-to-UAT"
      version         = "1"
      input_artifacts = ["packaged"]
      configuration   = {
        ApplicationName                = aws_codedeploy_app.application[0].name
        DeploymentGroupName            = aws_codedeploy_deployment_group.ecs[2].deployment_group_name
        TaskDefinitionTemplateArtifact = "packaged"
        AppSpecTemplateArtifact        = "packaged"
        TaskDefinitionTemplatePath     = "taskdef_uat.json"
        AppSpecTemplatePath            = "appspec_ecs.yml"
        Image1ArtifactName             = "packaged"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }
}