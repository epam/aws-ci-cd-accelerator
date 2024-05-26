output "artifact_bucket_arn" {
  description = "The ARN of the S3 bucket for artifacts"
  value       = module.s3_bucket_artifact.s3_bucket_arn
}

output "artifact_bucket" {
  description = "The ID of the S3 bucket for artifacts"
  value       = module.s3_bucket_artifact.s3_bucket_id
}

output "aws_kms_key" {
  description = "The AWS Key Management Service (KMS) key ID"
  value       = module.kms.key_id
}

output "aws_kms_key_arn" {
  description = "The AWS Key Management Service (KMS) key ARN"
  value       = module.kms.key_arn
}

output "ecr_repo_name" {
  description = "The name of the Amazon Elastic Container Registry (ECR) repository"
  value       = var.target_type != "instance" ? aws_ecr_repository.this[0].name : null
}
