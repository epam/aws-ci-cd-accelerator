# Complete AI Handler Module

Configuration in this directory creates a connection with AI provided by this module:


## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_github.ai_webhook"></a> [github.ai\_webhook](#provider\_github.ai\_webhook) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ai_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.ai-handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.access_token_bitbucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_source_credential.access_token_github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_webhook.webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook) | resource |
| [aws_iam_policy.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ssm_parameter_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.basic_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_parameter_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_url.webhook_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [aws_lambda_layer_version.request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [github_repository_webhook.ai_handler](https://registry.terraform.io/providers/hashicorp/github/latest/docs/resources/repository_webhook) | resource |
| [archive_file.this](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.vcs_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bitbucket_user"></a> [bitbucket\_user](#input\_bitbucket\_user) | Bitbucket User Name | `string` | n/a | yes |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | The time to wait for a CodeBuild to complete before timing out in minutes (default: 5) | `any` | n/a | yes |
| <a name="input_connection_provider"></a> [connection\_provider](#input\_connection\_provider) | Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer. | `string` | n/a | yes |
| <a name="input_github_base_url"></a> [github\_base\_url](#input\_github\_base\_url) | GitHub base URL to use when creating a webhook (for GitHub Enterprise users) | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The organization name for Sonar | `any` | n/a | yes |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | Project Key for Sonar | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | n/a | `any` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g. new-repo). | `any` | n/a | yes |

## Outputs

No outputs.

[`buildspec_with_ai.yml`](../../../docs/template_config_files/buildspec_with_ai.yml) - not used by Terraform code directly. Must be placed with the scripts folder to the application repository which you want to connect with AI handler. Codebuild of AI handler will detect it once started.

`python.zip` - Layer of the Lambda function contains Python request module which is not default.

`lambda_function.py` - Python code of the Lambda. Directly used by Terraform.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.4.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.4.2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_github"></a> [github](#provider\_github) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ai_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.ai_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.access_token_github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_webhook.webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook) | resource |
| [aws_iam_policy.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ssm_parameter_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.basic_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_parameter_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function_url.webhook_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [aws_lambda_layer_version.request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [github_repository_webhook.ai_handler](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |
| [archive_file.this](https://registry.terraform.io/providers/hashicorp/archive/2.4.2/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | The time to wait for a CodeBuild to complete before timing out in minutes (default: 5) | `string` | `"10"` | no |
| <a name="input_connection_provider"></a> [connection\_provider](#input\_connection\_provider) | Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer. | `string` | n/a | yes |
| <a name="input_git_owner"></a> [git\_owner](#input\_git\_owner) | GitHub Repository Owner | `string` | n/a | yes |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | GitHub Token | `string` | n/a | yes |
| <a name="input_git_token_name"></a> [git\_token\_name](#input\_git\_token\_name) | Parameter Store Variable Name for GitHub | `string` | n/a | yes |
| <a name="input_github_base_url"></a> [github\_base\_url](#input\_github\_base\_url) | GitHub base URL to use when creating a webhook (for GitHub Enterprise users) | `string` | `null` | no |
| <a name="input_llm_model"></a> [llm\_model](#input\_llm\_model) | LLM Model for AI | `string` | n/a | yes |
| <a name="input_openai_api_endpoint"></a> [openai\_api\_endpoint](#input\_openai\_api\_endpoint) | Open AI Endpoint | `string` | n/a | yes |
| <a name="input_openai_token_name"></a> [openai\_token\_name](#input\_openai\_token\_name) | Parameter Store Variable Name for OPEN AI API KEY | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | The name of the AWS region | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g. new-repo). | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
