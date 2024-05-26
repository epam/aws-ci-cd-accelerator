#======================= CloudWatch for SNS notifications =======================#
##======================= Failed Attempts =======================##
resource "aws_cloudwatch_event_rule" "build_fail" {
  name = "${var.repo_name}-${var.region_name}-build-status-fail"

  event_pattern = <<PATTERN
{
  "detail": {
    "project-name": [ { "prefix": "${var.repo_name}-" } ],
    "completed-phase-status": [
      "TIMED_OUT",
      "STOPPED",
      "FAILED",
      "FAULT",
      "CLIENT_ERROR"
    ]
  },
  "detail-type": [
    "CodeBuild Build Phase Change"
  ],
  "source": [
      "aws.codebuild"
  ]
}
PATTERN
}
resource "aws_cloudwatch_event_target" "build_target_fail" {
  rule      = aws_cloudwatch_event_rule.build_fail.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.notif.arn
  input_transformer {
    input_paths = {
      completed-phase        = "$.detail.completed-phase",
      project-name           = "$.detail.project-name",
      completed-phase-status = "$.detail.completed-phase-status",
    }
    input_template = "\"Build project **<project-name>** has <completed-phase-status> status at build phase <completed-phase>.\""
  }
}

##======================= Successful Attempts =======================##
resource "aws_cloudwatch_event_rule" "build_success" {
  count         = var.build_success ? 1 : 0
  name          = "${var.repo_name}-${var.region_name}-build-status-success"
  event_pattern = <<PATTERN
  {
  "source": [
    "aws.codebuild"
  ],
  "detail-type": [
    "CodeBuild Build State Change"
  ],
  "detail": {
    "build-status": [
      "SUCCEEDED"
    ]
  }
}
  PATTERN
}

resource "aws_cloudwatch_event_target" "build_target_success" {
  count     = var.build_success ? 1 : 0
  rule      = aws_cloudwatch_event_rule.build_success[0].name
  target_id = "SendCodebuildStateToSNS"
  arn       = aws_sns_topic.notif.arn
  input_transformer {
    input_paths = {
      build-status = "$.detail.build-status",
      project-name = "$.detail.project-name",
    }
    input_template = "\"Build project **<project-name>** has status <build-status>.\""
  }
}

resource "aws_cloudwatch_event_rule" "pipeline_state_start" {
  name = "${var.repo_name}-${var.region_name}-pipeline-start-success"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codepipeline"
  ],
  "detail-type": [
    "CodePipeline Pipeline Execution State Change"
  ],
  "detail": {
    "pipeline": ["${var.codepipeline_name}"],
    "state": [
      "STARTED",
      "SUCCEEDED"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "pipeline_state_start" {
  rule      = aws_cloudwatch_event_rule.pipeline_state_start.name
  target_id = "SendPipeStartStateToSNS"
  arn       = aws_sns_topic.notif.arn
  input_transformer {
    input_paths = {
      pipeline-name  = "$.detail.pipeline",
      pipeline-state = "$.detail.state",
    }
    input_template = "\"Pipeline **<pipeline-name>** has status <pipeline-state>.\""
  }
}
resource "aws_cloudwatch_event_rule" "pipeline_state_finish" {
  name = "${var.repo_name}-${var.region_name}-pipeline-finish"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codepipeline"
  ],
  "detail-type": [
    "CodePipeline Action Execution State Change"
  ],
  "detail": {
    "pipeline": ["${var.codepipeline_name}"],
    "state": [
      "FAILED",
      "CANCELED"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "pipeline_state_finish" {
  rule      = aws_cloudwatch_event_rule.pipeline_state_finish.name
  target_id = "SendPipeFinishStateToSNS"
  arn       = aws_sns_topic.notif.arn
  input_transformer {
    input_paths = {
      pipeline-name  = "$.detail.pipeline",
      pipeline-state = "$.detail.state",
      action         = "$.detail.action"
    }
    input_template = "\"Pipeline **<pipeline-name>** has status **<pipeline-state>**, action: **<action>**.\""
  }
}
