# kms

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | 2.1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_service_users"></a> [key\_service\_users](#input\_key\_service\_users) | A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration) | `list(string)` | n/a | yes |
| <a name="input_key_users"></a> [key\_users](#input\_key\_users) | A list of IAM ARNs for [key users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-users) | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | The ID of the KMS key |
<!-- END_TF_DOCS -->
