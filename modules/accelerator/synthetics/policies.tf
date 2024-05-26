#======================= IAM for AWS Synthetics Canary =======================#
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "canary_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "canary_role" {
  name               = "canary-${var.repo_name}-${data.aws_region.current.name}"
  assume_role_policy = data.aws_iam_policy_document.canary_role.json
}

data "aws_iam_policy_document" "canary" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}/canary/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
    ]

    resources = [
      "arn:aws:s3:::${module.s3_bucket.s3_bucket_id}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/cwsyn-*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
      "xray:PutTraceSegments",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["cloudwatch:PutMetricData"]

    condition {
      test     = "StringEquals"
      variable = "cloudwatch:namespace"
      values = [
        "CloudWatchSynthetics"
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]

    resources = [var.aws_kms_key_arn]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values = [
        "S3.${data.aws_region.current.name}.amazonaws.com",
      ]
    }
  }
}
resource "aws_iam_policy" "canary_lambda_policy" {
  name        = "canary_lambda_policy_for_synthetic_${var.repo_name}"
  description = "Permissions for Canary Synthetic Lambda function"

  policy = data.aws_iam_policy_document.canary.json
}

resource "aws_iam_role_policy_attachment" "canary_lambda_policy" {
  policy_arn = aws_iam_policy.canary_lambda_policy.arn
  role       = aws_iam_role.canary_role.name
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role_to_manage_synthetics_${var.repo_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:*:*"]
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
    resources = [aws_sqs_queue.dlq_1.arn, aws_sqs_queue.dlq_2.arn, aws_sqs_queue.dlq_3.arn]
    sid       = "sqsdlq"
  }
  statement {
    actions = [
      "synthetics:GetCanary",
      "synthetics:StartCanary",
      "synthetics:DescribeCanariesLastRun",
      "synthetics:DescribeCanaries"
    ]
    resources = [
      aws_synthetics_canary.this.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:GetMetricData"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy_for_synthetic_${var.repo_name}"
  description = "Permissions for Lambda functions to manage synthetics"

  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}
