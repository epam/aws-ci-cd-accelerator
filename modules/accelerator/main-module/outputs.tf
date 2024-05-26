output "artifact_bucket_arn" {
  description = "The Amazon Resource Name (ARN) of the artifact S3 bucket"
  value       = module.buckets.artifact_bucket_arn
}

output "ecr_repo_name" {
  description = "The name of the Amazon Elastic Container Registry (ECR) repository"
  value       = module.buckets.ecr_repo_name
}
