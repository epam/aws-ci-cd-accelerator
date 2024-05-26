#======================= Bucket for storing configuration files for EC2, ECS, DLT, etc. ===========================#

locals {
  storage_bucket = "${var.storage_bucket_prefix}-${var.project}-${var.region}"
}
##====================== CloudFormation stack for DLT tests ==========================##
resource "aws_s3_object" "dlt" {
  bucket        = module.s3_storage_bucket.s3_bucket_id
  key           = "dlt/dlt.yml"
  source        = "${path.module}/common_bucket_files/dlt.yml"
  etag          = filemd5("${path.module}/common_bucket_files/dlt.yml")
  force_destroy = true
}

data "aws_iam_policy_document" "s3_storage" {
  statement {
    sid    = "ForAccountsRoles"
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
      type        = "AWS"
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${local.storage_bucket}",
      "arn:aws:s3:::${local.storage_bucket}/*"
    ]
    #    condition {
    #      test     = "ArnLike"
    #      values   = var.storage_bucket_identifiers
    #      variable = "aws:PrincipalArn"
    #    }
  }
}
module "s3_storage_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket                                = local.storage_bucket
  policy                                = data.aws_iam_policy_document.s3_storage.json
  force_destroy                         = true # var.force_destroy
  attach_policy                         = true
  attach_deny_insecure_transport_policy = true
  #  server_side_encryption_configuration  = {
  #    rule = {
  #      apply_server_side_encryption_by_default = {
  #        kms_master_key_id = module.kms.key_arn
  #        sse_algorithm     = "aws:kms"
  #      }
  #    }
  #  }
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
