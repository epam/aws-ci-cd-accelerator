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
}

resource "aws_iam_role_policy" "allow_lambda_to_publish_sns_topic" {
  policy      = data.aws_iam_policy_document.topic.json
  role        = aws_iam_role.lambda.id
  name_prefix = "${var.repo_name}-lambda-policy"
}
resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
    role       = aws_iam_role.lambda.id
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
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