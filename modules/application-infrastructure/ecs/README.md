## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.app_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.ecs_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.ecs_task_definition_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerator_account_id"></a> [accelerator\_account\_id](#input\_accelerator\_account\_id) | The AWS account ID for the global accelerator | `string` | n/a | yes |
| <a name="input_accelerator_region"></a> [accelerator\_region](#input\_accelerator\_region) | The AWS region for the global accelerator | `string` | n/a | yes |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | The application port for the ECS task definition | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID to deploy to | `string` | n/a | yes |
| <a name="input_aws_kms_arn"></a> [aws\_kms\_arn](#input\_aws\_kms\_arn) | The Amazon Resource Name (ARN) of the AWS KMS key | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The container name for the ECS task definition | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The CPU units for the ECS task definition | `number` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The desired capacity of the application | `list(string)` | n/a | yes |
| <a name="input_ecr_repo_name"></a> [ecr\_repo\_name](#input\_ecr\_repo\_name) | The name of the ECR repository | `string` | n/a | yes |
| <a name="input_ecs_security_groups"></a> [ecs\_security\_groups](#input\_ecs\_security\_groups) | A list of security group IDs to use for the ECS resources | `list(string)` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | A list of environment names for the resources | `list(string)` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | The memory for the ECS task definition | `number` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | A list of private subnet IDs in the VPC | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository | `string` | n/a | yes |
| <a name="input_target_group_blue_arn"></a> [target\_group\_blue\_arn](#input\_target\_group\_blue\_arn) | The Amazon Resource Name (ARN) of the blue target group | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to deploy resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_ecs_execution_role_arn"></a> [ecs\_execution\_role\_arn](#output\_ecs\_execution\_role\_arn) | n/a |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | n/a |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | n/a |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | n/a |
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_template"></a> [template](#provider\_template) | ~> 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.app_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.ecs_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.ecs_task_definition_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerator_account_id"></a> [accelerator\_account\_id](#input\_accelerator\_account\_id) | The AWS account ID for the global accelerator | `string` | n/a | yes |
| <a name="input_accelerator_region"></a> [accelerator\_region](#input\_accelerator\_region) | The AWS region for the global accelerator | `string` | n/a | yes |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | The application port for the ECS task definition | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID to deploy to | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The container name for the ECS task definition | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The CPU units for the ECS task definition | `number` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The desired capacity of the application | `list(string)` | n/a | yes |
| <a name="input_ecr_repo_name"></a> [ecr\_repo\_name](#input\_ecr\_repo\_name) | The name of the ECR repository | `string` | n/a | yes |
| <a name="input_ecs_security_groups"></a> [ecs\_security\_groups](#input\_ecs\_security\_groups) | A list of security group IDs to use for the ECS resources | `list(string)` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | A list of environment names for the resources | `list(string)` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The Amazon Resource Name (ARN) of the AWS KMS key | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | The memory for the ECS task definition | `number` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | A list of private subnet IDs in the VPC | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository | `string` | n/a | yes |
| <a name="input_target_group_blue_arns"></a> [target\_group\_blue\_arns](#input\_target\_group\_blue\_arns) | The Amazon Resource Name (ARN) of the blue target group | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the ECS cluster |
| <a name="output_ecs_execution_role_arn"></a> [ecs\_execution\_role\_arn](#output\_ecs\_execution\_role\_arn) | The ARN of the ECS execution role |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | The ARN of the ECS task role |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | The ARN of the CloudWatch Logs group |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the ECS service |
<!-- END_TF_DOCS -->
