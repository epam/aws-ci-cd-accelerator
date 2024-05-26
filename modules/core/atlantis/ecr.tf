#======================= ECR repository for Atlantis ===========================#
resource "aws_ecr_repository" "atlantis" {
  name                 = "atlantis"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}
data "aws_iam_policy_document" "aws_ecr_repository_policy" {
  statement {
    sid    = "PolicyForAtlantisToGetImage"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages"
    ]
  }
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.atlantis.name
  policy     = data.aws_iam_policy_document.aws_ecr_repository_policy.json
}
