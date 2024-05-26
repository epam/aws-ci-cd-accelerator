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
| [aws_ssm_parameter.c7n_api_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.c7n_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.c7n_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.cognito_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.dojo_api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.infracost_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.openai_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_c7n_api_url"></a> [c7n\_api\_url](#input\_c7n\_api\_url) | The API URL for EPAM Syndicate Rule Engine integration | `string` | n/a | yes |
| <a name="input_c7n_password"></a> [c7n\_password](#input\_c7n\_password) | The password for EPAM Syndicate Rule Engine authentication | `string` | n/a | yes |
| <a name="input_c7n_user"></a> [c7n\_user](#input\_c7n\_user) | The username for EPAM Syndicate Rule Engine authentication | `string` | n/a | yes |
| <a name="input_cognito_password"></a> [cognito\_password](#input\_cognito\_password) | The password for DLT Cognito authentication | `string` | n/a | yes |
| <a name="input_dojo_api_key"></a> [dojo\_api\_key](#input\_dojo\_api\_key) | The API key for Dojo integration | `string` | n/a | yes |
| <a name="input_infracost_api_key"></a> [infracost\_api\_key](#input\_infracost\_api\_key) | The API key for InfraCost integration | `string` | n/a | yes |
| <a name="input_openai_token"></a> [openai\_token](#input\_openai\_token) | AI Token | `string` | n/a | yes |

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
| [aws_ssm_parameter.c7n_api_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.c7n_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.c7n_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.cognito_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.dojo_api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.infracost_api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.openai_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_c7n_api_url"></a> [c7n\_api\_url](#input\_c7n\_api\_url) | The API URL for EPAM Syndicate Rule Engine integration | `string` | n/a | yes |
| <a name="input_c7n_password"></a> [c7n\_password](#input\_c7n\_password) | The password for EPAM Syndicate Rule Engine authentication | `string` | n/a | yes |
| <a name="input_c7n_user"></a> [c7n\_user](#input\_c7n\_user) | The username for EPAM Syndicate Rule Engine authentication | `string` | n/a | yes |
| <a name="input_cognito_password"></a> [cognito\_password](#input\_cognito\_password) | The password for DLT Cognito authentication | `string` | n/a | yes |
| <a name="input_dojo_api_key"></a> [dojo\_api\_key](#input\_dojo\_api\_key) | The API key for Dojo integration | `string` | n/a | yes |
| <a name="input_infracost_api_key"></a> [infracost\_api\_key](#input\_infracost\_api\_key) | The API key for InfraCost integration | `string` | n/a | yes |
| <a name="input_openai_token"></a> [openai\_token](#input\_openai\_token) | AI Token | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
