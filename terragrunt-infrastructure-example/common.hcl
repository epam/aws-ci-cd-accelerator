locals {
  # Define variables to form Terraform State Bucket
  project               = "" # The short Name for project
  backend_bucket_prefix = "backend" # The prefix for backend bucket
  # Define prefixes for ci/cd buckets
  artifact_bucket_prefix = "codepipeline-artifacts" # The prefix for the artifact bucket
  storage_bucket_prefix  = "storage-bucket" # The prefix for the storage bucket
  service_bucket_prefix  = "service-bucket" # The prefix for the service bucket
  # Default tags for all project resources
  default_tags = {
    Project    = local.project
    Team       = "DevOps",
    DeployedBy = "Terragrunt",
    OwnerEmail = "devops@example.com"
    Terraform  = "true"
  }
}
