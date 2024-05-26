## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ai_lambda"></a> [ai\_lambda](#module\_ai\_lambda) | terraform-aws-modules/lambda/aws | 6.0.0 |
| <a name="module_process_comment_lambda"></a> [process\_comment\_lambda](#module\_process\_comment\_lambda) | terraform-aws-modules/lambda/aws | 6.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ai_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.comment_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.ai_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.comment_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.access_token_bitbucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_source_credential.access_token_github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_iam_policy.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lambda_exec_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_exec_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.basic_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_exec_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function_url.webhook_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [aws_lambda_layer_version.request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.allow_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.lambda_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_exec_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_git_hostname"></a> [git\_hostname](#input\_git\_hostname) | Git URL | `string` | n/a | yes |
| <a name="input_git_owner"></a> [git\_owner](#input\_git\_owner) | GitHub Repository Owner | `string` | n/a | yes |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | GitHub Token | `string` | n/a | yes |
| <a name="input_git_token_name"></a> [git\_token\_name](#input\_git\_token\_name) | Parameter Store Variable Name for GitHub | `string` | n/a | yes |
| <a name="input_git_user"></a> [git\_user](#input\_git\_user) | Bitbucket User Name | `string` | n/a | yes |
| <a name="input_llm_model"></a> [llm\_model](#input\_llm\_model) | LLM Model for AI | `string` | n/a | yes |
| <a name="input_openai_api_endpoint"></a> [openai\_api\_endpoint](#input\_openai\_api\_endpoint) | Open AI Endpoint | `string` | n/a | yes |
| <a name="input_openai_token_name"></a> [openai\_token\_name](#input\_openai\_token\_name) | Parameter Store Variable Name for OPEN AI API KEY | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | VPC Private Subnet IDs | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name used for resource tagging and naming | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where infrastructure resources will be deployed | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | n/a | `string` | n/a | yes |
| <a name="input_repo_names"></a> [repo\_names](#input\_repo\_names) | The name of the GitHub/Bitbucket/CodeCommit repositories connected with Atlantis | `list(string)` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Security Groups for Lambda-Git Connection | `list(string)` | n/a | yes |
| <a name="input_server_type"></a> [server\_type](#input\_server\_type) | Valid values are BITBUCKET, GITHUB | `string` | n/a | yes |
| <a name="input_storage_bucket_prefix"></a> [storage\_bucket\_prefix](#input\_storage\_bucket\_prefix) | The prefix to be used for naming storage buckets | `string` | n/a | yes |
| <a name="input_vcs"></a> [vcs](#input\_vcs) | VCS for AI | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of an existing VPC where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | n/a |
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >=3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >=3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ai_lambda"></a> [ai\_lambda](#module\_ai\_lambda) | terraform-aws-modules/lambda/aws | 6.0.0 |
| <a name="module_ai_lambda_gitlab"></a> [ai\_lambda\_gitlab](#module\_ai\_lambda\_gitlab) | terraform-aws-modules/lambda/aws | 6.0.0 |
| <a name="module_process_comment_lambda"></a> [process\_comment\_lambda](#module\_process\_comment\_lambda) | terraform-aws-modules/lambda/aws | 6.0.0 |
| <a name="module_process_comment_lambda_gitlab"></a> [process\_comment\_lambda\_gitlab](#module\_process\_comment\_lambda\_gitlab) | terraform-aws-modules/lambda/aws | 6.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ai_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.comment_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.ai_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.ai_handler_gitlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.comment_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.comment_handler_gitlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.access_token_bitbucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_codebuild_source_credential.access_token_github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_iam_policy.codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.codebuild_policy_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lambda_exec_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_exec_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.basic_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_exec_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.policy_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function_url.webhook_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_url) | resource |
| [aws_lambda_layer_version.request](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.allow_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_object.layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [null_resource.lambda_layer](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.codebuild_policy_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_exec_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_git_hostname"></a> [git\_hostname](#input\_git\_hostname) | Git URL | `string` | n/a | yes |
| <a name="input_git_owner"></a> [git\_owner](#input\_git\_owner) | GitHub Repository Owner | `string` | n/a | yes |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | GitHub Token | `string` | n/a | yes |
| <a name="input_git_token_name"></a> [git\_token\_name](#input\_git\_token\_name) | Parameter Store Variable Name for Git Token | `string` | `"/atlantis/git/user/token"` | no |
| <a name="input_git_user"></a> [git\_user](#input\_git\_user) | Bitbucket User Name | `string` | n/a | yes |
| <a name="input_llm_model"></a> [llm\_model](#input\_llm\_model) | LLM Model for AI | `string` | n/a | yes |
| <a name="input_openai_api_endpoint"></a> [openai\_api\_endpoint](#input\_openai\_api\_endpoint) | Open AI Endpoint | `string` | n/a | yes |
| <a name="input_openai_token_name"></a> [openai\_token\_name](#input\_openai\_token\_name) | Parameter Store Variable Name for OPEN AI API KEY | `string` | `"/accelerator/openai_token"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | VPC Private Subnet IDs | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name used for resource tagging and naming | `string` | n/a | yes |
| <a name="input_project_ids"></a> [project\_ids](#input\_project\_ids) | List of GitLab projects for working with API | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region where infrastructure resources will be deployed | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | AWS Region Name for better naming, e.g. frankfurt, ireland | `string` | n/a | yes |
| <a name="input_repo_names"></a> [repo\_names](#input\_repo\_names) | The name of the GitHub/Bitbucket/CodeCommit repositories connected with Atlantis | `list(string)` | n/a | yes |
| <a name="input_root_directory"></a> [root\_directory](#input\_root\_directory) | Root directory of terragrunt | `string` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Security Groups for Lambda-Git Connection | `list(string)` | n/a | yes |
| <a name="input_server_type"></a> [server\_type](#input\_server\_type) | Valid values are BITBUCKET, GITHUB | `string` | n/a | yes |
| <a name="input_storage_bucket_prefix"></a> [storage\_bucket\_prefix](#input\_storage\_bucket\_prefix) | The prefix to be used for naming storage buckets | `string` | n/a | yes |
| <a name="input_vcs"></a> [vcs](#input\_vcs) | VCS for AI: github, bitbucket or gitlab. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of an existing VPC where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | Lambda function to be triggered if PR Comment is updated |
<!-- END_TF_DOCS -->
