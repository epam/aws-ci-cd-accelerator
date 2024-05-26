output "kms_key_id" {
  description = "The ID of the KMS key"
  value       = module.kms.key_id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key"
  value       = module.kms.key_arn
}

# output "artifact_bucket_id" {
#  description = "The id of the artifact S3 bucket"
#  value = module.s3-bucket.s3_bucket_id
#}

# output "artifact_bucket_arn" {
#  description = "The ARN of the artifact S3 bucket"
#  value = module.s3-bucket.s3_bucket_arn
#}
