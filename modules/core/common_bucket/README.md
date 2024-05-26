# common_bucket

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_storage_bucket"></a> [s3\_storage\_bucket](#module\_s3\_storage\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_object.dlt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_iam_policy_document.s3_storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID where the infrastructure will be deployed | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project name used for resource tagging and naming | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where the infrastructure will be deployed | `string` | n/a | yes |
| <a name="input_storage_bucket_prefix"></a> [storage\_bucket\_prefix](#input\_storage\_bucket\_prefix) | The prefix to be used for naming storage bucket | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_common_bucket_arn"></a> [common\_bucket\_arn](#output\_common\_bucket\_arn) | The Amazon Resource Name (ARN) of the S3 storage bucket |
| <a name="output_common_bucket_id"></a> [common\_bucket\_id](#output\_common\_bucket\_id) | The ID of the S3 storage bucket |
<!-- END_TF_DOCS -->
