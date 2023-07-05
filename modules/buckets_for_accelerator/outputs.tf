output "storage_bucket" {
  value = aws_s3_bucket.storage.id
}

output "storage_bucket_arn" {
  value = aws_s3_bucket.storage.arn
}
output "artifact_bucket_arn" {
  value = aws_s3_bucket.build_artifact_bucket.arn
}
output "artifact_bucket" {
  value = aws_s3_bucket.build_artifact_bucket.id
}

output "aws_kms_key" {
  value = aws_kms_key.artifact_encryption_key.key_id
}

output "aws_kms_key_arn" {
  value = aws_kms_key.artifact_encryption_key.arn
}