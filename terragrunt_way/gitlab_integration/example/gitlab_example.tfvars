#===================================== GitLab Block ===========================================#
gitlab_hostname = "" # GitLab HostName
project_id      = "" # GitLab Project ID
aws_user_name   = "" # AWS User whose SSH key we use for AWS CodeCommit
gitlab_token    = "" # Token for GitLab Project
aws_repo_name   = "" # Name of AWS CodeCommit Repository(The same as GitLab)

#===================================== PR Sonar Check ================================================#

sonar_url         = "https://sonarcloud.io" # Sonar URI
sonarcloud_token  = "" # Sonar Token
organization_name = "" # Organisation or Group Name of Repository which connect with Sonar
project_key       = "" # Sonar project key
project           = "" # Sonar Project Name
sonar_timeout     = 300 # Sonar timeout for quality gate