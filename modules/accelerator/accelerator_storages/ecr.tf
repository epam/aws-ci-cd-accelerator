#======================= ECR Repo =======================#
resource "aws_ecr_repository" "this" {
  count                = var.target_type != "instance" ? 1 : 0
  name                 = var.repo_name
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = true
  }
  #  encryption_configuration {
  #    kms_key = module.kms.key_arn
  #  }
  force_delete = true
}

data "aws_iam_policy_document" "ecr_policy" {
  count = var.target_type != "instance" ? 1 : 0
  statement {
    sid    = "ECRIdentifiers"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy"
    ]
    condition {
      test = "StringLike"
      values = [
        "arn:aws:iam::*:role/Ecs-Execution-${var.repo_name}*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Codebuild-${var.repo_name}*"]
      variable = "aws:PrincipalArn"
    }
  }
}

resource "aws_ecr_repository_policy" "this" {
  count      = var.target_type != "instance" ? 1 : 0
  repository = aws_ecr_repository.this[0].name
  policy     = data.aws_iam_policy_document.ecr_policy[0].json
}
