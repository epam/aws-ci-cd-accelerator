# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {

  # Regions for Stages
  replica_regions = try([
    for region in flatten(local.environment_vars.locals.stage_regions) : region if region != local.aws_region
  ], [])
  # Automatically load common-project-level variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  account_name      = local.account_vars.locals.account_name
  account_id        = local.account_vars.locals.aws_account_id
  aws_region        = local.region_vars.locals.region
  assume_role_arn   = try(local.account_vars.locals.assume_role_arn, null)
  assume_role_usage = local.assume_role_arn == null ? false : true
}

# Set variable assume_role_arn in env.hcl to generate config by role
# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
%{if !"${local.assume_role_usage}"}
provider "aws" {
  region = "${local.aws_region}"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
  default_tags {
    tags = var.default_tags
  }
}
%{for region in local.replica_regions~}
provider "aws" {
  alias  = "${region}"
  region = "${region}"
  default_tags {
    tags = var.default_tags
  }
}
%{endfor~}

provider "aws" {
  alias  = "east"
  region = "us-east-1"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
  default_tags {
    tags = var.default_tags
  }
}

%{endif}
%{if "${local.assume_role_usage}"}
provider "aws" {
  region = "${local.aws_region}"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
  assume_role {
    role_arn     = "${local.assume_role_arn}"
    session_name = "terragrunt"
  }
  default_tags {
    tags = var.default_tags
  }
}
%{for region in local.replica_regions~}
provider "aws" {
  alias  = "${region}"
  region = "${region}"
  assume_role {
    role_arn     = "${local.assume_role_arn}"
    session_name = "terragrunt"
  }
  default_tags {
    tags = var.default_tags
  }
}
%{endfor~}
provider "aws" {
  alias  = "east"
  region = "us-east-1"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
  assume_role {
    role_arn     = "${local.assume_role_arn}"
    session_name = "terragrunt"
  }
  default_tags {
    tags = var.default_tags
  }
}
%{endif}
variable "default_tags" {
  type        = map(string)
  description = "Default tags for AWS that will be attached to each resource."
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.common_vars.locals.backend_bucket_prefix}-${local.common_vars.locals.project}-${local.account_id}-${local.account_name}-${local.aws_region}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "${local.common_vars.locals.backend_bucket_prefix}-${local.common_vars.locals.project}-${local.account_id}-${local.account_name}-${local.aws_region}"
    role_arn       = try(local.assume_role_arn, null)
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.common_vars.locals,
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
  {
    root_directory = get_parent_terragrunt_dir()
  }
)
