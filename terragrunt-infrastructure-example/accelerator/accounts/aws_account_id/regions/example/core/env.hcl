# Set common variables for the environment. This is automatically pulled in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  ##========================== VPC ==========================##
  cidr                = "10.0.0.0/16" # Cidr Block for VPC
  enable_nat_gateway  = true # Creating NAT gateways for each of the private networks
  single_nat_gateway  = true # Providing a single common NAT gateway across all private networks
  reuse_nat_ips       = true # Do not create EIPs for NAT gateways, and pass them through the external_nat_ip_ids variable
  external_nat_ip_ids = [] # Reserved Elastic IP (The parameter is required only when reuse_nat_ips = true).
  nat_prefix_list_ids = [] # Prefix List IDs for access to NAT.

  ##========================== Atlantis ==========================##
  atlantis_prefix_list_ids = [] # Prefix List IDs for interactin Atlantis and Git
  allowed_cidr_blocks      = [] # Allowed Ip Cidr Blocks for access to Atlantis
  allowed_prefix_list_ids  = [] # Allowed Prefix Lists for access to Atlantis
  atlantis_name            = "" # Atlantis Name, default atlantis
  route53_zone_name        = "" # Route53 zone name for the project.
  git_hostname             = "github.com" # https://www.runatlantis.io/docs/server-configuration.html#repo-allowlist
  git_owner                = "" # Git Repository Owner
  git_user                 = "" # Git Repository User
  repo_names               = [""] # List of repo names to connect to Atlantis
  vcs                      = "github" # VCS type for infrastructure ("github", or "bitbucket" or "gitlab")
  project_ids              = [] # Only for GitLab project id
  ##========================== AI Handler for Terraform ==========================##
  ai_handler_create   = false # Creation of AI Handler infrastructure
  server_type         = local.vcs == "github" ? "GITHUB" : (local.vcs == "bitbucket" ? "BITBUCKET" : "") # VCS type for AI Handler
  llm_model           = "gpt-3.5-turbo" # LLM for AI Handler
  openai_api_endpoint = "https://api.openai.com/v1/completions" # Endpoint for AI API

  ##======================== DLT ========================##
  dlt_create  = false # Creation of DLT infrastructure
  admin_name  = "" # DLT infrastructure administrator name
  admin_email = "" # DLT infrastructure administrator email
  enable_waf  = false # Enable or disable WAF for DLT web interface

  ##======================= EPAM Syndicate Rule Engine ===========================##
  c7n_api_url       = ""# EPAM Syndicate Rule Engine URL
}
