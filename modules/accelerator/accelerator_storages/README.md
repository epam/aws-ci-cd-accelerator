## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.4.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_template"></a> [template](#provider\_template) | ~> 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | 2.1.0 |
| <a name="module_s3_bucket_artifact"></a> [s3\_bucket\_artifact](#module\_s3\_bucket\_artifact) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |
| <a name="module_s3_bucket_service"></a> [s3\_bucket\_service](#module\_s3\_bucket\_service) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_s3_object.deb_script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.taskdef](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_artifact](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.taskdef](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_identifiers"></a> [account\_identifiers](#input\_account\_identifiers) | A list of AWS account identifiers | `list(string)` | n/a | yes |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | The application port for the ECS task definition | `string` | n/a | yes |
| <a name="input_artifact_bucket_identifiers"></a> [artifact\_bucket\_identifiers](#input\_artifact\_bucket\_identifiers) | A list of identifiers for the artifact bucket | `list(string)` | n/a | yes |
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | The prefix for the artifacts bucket | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID to deploy to | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The container name for the ECS task definition | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The CPU units for the ECS task definition | `number` | n/a | yes |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | A map of environment variables for the ECS task definition | `map(list(map(string)))` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to forcefully destroy resources (default: false) | `bool` | `false` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Mutability of docker image tag of application | `string` | n/a | yes |
| <a name="input_key_service_users"></a> [key\_service\_users](#input\_key\_service\_users) | A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration) | `list(string)` | n/a | yes |
| <a name="input_kms_identifiers"></a> [kms\_identifiers](#input\_kms\_identifiers) | A list of role ARNs for KMS | `list(string)` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | The memory for the ECS task definition | `number` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo) | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | A map of secret values for the ECS task definition | `map(list(map(string)))` | n/a | yes |
| <a name="input_service_bucket_prefix"></a> [service\_bucket\_prefix](#input\_service\_bucket\_prefix) | The prefix for the service bucket where we store task definition files for ECS or EC2 script | `string` | n/a | yes |
| <a name="input_stages"></a> [stages](#input\_stages) | A map of stage configurations, including AWS accounts, regions, and region names | <pre>map(object({<br>    account      = string<br>    regions      = list(string)<br>    region_names = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | The target type of the deployed resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact_bucket"></a> [artifact\_bucket](#output\_artifact\_bucket) | n/a |
| <a name="output_artifact_bucket_arn"></a> [artifact\_bucket\_arn](#output\_artifact\_bucket\_arn) | output "storage\_bucket" { value = module.s3\_storage\_bucket.s3\_bucket\_id }  output "storage\_bucket\_arn" { value = module.s3\_storage\_bucket.s3\_bucket\_arn } |
| <a name="output_aws_kms_key"></a> [aws\_kms\_key](#output\_aws\_kms\_key) | n/a |
| <a name="output_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#output\_aws\_kms\_key\_arn) | n/a |
| <a name="output_ecr_repo_name"></a> [ecr\_repo\_name](#output\_ecr\_repo\_name) | n/a |
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_template"></a> [template](#provider\_template) | ~> 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | 2.1.0 |
| <a name="module_s3_bucket_artifact"></a> [s3\_bucket\_artifact](#module\_s3\_bucket\_artifact) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |
| <a name="module_s3_bucket_service"></a> [s3\_bucket\_service](#module\_s3\_bucket\_service) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_s3_object.deb_script](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.taskdef](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_artifact](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.taskdef](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_identifiers"></a> [account\_identifiers](#input\_account\_identifiers) | A list of AWS account identifiers | `list(string)` | n/a | yes |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | The application port for the ECS task definition | `string` | n/a | yes |
| <a name="input_artifact_bucket_identifiers"></a> [artifact\_bucket\_identifiers](#input\_artifact\_bucket\_identifiers) | A list of identifiers for the artifact bucket | `list(string)` | n/a | yes |
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | The prefix for the artifacts bucket | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID to deploy to | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The container name for the ECS task definition | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The CPU units for the ECS task definition | `number` | n/a | yes |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | A map of environment variables for the ECS task definition | `map(list(map(string)))` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to forcefully destroy resources (default: false) | `bool` | `false` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Mutability of docker image tag of application | `string` | n/a | yes |
| <a name="input_key_service_users"></a> [key\_service\_users](#input\_key\_service\_users) | A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration) | `list(string)` | n/a | yes |
| <a name="input_kms_identifiers"></a> [kms\_identifiers](#input\_kms\_identifiers) | A list of role ARNs for KMS | `list(string)` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | The memory for the ECS task definition | `number` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo) | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | A map of secret values for the ECS task definition | `map(list(map(string)))` | n/a | yes |
| <a name="input_service_bucket_prefix"></a> [service\_bucket\_prefix](#input\_service\_bucket\_prefix) | The prefix for the service bucket where we store task definition files for ECS or EC2 script | `string` | n/a | yes |
| <a name="input_stages"></a> [stages](#input\_stages) | A map of stage configurations, including AWS accounts, regions, and region names | <pre>map(object({<br>    account      = string<br>    regions      = list(string)<br>    region_names = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | The target type of the deployed resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact_bucket"></a> [artifact\_bucket](#output\_artifact\_bucket) | The ID of the S3 bucket for artifacts |
| <a name="output_artifact_bucket_arn"></a> [artifact\_bucket\_arn](#output\_artifact\_bucket\_arn) | The ARN of the S3 bucket for artifacts |
| <a name="output_aws_kms_key"></a> [aws\_kms\_key](#output\_aws\_kms\_key) | The AWS Key Management Service (KMS) key ID |
| <a name="output_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#output\_aws\_kms\_key\_arn) | The AWS Key Management Service (KMS) key ARN |
| <a name="output_ecr_repo_name"></a> [ecr\_repo\_name](#output\_ecr\_repo\_name) | The name of the Amazon Elastic Container Registry (ECR) repository |
<!-- END_TF_DOCS -->
