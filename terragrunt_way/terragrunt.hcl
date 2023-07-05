# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = local.common_vars.tf_state_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.common_vars.region
    encrypt        = true
    dynamodb_table = local.common_vars.tf_state_bucket
  }
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.common_vars.region}"
  default_tags {
    tags = var.default_tags
  }
}
provider "aws" {
  alias  = "east"
  region = "us-east-1"
  default_tags {
    tags = var.default_tags
  }
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for AWS that will be attached to each resource."
}
EOF
}

locals {
  common_vars       = yamldecode(file("common_vars.yml"))
}

inputs = {
  default_tags = {
    "Project"    = local.common_vars.project
    "Team"       = "DevOps",
    "DeployedBy" = "Terragrunt",
    "OwnerEmail" = "devops@example.com"
  }
}
