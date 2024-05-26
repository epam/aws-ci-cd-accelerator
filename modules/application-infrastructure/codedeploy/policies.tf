#======================= IAM for CodeDeploy =======================#
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "codedeploy_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
  statement {
    sid    = "AllowAssumeCodeBuildRoles"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.accelerator_account_id}:root"]
    }
    condition {
      test     = "StringLike"
      values   = ["arn:aws:iam::${var.accelerator_account_id}:role/Codepipeline-*"]
      variable = "aws:PrincipalArn"
    }
  }
}

resource "aws_iam_role" "codedeploy_role" {
  count              = var.codedeploy_role_create ? length(var.environments) : 0
  name               = "Codedeploy-${var.repo_name}-${var.environments[count.index]}"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_policy.json
}

data "template_file" "codedeploy_policy_template" {
  count    = length(var.environments)
  template = file("${path.module}/codedeploy_policy/codedeploy.tpl")
  vars = {
    ArtifactBucket = "arn:aws:s3:::${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}"
    REGION         = var.region
    AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id
    REPO_NAME      = var.repo_name
    ENV            = var.environments[count.index]
  }
}
resource "aws_iam_policy" "codedeploy_policies" {
  count  = length(var.environments)
  name   = "Codedeploy-policy-${var.repo_name}-${var.environments[count.index]}-${var.region}"
  policy = data.template_file.codedeploy_policy_template[count.index].rendered
}

resource "aws_iam_role_policy_attachment" "codedeploy_policies" {
  count      = length(var.environments)
  role       = var.codedeploy_role_create ? aws_iam_role.codedeploy_role[count.index].name : "Codedeploy-${var.repo_name}-${var.environments[count.index]}"
  policy_arn = aws_iam_policy.codedeploy_policies[count.index].arn
}

resource "aws_iam_role_policy_attachment" "codedeploy_ecs" {
  count      = var.target_type == "ip" && var.codedeploy_role_create ? length(var.environments) : 0
  role       = aws_iam_role.codedeploy_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role_policy_attachment" "codedeploy_ec2" {
  count      = var.target_type == "instance" && var.codedeploy_role_create ? length(var.environments) : 0
  role       = aws_iam_role.codedeploy_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}
