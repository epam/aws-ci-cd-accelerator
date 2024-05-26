#======================= The S3 Bucket for Logs =======================#
module "log_bucket" {
  count   = var.alb_access_logs ? 1 : 0
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "${var.repo_name}-alb-logs-${var.region}"
  acl    = "log-delivery-write"

  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_elb_log_delivery_policy = true # Required for ALB logs
  attach_lb_log_delivery_policy  = true # Required for ALB/NLB logs

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = var.kms_key_arn
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
      id      = "logs"
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
        days = 180
      }
    }
  ]

}
