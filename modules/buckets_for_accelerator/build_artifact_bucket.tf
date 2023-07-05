#======================== Bucket for AWS CodeBuild artifacts store =====================#

resource "aws_s3_bucket" "build_artifact_bucket" {
  bucket        = var.artifact_bucket_name != "" ? var.artifact_bucket_name : "${var.repo_name}-${var.region_name}-codebuild-artifacts"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_public_access_block" "artifact_bucket" {
  bucket                  = aws_s3_bucket.build_artifact_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_policy" "artifact_bucket" {
  bucket = aws_s3_bucket.build_artifact_bucket.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Id        = "ARTIFACTGEBUCKETPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          aws_s3_bucket.build_artifact_bucket.arn,
          "${aws_s3_bucket.build_artifact_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })

  # other required fields here
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact_bucket" {
  bucket = aws_s3_bucket.build_artifact_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.artifact_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "example" {
  #TODO Define better lifecycle for the bucket
  bucket = aws_s3_bucket.build_artifact_bucket.id

  rule {
    id = "rule-all"

    filter {}
    # ... other transition/expiration actions ...
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    status = "Enabled"
  }
}