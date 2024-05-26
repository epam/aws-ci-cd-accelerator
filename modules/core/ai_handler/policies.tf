#======================= IAM for AI handler =======================#
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  count              = length(var.repo_names)
  name               = "Terraform-AI-Handler-${var.repo_names[count.index]}-${var.region_name}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_exec_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]

  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = ["arn:aws:s3:::${local.storage_bucket}/*"]
    effect    = "Allow"
  }
  statement {
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:GetParametersByPath",
      "ssm:DescribeParameters"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*"
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
}

resource "aws_iam_role_policy_attachment" "lambda_exec_policy_attach" {
  count      = length(var.repo_names)
  role       = aws_iam_role.lambda_exec_role[count.index].name
  policy_arn = aws_iam_policy.lambda_exec_policy[count.index].arn
}

resource "aws_iam_policy" "lambda_exec_policy" {
  count       = length(var.repo_names)
  name        = "Terraform-AI-Handler-${var.repo_names[count.index]}-${var.region_name}"
  description = "Allow Lambda function execution"
  policy      = data.aws_iam_policy_document.lambda_exec_policy.json
}

resource "aws_iam_role_policy_attachment" "basic_lambda_policy" {
  count      = length(var.repo_names)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_exec_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "codebuild_lambda_policy" {
  count      = length(var.repo_names)
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
  role       = aws_iam_role.lambda_exec_role[count.index].name
}

#================ Codebuild Policies ==========================#

resource "aws_iam_role" "codebuild_role" {
  count = length(var.repo_names)
  name  = "ai-handler-codebuild-${var.repo_names[count.index]}-${var.region_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "codebuild_policy" {
  count = length(var.repo_names)
  name  = "AiHandler-${var.repo_names[count.index]}-${var.region_name}-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "*"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ]
        Resource = [
          "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:report-group/ai-*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:GetParametersByPath",
          "ssm:DescribeParameters"
        ]
        Resource = [
          "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = ["arn:aws:s3:::${local.storage_bucket}/*", "arn:aws:s3:::${local.storage_bucket}"]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  count      = length(var.repo_names)
  policy_arn = aws_iam_policy.codebuild_policy[count.index].arn
  role       = aws_iam_role.codebuild_role[count.index].name
}

resource "aws_iam_policy" "codebuild_policy_vpc" {
  count  = length(var.repo_names)
  name   = "Policy-vpc-${var.repo_names[count.index]}-${var.region_name}"
  policy = data.aws_iam_policy_document.codebuild_policy_vpc.json
}

data "aws_iam_policy_document" "codebuild_policy_vpc" {

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]

    resources = [
      "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:network-interface/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:Subnet"

      values = [
        for i in var.private_subnet_ids :
        "arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:subnet/${i}"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "policy_vpc" {
  count      = length(var.repo_names)
  role       = aws_iam_role.codebuild_role[count.index].name
  policy_arn = aws_iam_policy.codebuild_policy_vpc[count.index].arn
}
