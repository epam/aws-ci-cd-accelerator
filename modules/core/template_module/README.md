### Deploying this module `Terragrunt` structured folders will be created

## Requirements

| Name | Version  |
|------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | \>= 1.0  |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | \>= 5.0  |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.4.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.4.0 |
| <a name="provider_template"></a> [template](#provider\_template) | ~> 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.account](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.replica](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [template_dir.application_infra](https://registry.terraform.io/providers/hashicorp/template/latest/docs/resources/dir) | resource |
| [template_dir.ci_cd](https://registry.terraform.io/providers/hashicorp/template/latest/docs/resources/dir) | resource |
| [template_file.account](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.replica](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The name of the AWS account | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID where the infrastructure will be deployed | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region for the deployment | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the repository | `string` | n/a | yes |
| <a name="input_root_directory"></a> [root\_directory](#input\_root\_directory) | The root directory of the project | `string` | n/a | yes |
| <a name="input_stages"></a> [stages](#input\_stages) | A map of stage configurations, including accounts and regions | <pre>map(object({<br>    account      = string<br>    regions      = list(string)<br>    region_names = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | The target type for the deployment | `string` | n/a | yes |

## Outputs

No outputs.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.4.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.4.0 |
| <a name="provider_template"></a> [template](#provider\_template) | ~> 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.account](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.replica](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [template_dir.application_infra](https://registry.terraform.io/providers/hashicorp/template/latest/docs/resources/dir) | resource |
| [template_dir.ci_cd](https://registry.terraform.io/providers/hashicorp/template/latest/docs/resources/dir) | resource |
| [template_file.account](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.replica](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID where the infrastructure will be deployed | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region for the deployment | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the repository | `string` | n/a | yes |
| <a name="input_root_directory"></a> [root\_directory](#input\_root\_directory) | The root directory of the project | `string` | n/a | yes |
| <a name="input_stages"></a> [stages](#input\_stages) | A map of stage configurations, including accounts and regions | <pre>map(object({<br>    account      = string<br>    regions      = list(string)<br>    region_names = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | The target type for the deployment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ci_cd_directory"></a> [ci\_cd\_directory](#output\_ci\_cd\_directory) | The path to the ci/cd directory |
<!-- END_TF_DOCS -->
