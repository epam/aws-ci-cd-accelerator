# aws_gitlab_integration

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | 3.20.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 4.0.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | 3.20.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 4.0.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codecommit_repository.gitlab_repo_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository) | resource |
| [aws_iam_user_policy.codecommit_allow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_ssh_key.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_ssh_key) | resource |
| [gitlab_project_variable.app_language](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_variable) | resource |
| [gitlab_project_variable.repo_url](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_variable) | resource |
| [gitlab_project_variable.sonar_login](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_variable) | resource |
| [gitlab_project_variable.sonar_organization_name](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_variable) | resource |
| [gitlab_project_variable.sonar_project_key](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_variable) | resource |
| [gitlab_project_variable.sonar_project_name](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_variable) | resource |
| [gitlab_project_variable.sonar_qg_timeout](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_variable) | resource |
| [gitlab_project_variable.sonar_url](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_variable) | resource |
| [gitlab_project_variable.ssh_key](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_variable) | resource |
| [gitlab_project_variable.user_name](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_variable) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_language"></a> [app\_language](#input\_app\_language) | The programming language of the application, used in the CI/CD pipeline. | `string` | `""` | no |
| <a name="input_aws_repo_name"></a> [aws\_repo\_name](#input\_aws\_repo\_name) | The name of the AWS CodeCommit repository to be created for mirroring. | `string` | `""` | no |
| <a name="input_aws_user_name"></a> [aws\_user\_name](#input\_aws\_user\_name) | The name of the AWS IAM user to create the AWS CodeCommit repository and IAM policies. | `string` | `""` | no |
| <a name="input_gitlab_hostname"></a> [gitlab\_hostname](#input\_gitlab\_hostname) | The GitLab instance's hostname, used to configure the GitLab provider's base URL. | `string` | `""` | no |
| <a name="input_gitlab_token"></a> [gitlab\_token](#input\_gitlab\_token) | The GitLab API token, used to authenticate requests to the GitLab instance. | `string` | `""` | no |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The name of the organization in SonarCloud where the project will be analyzed. | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GitLab project ID where the CI/CD pipeline variables will be added. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where the CodeCommit repository will be created. | `string` | n/a | yes |
| <a name="input_sonar_project_key"></a> [sonar\_project\_key](#input\_sonar\_project\_key) | The unique identifier for the project in SonarCloud. | `string` | `""` | no |
| <a name="input_sonar_project_name"></a> [sonar\_project\_name](#input\_sonar\_project\_name) | The name of the project in SonarCloud. | `string` | `""` | no |
| <a name="input_sonar_timeout"></a> [sonar\_timeout](#input\_sonar\_timeout) | The timeout duration for waiting for the SonarQube or SonarCloud quality gate status. | `number` | `300` | no |
| <a name="input_sonar_url"></a> [sonar\_url](#input\_sonar\_url) | The URL of the SonarQube or SonarCloud instance used for code analysis. | `string` | `""` | no |
| <a name="input_sonarcloud_token"></a> [sonarcloud\_token](#input\_sonarcloud\_token) | The SonarCloud API token used to authenticate requests to the SonarCloud instance. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
