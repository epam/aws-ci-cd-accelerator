#======================= IAM for notifications =======================#
resource "aws_iam_role" "lambda" {
  name_prefix = "${var.repo_name}-${var.region_name}-lambda_sns"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = [
            "lambda.amazonaws.com",
          ]
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "topic" {
  statement {
    actions = [
      "sns:Publish"
    ]
    effect = "Allow"
    resources = [
      aws_sns_topic.notif.arn
    ]
    sid = "emailsnsid"
  }
  statement {
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords"
    ]
    effect    = "Allow"
    resources = ["*"]
    sid       = "xraytracing"
  }
  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueUrl"
    ]
    effect    = "Allow"
    resources = [aws_sqs_queue.dlq.arn]
    sid       = "sqsdlq"
  }
}

resource "aws_iam_role_policy" "allow_lambda_to_publish_sns_topic" {
  policy      = data.aws_iam_policy_document.topic.json
  role        = aws_iam_role.lambda.id
  name_prefix = "${var.repo_name}-lambda-policy"
}
resource "aws_iam_role_policy_attachment" "awslambdavpcaccessexecutionrole" {
  role       = aws_iam_role.lambda.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role       = aws_iam_role.lambda.id
}
resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.notif.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.notif.arn]
  }
}
