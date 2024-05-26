# c7n_epam

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
| [aws_iam_role.read_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.read_only_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ssm_parameter.role_for_custodian](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlantis_role_arn"></a> [atlantis\_role\_arn](#input\_atlantis\_role\_arn) | The Atlantis ECS task role arn | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where infrastructure resources will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_c7n_role_arn"></a> [c7n\_role\_arn](#output\_c7n\_role\_arn) | Read only role for C7n utility run |
<!-- END_TF_DOCS -->
