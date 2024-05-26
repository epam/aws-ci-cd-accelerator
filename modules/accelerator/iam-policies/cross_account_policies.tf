#======================= Cross account IAM =======================#
##====================== Policy for EKS ======================##
resource "aws_iam_policy" "eks" {
  count = var.target_type == "eks" ? 1 : 0
  name  = "EKS-${var.repo_name}-${var.region_name}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sts:AssumeRole"]
        Effect   = "Allow"
        Resource = var.eks_role_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  count      = var.target_type == "eks" ? 1 : 0
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.eks[0].arn
}

##====================== Policy for  CodeDeploy ======================##
data "aws_iam_policy_document" "assume_codedeploy_role" {
  count   = var.target_type == "ip" || var.target_type == "instance" ? 1 : 0
  version = "2012-10-17"
  statement {
    actions   = ["sts:AssumeRole"]
    effect    = "Allow"
    resources = var.codedeploy_role_arns
  }
}

resource "aws_iam_policy" "assume_codedeploy" {
  count  = var.target_type == "ip" || var.target_type == "instance" ? 1 : 0
  name   = "CodeDeploy-Assume-Policy-${var.repo_name}"
  policy = data.aws_iam_policy_document.assume_codedeploy_role[0].json
}
resource "aws_iam_role_policy_attachment" "assume_codedeploy" {
  count      = var.target_type == "ip" || var.target_type == "instance" ? 1 : 0
  policy_arn = aws_iam_policy.assume_codedeploy[0].arn
  role       = aws_iam_role.codepipeline_role.name
}
