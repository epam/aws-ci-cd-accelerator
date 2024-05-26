 #============================ Variables for SecretsManager  ============================#
 locals {
 ##=========================== Additional secrets ===========================##
  secrets_manager = [
 ##     Add additional block here if you need to pass a secret to SecretsManager

 #    {
 #      secret_value: "" # The value for the secret
 #      secret_name: "/${local.repo_name}/<'env_name'>/<'var_name/var_list_name'>" # The secret name
 #      secret_description: "" # The secret description
 #      secret_recovery_days: "0" # Number of days before secretion is removed (minimum 7). If you want to delete Secret immediately, set it to 0
 #    }
  ]
 ##=========================== Service variables (automatically filled) ===========================##
      env_vars        = read_terragrunt_config("env.hcl")
      repo_name       = local.env_vars.locals.repo_name
}
