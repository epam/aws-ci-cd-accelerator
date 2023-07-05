resource "aws_codebuild_project" "pr-CodeCommit" {
  name          = "${var.repo_name}-pr-analysis-CodeCommit"
  build_timeout = 20
  service_role  = var.service_role

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.${var.region}.amazonaws.com/v1/repos/${var.repo_name}"
    git_clone_depth = 5
    buildspec       = "buildspec_pr.yml"

  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
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
      name  = "REGION"
      value = var.region
    }
    environment_variable {
      name  = "PROJECT"
      value = var.project
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
      name  = "SONAR_TOKEN"
      value = var.sonarcloud_token_name
    }
  }
}

resource "aws_cloudwatch_event_rule" "pr_rule" {
  name = "pr_trigger_${var.repo_name}"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Pull Request State Change"
  ],
  "resources": [
    "arn:aws:codecommit:${var.region}:${var.aws_account_id}:${var.repo_name}"
  ],
  "detail": {
    "event": [
      "pullRequestCreated",
      "pullRequestSourceBranchUpdated"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "build_target" {
  rule       = aws_cloudwatch_event_rule.pr_rule.name
  target_id  = "SendToCodeBuild"
  role_arn   = aws_iam_role.cloudwatch.arn
  arn        = aws_codebuild_project.pr-CodeCommit.arn
  input_transformer {
    input_paths    = {
      pullRequestId        = "$.detail.pullRequestId"
      destinationReference = "$.detail.destinationReference"
      sourceReference      = "$.detail.sourceReference"
      repositoryName : "$.detail.repositoryNames[0]"
      sourceCommit : "$.detail.sourceCommit"
      destinationCommit : "$.detail.destinationCommit"
      revisionId : "$.detail.revisionId"
      sourceVersion : "$.detail.sourceCommit"
    }
    input_template = <<PATTERN
 {
  "sourceVersion": <sourceVersion>,
  "artifactsOverride": {"type": "NO_ARTIFACTS"},
  "environmentVariablesOverride": [
     {
         "name": "PULL_REQUEST_ID",
         "value": <pullRequestId>,
         "type": "PLAINTEXT"
     },
     {   "name": "DEST_REF",
         "value": <sourceReference>,
         "type": "PLAINTEXT"
     },
     {   "name": "SRC_REF",
         "value": <destinationReference>,
         "type": "PLAINTEXT"
     },
     {
         "name": "REPOSITORY_NAME",
         "value": <repositoryName>,
         "type": "PLAINTEXT"
     },
     {
         "name": "SOURCE_COMMIT",
         "value": <sourceCommit>,
         "type": "PLAINTEXT"
     },
     {
         "name": "DESTINATION_COMMIT",
         "value": <destinationCommit>,
         "type": "PLAINTEXT"
     },
     {
        "name" : "REVISION_ID",
        "value": <revisionId>,
        "type": "PLAINTEXT"
     }
  ]
}
PATTERN
  }
  depends_on = [aws_cloudwatch_event_rule.pr_rule]
}