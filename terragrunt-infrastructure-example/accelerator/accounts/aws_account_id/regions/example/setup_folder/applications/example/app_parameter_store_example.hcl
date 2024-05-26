#============================ Variables for ParameterStore ============================#
locals {
  ##=========================== VCS Token ===========================##
  git_token = "" # Token for Git
  ##=========================== SonarCloud Sonar ===========================##
  sonarcloud_token = "" # Token for SonarCloud
  ##=========================== Report Portal Token ===========================##
  rp_token = "" # Token for Report Portal
  ##=========================== Teams Token ===========================##
  teams_web_hook = "" # Token for Teams
  ##=========================== Slack Token ===========================##
  slack_web_hook = "" # Slack WebHook if you use Slack for Notifications

  ##=========================== AWS-GITLAB Integration ===========================##
        # Define these variables if your application is hosted on GitLab #

  gitlab_hostname = ""
  project_id      = ""
  aws_user_name   = ""
  gitlab_token    = ""
  gitlab_user     = ""
  app_language    = "go" # "python", "java"
  ##=========================== Additional parameters ===========================##
  parameter_store = [
#     Add additional block here if you need to pass a parameter to ParameterStore
    #    {
    #      parameter_value = "" # The value for the parameter
    #      parameter_name  = "" # The parameter name
    #      tier            = "Standard" # The tier for the parameter. For the "Advanced" level, a fee will apply
    #      description     = "" # The description for parameter
    #    }
  ]
  ##=========================== Service variables (automatically filled) ===========================##
  env_vars        = read_terragrunt_config("env.hcl")
  repo_name       = local.env_vars.locals.repo_name
}
