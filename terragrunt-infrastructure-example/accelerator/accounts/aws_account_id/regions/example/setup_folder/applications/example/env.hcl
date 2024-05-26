# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.

locals {
  # Accounts and regions for stages
  stages = {
    #    dev = { account = "", regions = [], region_names = [] }
    #    qa  = { account = "", regions = [], region_names = [] }
    #    uat = { account = "", regions = [], region_names = [] }

    # Or stages can be combined if the account and region are the same
    dev-qa-uat = {
      account = "", regions = [], region_names = []
    }
  }

  ##======================== Application CI/CD ===========================##
  repo_name = "" # Application Git Repository Name

  ##======================== Variables for Application Infrastructure ===========================##
  target_type = "ip" # The type of deployment target (Can be: "ip", "instance", "eks", "kube_cluster")
   ##======================== Parameters for Sonar ===========================##
  sonar_url             = "https://sonarcloud.io"  # Sonar URL
  sonarcloud_token_name = "/${local.repo_name}/sonar/token" # The name for Parameter in ParameterStore with Sonar token
  project_key           = "" # Sonar project key
  organization_name     = "" # Sonar organization name
  ##======================== AI handler ===========================##
  ai_handler_create     = false  # AI handler creation switch
  git_owner             = ""  # Git Repository Owner
  git_token_name      = "/${local.repo_name}/git/token" # The name of the ParameterStore Parameter for Git Repository token
  llm_model             = "text-davinci-003" # The LLM model for AI handler
  openai_api_endpoint   = "https://api.openai.com/v1/completions" # The API endpoint for AI
  openai_token_name     = "/accelerator/openai_token" # The API token ParameterStore Parameter name for AI handler
  connection_provider = "GitHub" # The connection provider for AI hadler
}
