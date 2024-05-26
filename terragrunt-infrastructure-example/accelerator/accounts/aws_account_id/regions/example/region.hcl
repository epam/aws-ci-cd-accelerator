# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  region      = "" # AWS region to setup the core
  region_name = ""  # An alias for the region. Will be used in naming infrastructure components
}
