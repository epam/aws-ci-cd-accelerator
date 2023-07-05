data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
}

#-----------------------#
# CloudWatch Log Group  #
# CloudWatch Log Stream #
#-----------------------#

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "${var.organization_name}-cloudtrail"
}
resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
  log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group.name
  name           = local.account_id
}

#---------------------------------------------------#
# CloudWatch & CloudTrail events role and policies  #
#---------------------------------------------------#

resource "aws_iam_role" "cloudtrail_cloudwatch_role" {
  name               = "CloudTrailCWRole"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_logs_assume_policy.json
}

resource "aws_iam_role_policy" "cloudtrail_cloudwatch_logs_policy" {
  name   = "CloudTrailCWPolicy"
  role   = aws_iam_role.cloudtrail_cloudwatch_role.id
  policy = data.aws_iam_policy_document.cloudwatch_logs_policy.json
}

data "aws_iam_policy_document" "cloudwatch_logs_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream"]

    resources = [
      "arn:${local.partition}:logs:${var.region}:${local.account_id}:log-group:${aws_cloudwatch_log_group.cloudwatch_log_group.name}:log-stream:*",
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["logs:PutLogEvents"]

    resources = [
      "arn:${local.partition}:logs:${var.region}:${local.account_id}:log-group:${aws_cloudwatch_log_group.cloudwatch_log_group.name}:log-stream:*",
    ]
  }
}

#----------#
#  KMS Key #
#----------#

resource "aws_kms_key" "cloudtrail_kms_key" {
  description             = "KMS key for CloudTrail logs"
  deletion_window_in_days = 10

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Key policy created by CloudTrail",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${local.account_id}:root"
                ]
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow CloudTrail to encrypt logs",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "kms:GenerateDataKey*",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${local.account_id}:trail/*"
                }
            }
        },
        {
            "Sid": "Allow CloudTrail to describe key",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "kms:DescribeKey",
            "Resource": "*"
        },
        {
            "Sid": "Allow principals in the account to decrypt log files",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "kms:Decrypt",
                "kms:ReEncryptFrom"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:CallerAccount": "${local.account_id}"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${local.account_id}:trail/*"
                }
            }
        },
        {
            "Sid": "Allow alias creation during setup",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "kms:CreateAlias",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:CallerAccount": "${local.account_id}",
                    "kms:ViaService": "ec2.${var.region}.amazonaws.com"
                }
            }
        },
        {
            "Sid": "Enable cross account log decryption",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "kms:Decrypt",
                "kms:ReEncryptFrom"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:CallerAccount": "${local.account_id}"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${local.account_id}:trail/*"
                }
            }
        }
    ]
}
POLICY
}

#------------#
# CloudTrail #
#------------#

resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.organization_name}-${local.account_id}-cloudtrail"
  enable_log_file_validation    = true
  enable_logging                = true
  is_multi_region_trail         = var.multi_region_trail
  include_global_service_events = var.multi_region_trail == "true" ? "true" : "false"
  kms_key_id                    = aws_kms_key.cloudtrail_kms_key.arn

  s3_bucket_name = aws_s3_bucket.cloudtrail_bucket.id

  sns_topic_name = aws_sns_topic.notif.name

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }
  }

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_role.arn
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudwatch_log_group.arn}:*"

}
#-------------------#
# CloudTrail Bucket #
#-------------------#

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = "${var.organization_name}-cloudtrail-${local.account_id}-${var.region}"
  force_destroy = var.force_destroy
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.cloudtrail_kms_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled = var.versioning
  }
  tags = {
    Name = "CloudTrail bucket"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    id     = "cloudtrail"
    status = "Enabled"

    expiration {
      days = 90
    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_acl" "versioning_bucket_acl" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#----------------------------#
# CloudTrail Bucket Policies #
#----------------------------#

data "aws_iam_policy_document" "bucket_policy_document" {
  statement {
    actions   = ["s3:GetBucketAcl"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}"]

    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
  }
  statement {
    actions   = ["s3:PutObject"]
    effect    = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }

    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.bucket
  policy = data.aws_iam_policy_document.bucket_policy_document.json

  depends_on = [aws_s3_bucket.cloudtrail_bucket]
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.cloudtrail_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}