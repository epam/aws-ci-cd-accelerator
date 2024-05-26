#======================= Bucket for AWS CodeBuild artifacts store =======================#
data "aws_iam_policy_document" "s3_artifact" {

  statement {
    sid    = "ForAcceleratorRoles"
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}",
      "arn:aws:s3:::${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}/*"
    ]
    condition {
      test = "StringLike"
      values = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Codepipeline-${var.repo_name}*",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Codebuild-${var.repo_name}*"
      ]
      variable = "aws:PrincipalArn"
    }
  }
  statement {
    sid    = "ForAccountsRoles"
    effect = "Allow"
    principals {
      identifiers = [for k in var.account_identifiers : "arn:aws:iam::${k}:root"]
      type        = "AWS"
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}",
      "arn:aws:s3:::${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}/*"
    ]
  }
  statement {
    sid    = "ForAccountsRoot"
    effect = "Allow"
    principals {
      identifiers = [for k in var.account_identifiers : "arn:aws:iam::${k}:root"]
      type        = "AWS"
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}",
      "arn:aws:s3:::${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}/*"
    ]
    condition {
      test     = "StringEquals"
      values   = var.artifact_bucket_identifiers
      variable = "aws:PrincipalArn"
    }
  }
}
module "s3_bucket_artifact" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket                                = "${var.artifact_bucket_prefix}-${var.repo_name}-${var.region}"
  policy                                = data.aws_iam_policy_document.s3_artifact.json
  force_destroy                         = var.force_destroy
  attach_policy                         = true
  attach_deny_insecure_transport_policy = true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms.key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning = {
    enabled    = true
    mfa_delete = false
  }
  lifecycle_rule = [
    {
      id      = "artifact"
      enabled = true
      noncurrent_version_transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "ONEZONE_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        },
      ]
      noncurrent_version_expiration = {
        days = 300
      }
    }
  ]
}
