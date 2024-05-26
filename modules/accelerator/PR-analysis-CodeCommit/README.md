# PR-analysis-CodeCommit

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
| [aws_cloudwatch_event_rule.pr_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.build_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_codebuild_project.pr_codecommit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_iam_role.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID where the infrastructure will be deployed | `string` | n/a | yes |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | The image used for the CodeBuild environment | `string` | n/a | yes |
| <a name="input_codeartifact_domain"></a> [codeartifact\_domain](#input\_codeartifact\_domain) | The AWS CodeArtifact domain | `string` | `""` | no |
| <a name="input_codeartifact_repo"></a> [codeartifact\_repo](#input\_codeartifact\_repo) | The AWS CodeArtifact repository | `string` | `""` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The name of the organization | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project name used for resource tagging and naming | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region for the deployment | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the repository | `string` | n/a | yes |
| <a name="input_service_role"></a> [service\_role](#input\_service\_role) | The service role for the deployment | `string` | n/a | yes |
| <a name="input_sonarcloud_token_name"></a> [sonarcloud\_token\_name](#input\_sonarcloud\_token\_name) | The name of the SonarCloud token | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
