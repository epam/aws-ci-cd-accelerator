plugin "aws" {
  enabled = true
  version = "0.26.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
plugin "terraform" {
  enabled = true
  version = "0.4.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}
config {
  format     = "default"
  plugin_dir = "~/.tflint.d/plugins"

  module              = true
  force               = true
  disabled_by_default = false
}
rule "terraform_standard_module_structure" {
  enabled = true
}
