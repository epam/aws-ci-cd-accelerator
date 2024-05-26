#======================= EC2 profile role =======================#
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "ec2_profile_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_profile_role" {
  count              = length(var.environments)
  name               = "EC2-Profile-Role-${var.repo_name}-${var.environments[count.index]}-${var.region}"
  assume_role_policy = data.aws_iam_policy_document.ec2_profile_policy.json
}

resource "aws_iam_instance_profile" "profile" {
  count = length(var.environments)
  name  = "${var.repo_name}-profile-${var.environments[count.index]}-${var.region}"
  role  = aws_iam_role.ec2_profile_role[count.index].name
}
data "aws_iam_policy_document" "profile" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
    ]
    resources = [
      "arn:aws:s3:::aws-codedeploy-${var.region}/*",
      "arn:aws:s3:::${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}/*",
      "arn:aws:s3:::${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt",
    ]
    resources = ["*"]
  }
  statement {
    effect  = "Allow"
    actions = ["ssm:*"]
    resources = [
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:ListSecrets"]
    resources = [
      "*"
    ]
  }
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }
}
resource "aws_iam_policy" "profile_s3_policy" {
  name   = "Policy-For-S3-Artifact-${var.repo_name}-${var.region}"
  policy = data.aws_iam_policy_document.profile.json
}

resource "aws_iam_role_policy_attachment" "s3_read" {
  count      = length(var.environments)
  role       = aws_iam_role.ec2_profile_role[count.index].name
  policy_arn = aws_iam_policy.profile_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  count      = length(var.environments)
  role       = aws_iam_role.ec2_profile_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_agent" {
  count      = length(var.environments)
  role       = aws_iam_role.ec2_profile_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
