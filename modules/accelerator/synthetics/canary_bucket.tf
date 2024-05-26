#======================= S3 Bucket for Canary =======================#
module "s3_bucket" {
  source                                = "terraform-aws-modules/s3-bucket/aws"
  version                               = "~> 3.0"
  bucket                                = "cw-syn-results-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${var.repo_name}"
  force_destroy                         = true
  attach_deny_insecure_transport_policy = true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.aws_kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  ##====================== S3 bucket-level Public Access Block configuration ======================##
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
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
