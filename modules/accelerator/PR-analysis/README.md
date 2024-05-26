## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.pull-request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.access_token_bitbucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_source_credential.access_token_github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_webhook.webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook) | resource |
| [aws_ssm_parameter.vcs_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID to deploy to | `string` | n/a | yes |
| <a name="input_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#input\_aws\_kms\_key\_arn) | The Amazon Resource Name (ARN) of the AWS KMS key | `string` | n/a | yes |
| <a name="input_bitbucket_user"></a> [bitbucket\_user](#input\_bitbucket\_user) | The Bitbucket username for the connection | `string` | n/a | yes |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | The compute type used for the CodeBuild environment | `string` | n/a | yes |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | The image used for the CodeBuild environment | `string` | n/a | yes |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | The build timeout for the CodeBuild project | `string` | n/a | yes |
| <a name="input_codeartifact_domain"></a> [codeartifact\_domain](#input\_codeartifact\_domain) | The CodeArtifact domain name | `string` | `""` | no |
| <a name="input_codeartifact_repo"></a> [codeartifact\_repo](#input\_codeartifact\_repo) | The CodeArtifact repository name | `string` | `""` | no |
| <a name="input_connection_provider"></a> [connection\_provider](#input\_connection\_provider) | The connection provider for the CodeStar connections | `string` | n/a | yes |
| <a name="input_github_token_name"></a> [github\_token\_name](#input\_github\_token\_name) | Parameter Store Variable Name for GitHub | `string` | n/a | yes |
| <a name="input_llm_model"></a> [llm\_model](#input\_llm\_model) | LLM Model for AI | `string` | n/a | yes |
| <a name="input_openai_api_endpoint"></a> [openai\_api\_endpoint](#input\_openai\_api\_endpoint) | Open AI Endpoint | `string` | n/a | yes |
| <a name="input_openai_token_name"></a> [openai\_token\_name](#input\_openai\_token\_name) | Parameter Store Variable Name for OPEN AI API KEY | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The name of the organization | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | A list of private subnet IDs in the VPC | `list(string)` | n/a | yes |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | The project key identifier | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo) | `string` | n/a | yes |
| <a name="input_report_portal_environments"></a> [report\_portal\_environments](#input\_report\_portal\_environments) | A list of Report Portal environments | `list(map(string))` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group IDs for the resources | `list(string)` | n/a | yes |
| <a name="input_service_role"></a> [service\_role](#input\_service\_role) | The service IAM role for the resources | `string` | n/a | yes |
| <a name="input_sonar_url"></a> [sonar\_url](#input\_sonar\_url) | The URL of the SonarQube server | `string` | n/a | yes |
| <a name="input_sonarcloud_token_name"></a> [sonarcloud\_token\_name](#input\_sonarcloud\_token\_name) | The name of the SonarCloud token | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to deploy resources | `string` | n/a | yes |

## Outputs

No outputs.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.pull_request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.access_token_bitbucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_source_credential.access_token_github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_webhook.webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook) | resource |
| [aws_ssm_parameter.vcs_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID to deploy to | `string` | n/a | yes |
| <a name="input_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#input\_aws\_kms\_key\_arn) | The Amazon Resource Name (ARN) of the AWS KMS key | `string` | n/a | yes |
| <a name="input_bitbucket_user"></a> [bitbucket\_user](#input\_bitbucket\_user) | The Bitbucket username for the connection | `string` | n/a | yes |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | The compute type used for the CodeBuild environment | `string` | n/a | yes |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | The image used for the CodeBuild environment | `string` | n/a | yes |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | The build timeout for the CodeBuild project | `string` | n/a | yes |
| <a name="input_codeartifact_domain"></a> [codeartifact\_domain](#input\_codeartifact\_domain) | The CodeArtifact domain name | `string` | `""` | no |
| <a name="input_codeartifact_repo"></a> [codeartifact\_repo](#input\_codeartifact\_repo) | The CodeArtifact repository name | `string` | `""` | no |
| <a name="input_connection_provider"></a> [connection\_provider](#input\_connection\_provider) | The connection provider for the CodeStar connections | `string` | n/a | yes |
| <a name="input_git_owner"></a> [git\_owner](#input\_git\_owner) | Git Repository Owner | `string` | n/a | yes |
| <a name="input_llm_model"></a> [llm\_model](#input\_llm\_model) | LLM Model for AI | `string` | n/a | yes |
| <a name="input_openai_api_endpoint"></a> [openai\_api\_endpoint](#input\_openai\_api\_endpoint) | Open AI Endpoint | `string` | n/a | yes |
| <a name="input_openai_token_name"></a> [openai\_token\_name](#input\_openai\_token\_name) | Parameter Store Variable Name for OPEN AI API KEY | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The name of the organization | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | A list of private subnet IDs in the VPC | `list(string)` | n/a | yes |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | The project key identifier | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo) | `string` | n/a | yes |
| <a name="input_report_portal_environments"></a> [report\_portal\_environments](#input\_report\_portal\_environments) | A list of Report Portal environments | `list(map(string))` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | A list of security group IDs for the resources | `list(string)` | n/a | yes |
| <a name="input_service_role"></a> [service\_role](#input\_service\_role) | The service IAM role for the resources | `string` | n/a | yes |
| <a name="input_sonar_url"></a> [sonar\_url](#input\_sonar\_url) | The URL of the SonarQube server | `string` | n/a | yes |
| <a name="input_sonarcloud_token_name"></a> [sonarcloud\_token\_name](#input\_sonarcloud\_token\_name) | The name of the SonarCloud token | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to deploy resources | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
