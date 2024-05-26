#======================= CodeStar Connections =======================#
locals {
  codestarconnection = {
    ConnectionArn = contains([
      "GitHubEnterpriseServer",
      #      "GitLabSelfManaged"
    ], var.connection_provider) ? aws_cloudformation_stack.codestar[0].outputs["ConnectionArn"] : aws_codestarconnections_connection.codestar_connection[0].arn
    FullRepositoryId     = "${var.git_owner}/${var.repo_name}"
    OutputArtifactFormat = "CODEBUILD_CLONE_REF"
    BranchName           = var.repo_default_branch

  }
  codecommit = {
    RepositoryName = var.repo_name
    BranchName     = var.repo_default_branch
    OutputArtifactFormat : "CODEBUILD_CLONE_REF"
  }
  provider = contains([
    "GitHub", "Bitbucket", "GitHubEnterpriseServer"
  ], var.connection_provider) ? "CodeStarSourceConnection" : "CodeCommit"
}
resource "aws_codestarconnections_connection" "codestar_connection" {
  count = contains([
    "GitHub", "Bitbucket"
  ], var.connection_provider) ? 1 : 0
  name          = "${var.connection_provider}-${var.repo_name}-${var.region_name}"
  provider_type = var.connection_provider
}

resource "aws_codestarconnections_host" "myhost" {
  count = contains(["GitHubEnterpriseServer"], var.connection_provider) ? 1 : 0
  #  count             = contains(["GitHubEnterpriseServer", "GitLabSelfManaged"], var.connection_provider) ? 1 : 0
  name              = "${var.repo_name}-${var.region_name}-host"
  provider_endpoint = var.provider_endpoint
  provider_type     = var.connection_provider

  vpc_configuration {
    vpc_id             = var.vpc_id
    subnet_ids         = var.private_subnet_ids
    security_group_ids = var.security_groups
  }
}

#resource "aws_codestarconnections_connection" "codestar_connection_host" {
#  count    = contains(["GitHubEnterpriseServer"], var.connection_provider) ? 1 : 0
#  #  count = contains(["GitHubEnterpriseServer", "GitLabSelfManaged"], var.connection_provider) ? 1 : 0 TODO Uncomment when Terraform updates
#  name     = "${var.connection_provider}-${var.repo_name}-${var.region_name}"
#  host_arn = aws_codestarconnections_host.myhost[0].arn
#}

resource "aws_cloudformation_stack" "codestar" {
  count = var.connection_provider == "GitLabSelfManaged" ? 1 : 0
  name  = "codestar-${var.repo_name}-${var.region_name}-stack"

  parameters = {
    HostName     = "${var.repo_name}-${var.region_name}"
    ProviderType = var.connection_provider
  }

  template_body = jsonencode({
    Parameters = {
      HostName = {
        Type    = "String"
        Default = "${var.repo_name}-${var.region_name}"
      },
      ProviderType = {
        Type    = "String",
        Default = var.connection_provider
      }
    }
    Resources = {
      #      MyCodeStarHost : { TODO Uncomment after CF updates and 'AWS::CodeStarConnections::Host' will be available
      #        Type       = "AWS::CodeStarConnections::Host",
      #        Properties = {
      #          Name             = { "Ref" = "HostName" },
      #          ProviderType     = { "Ref" = "ProviderType" },
      #          ProviderEndpoint = var.provider_endpoint,
      #          VpcConfiguration = {
      #            VpcId            = var.vpc_id,
      #            SubnetIds        = var.private_subnet_ids,
      #            SecurityGroupIds = var.security_groups,
      #          },
      #        }
      #      }
      MyCodeStarConnection : {
        Type = "AWS::CodeStarConnections::Connection",
        Properties : {
          ConnectionName = { "Ref" = "HostName" },
          #          HostArn        = { "Fn::GetAtt" = ["MyCodeStarHost", "HostArn"] } TODO Uncomment after CF Updates
          HostArn = var.connection_provider == "GitLabSelfManaged" ? var.codestarconnection_host_arn : aws_codestarconnections_host.myhost[0].arn
        }
      }
    }
    Outputs = {
      ConnectionArn = {
        Value       = { "Fn::GetAtt" = ["MyCodeStarConnection", "ConnectionArn"] },
        Description = "The ARN of the CodeStar connection"
      }
    }
  })

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]


}
