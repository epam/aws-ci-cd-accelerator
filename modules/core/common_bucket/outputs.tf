output "common_bucket_id" {
  description = "The ID of the S3 storage bucket"
  value       = module.s3_storage_bucket.s3_bucket_id
}

output "common_bucket_arn" {
  description = "The Amazon Resource Name (ARN) of the S3 storage bucket"
  value       = module.s3_storage_bucket.s3_bucket_arn
}
