# KMS Key for to encrypt buckets
# Encryption key for build artifacts
resource "aws_kms_key" "artifact_encryption_key" {
  description             = "Artifact-encryption-key"
  deletion_window_in_days = 7
}
resource "aws_kms_key_policy" "artifact" {
  key_id = aws_kms_key.artifact_encryption_key.key_id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Key-for-${var.repo_name}",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.aws_account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "${aws_kms_key.artifact_encryption_key.arn}"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${var.region}.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "${aws_kms_key.artifact_encryption_key.arn}",
            "Condition": {
                "ArnLike": {
                    "kms:EncryptionContext:aws:logs:arn": "arn:aws:logs:${var.region}:${var.aws_account_id}:*"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codedeploy.${var.region}.amazonaws.com"
            },
            "Action": [
                "kms:Encrypt*",
                "kms:Decrypt*",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:Describe*"
            ],
            "Resource": "${aws_kms_key.artifact_encryption_key.arn}"
        }
    ]
}
POLICY
  #  enable_key_rotation = var.key_rotation
}
resource "aws_kms_alias" "a" {
  name          = "alias/${var.repo_name}-${var.region_name}-key"
  target_key_id = aws_kms_key.artifact_encryption_key.key_id
}