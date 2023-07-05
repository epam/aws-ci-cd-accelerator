#Bucket to store scripts
resource "aws_s3_bucket" "storage" {
  bucket        = var.storage_bucket_name != "" ? var.storage_bucket_name : "${var.repo_name}-${var.region_name}-storage-bucket"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_policy" "storage_bucket" {
  bucket = aws_s3_bucket.storage.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Id        = "STORAGEBUCKETPOLICY"
    Statement = [
      {
        Sid       = "HTTPDeny"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          aws_s3_bucket.storage.arn,
          "${aws_s3_bucket.storage.arn}/*"
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

resource "aws_s3_bucket_versioning" "storage_bucket" {
  bucket = aws_s3_bucket.storage.id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_public_access_block" "storage_bucket" {
  bucket                  = aws_s3_bucket.storage.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#====================== Bucket Server-Side Encryption ===============
resource "aws_s3_bucket_server_side_encryption_configuration" "storage_bucket" {
  bucket = aws_s3_bucket.storage.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.artifact_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Script for creating deb package
resource "aws_s3_object" "deb_script" {
  count      = var.target_type == "instance" ? 1 : 0
  bucket     = aws_s3_bucket.storage.id
  key        = "pack_to_deb.sh"
  source     = "${path.module}/storage_bucket_files/pack_to_deb.sh"
  #  etag   = filemd5("${path.module}/storage_bucket_files/pack_to_deb.sh")
  kms_key_id = aws_kms_key.artifact_encryption_key.arn
}

# CloudFormation stack for DLT tests.
resource "aws_s3_object" "dlt" {
  bucket     = aws_s3_bucket.storage.id
  key        = "dlt.yml"
  source     = "${path.module}/storage_bucket_files/dlt.yml"
  #  etag   = filemd5("${path.module}/storage_bucket_files/dlt.yml")
  kms_key_id = aws_kms_key.artifact_encryption_key.arn
}

resource "aws_s3_bucket_policy" "allow_access_from_account" {
  bucket = aws_s3_bucket.storage.id
  policy = data.aws_iam_policy_document.allow_access_from_account.json
}
data "aws_iam_policy_document" "allow_access_from_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.storage.arn,
      "${aws_s3_bucket.storage.arn}/*",
    ]
  }

}