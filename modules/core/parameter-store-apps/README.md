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
| [aws_ssm_parameter.any](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.git_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rp_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.slack_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.sonar_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.teams_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parameter_store"></a> [parameter\_store](#input\_parameter\_store) | List of AWS Parameter Store configurations | <pre>list(object({<br>    parameter_name  = string<br>    parameter_value = string<br>    parameter_tier            = string<br>    overwrite       = bool<br>    description     = string<br>  }))</pre> | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the repository | `string` | n/a | yes |
| <a name="input_rp_token"></a> [rp\_token](#input\_rp\_token) | The API token for ReportPortal integration | `string` | n/a | yes |
| <a name="input_slack_web_hook"></a> [slack\_web\_hook](#input\_slack\_web\_hook) | The Slack webhook URL for notifications | `string` | n/a | yes |
| <a name="input_sonarcloud_token"></a> [sonarcloud\_token](#input\_sonarcloud\_token) | The API token for SonarCloud integration | `string` | n/a | yes |
| <a name="input_teams_web_hook"></a> [teams\_web\_hook](#input\_teams\_web\_hook) | The Microsoft Teams webhook URL for notifications | `string` | n/a | yes |

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
| [aws_ssm_parameter.any](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.git_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rp_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.slack_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.sonar_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.teams_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | Token for VCS: GitHub, BitBucket or GitLab | `string` | n/a | yes |
| <a name="input_parameter_store"></a> [parameter\_store](#input\_parameter\_store) | List of additional AWS Parameter Store configurations | <pre>list(object({<br>    parameter_name        = string<br>    parameter_value       = string<br>    parameter_tier        = string<br>    parameter_description = string<br>  }))</pre> | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the repository | `string` | n/a | yes |
| <a name="input_rp_token"></a> [rp\_token](#input\_rp\_token) | The API token for ReportPortal integration | `string` | n/a | yes |
| <a name="input_slack_web_hook"></a> [slack\_web\_hook](#input\_slack\_web\_hook) | The Slack webhook URL for notifications | `string` | n/a | yes |
| <a name="input_sonarcloud_token"></a> [sonarcloud\_token](#input\_sonarcloud\_token) | The API token for SonarCloud integration | `string` | n/a | yes |
| <a name="input_teams_web_hook"></a> [teams\_web\_hook](#input\_teams\_web\_hook) | The Microsoft Teams webhook URL for notifications | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
