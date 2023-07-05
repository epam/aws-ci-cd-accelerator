
resource "aws_sns_topic" "notif" {
  name = "Cloudtrail-notification-${var.region}"
  display_name  = "SNS-CloudTrail"
}

resource "aws_sns_topic_subscription" "email" {
  count = length(var.email_addresses)
  topic_arn = aws_sns_topic.notif.arn
  protocol  = "email"
  endpoint  = var.email_addresses[count.index]
}
resource "aws_sns_topic_policy" "email" {
  arn    = aws_sns_topic.notif.arn
  policy = data.aws_iam_policy_document.sns_topic_policy_email.json
}

data "aws_iam_policy_document" "sns_topic_policy_email" {
  statement {
    sid = "1"
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.notif.arn]
  }

  statement {
    sid = "2"
    effect = "Allow"
    actions = ["SNS:Publish"]

    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    resources = [aws_sns_topic.notif.arn]
  }
}

resource "aws_cloudwatch_event_rule" "event" {
  name = "infrastructure-compliance"
  description = "Sends notification to SNS topic subscribers when resource is not in COMPLIANT state."

  event_pattern = <<EOF
{
  "source": [
    "aws.config"
  ],
  "detail-type": [
    "Config Rules Compliance Change"
  ]
}
EOF
}

resource "aws_cloudwatch_event_target" "event_target" {
  arn = aws_sns_topic.notif.arn
  target_id = "SendToSNS"
  rule = aws_cloudwatch_event_rule.event.name

  input_transformer {
    input_paths = {
      awsRegion = "$.detail.awsRegion",
      resourceId = "$.detail.resourceId",
      awsAccountId = "$.detail.awsAccountId",
      compliance = "$.detail.newEvaluationResult.complianceType",
      rule = "$.detail.configRuleName",
      time = "$.detail.newEvaluationResult.resultRecordedTime",
      resourceType = "$.detail.resourceType"
    }
    input_template = "\"On <time> AWS Config rule **<rule>** evaluated the <resourceType> with Id **<resourceId>** in the account **<awsAccountId>** region <awsRegion> as <compliance> For more details open the AWS Config console at https://console.aws.amazon.com/config/home?region=<awsRegion>#/timeline/<resourceType>/<resourceId>/configuration.\""
  }
}