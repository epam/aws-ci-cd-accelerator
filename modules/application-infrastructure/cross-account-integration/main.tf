#======================= IAM for integration with Atlantis =======================#
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
##====================== Role for Atlantis ======================##
data "aws_iam_policy_document" "atlantis" {
  statement {
    sid    = "AllowAssumeAtlantisRole"
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
      values   = ["arn:aws:iam::${var.accelerator_account_id}:role/atlantis*ecs-task-role"]
      variable = "aws:PrincipalArn"
    }
  }
  dynamic "statement" {
    for_each = var.allowed_users
    content {
      sid    = "AllowAssumeUser${statement.value}"
      effect = "Allow"
      actions = [
        "sts:AssumeRole"
      ]
      principals {
        type = "AWS"
        identifiers = [
          "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:user/${statement.value}"
        ]
      }
    }
  }
}

resource "aws_iam_role" "admin" {
  name               = "Accelerator-Atlantis-Admin-Access"
  description        = "Role for Atlantis admin access"
  assume_role_policy = data.aws_iam_policy_document.atlantis.json
}

resource "aws_iam_role_policy_attachment" "atlantis_admin_policy" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
