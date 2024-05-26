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
| [aws_codedeploy_app.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_codedeploy_deployment_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_iam_policy.codedeploy_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codedeploy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.codedeploy_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codedeploy_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codedeploy_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.codedeploy_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.codedeploy_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerator_account_id"></a> [accelerator\_account\_id](#input\_accelerator\_account\_id) | The AWS account ID for the Accelerator CI/CD | `string` | n/a | yes |
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | The prefix for the artifacts bucket | `string` | n/a | yes |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | A list of Auto Scaling group names | `list(string)` | n/a | yes |
| <a name="input_codedeploy_role_arns"></a> [codedeploy\_role\_arns](#input\_codedeploy\_role\_arns) | A list of CodeDeploy role ARNs | `list(string)` | n/a | yes |
| <a name="input_codedeploy_role_create"></a> [codedeploy\_role\_create](#input\_codedeploy\_role\_create) | Whether to create a new CodeDeploy IAM role | `bool` | n/a | yes |
| <a name="input_codedeploy_role_names"></a> [codedeploy\_role\_names](#input\_codedeploy\_role\_names) | A list of CodeDeploy role names | `list(string)` | n/a | yes |
| <a name="input_conf_all_at_once"></a> [conf\_all\_at\_once](#input\_conf\_all\_at\_once) | Configuration for deploying all instances at once | `any` | n/a | yes |
| <a name="input_conf_one_at_time"></a> [conf\_one\_at\_time](#input\_conf\_one\_at\_time) | Configuration for deploying one instance at a time | `any` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The desired capacity of the resources | `list(string)` | n/a | yes |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | The name of the ECS cluster | `any` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | A list of ECS service names | `list(string)` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | A list of environment names for the resources | `list(string)` | n/a | yes |
| <a name="input_main_listener"></a> [main\_listener](#input\_main\_listener) | The main listener configuration | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo) | `string` | n/a | yes |
| <a name="input_target_group_blue_name"></a> [target\_group\_blue\_name](#input\_target\_group\_blue\_name) | A list of blue target group names | `list(string)` | n/a | yes |
| <a name="input_target_group_green_name"></a> [target\_group\_green\_name](#input\_target\_group\_green\_name) | A list of green target group names | `list(string)` | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | The target type of the resources | `any` | n/a | yes |
| <a name="input_termination_wait_time_in_minutes"></a> [termination\_wait\_time\_in\_minutes](#input\_termination\_wait\_time\_in\_minutes) | The termination wait time in minutes for instances | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_name"></a> [application\_name](#output\_application\_name) | n/a |
| <a name="output_codedeploy_role_arn"></a> [codedeploy\_role\_arn](#output\_codedeploy\_role\_arn) | n/a |
| <a name="output_codedeploy_role_name"></a> [codedeploy\_role\_name](#output\_codedeploy\_role\_name) | n/a |
| <a name="output_deployment_group_name_ec2"></a> [deployment\_group\_name\_ec2](#output\_deployment\_group\_name\_ec2) | n/a |
| <a name="output_deployment_group_name_ecs"></a> [deployment\_group\_name\_ecs](#output\_deployment\_group\_name\_ecs) | n/a |
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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codedeploy_app.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_codedeploy_deployment_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_iam_policy.codedeploy_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codedeploy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.codedeploy_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codedeploy_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codedeploy_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.codedeploy_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.codedeploy_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerator_account_id"></a> [accelerator\_account\_id](#input\_accelerator\_account\_id) | The AWS account ID for the Accelerator CI/CD | `string` | n/a | yes |
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | The prefix for the artifacts bucket | `string` | n/a | yes |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | A list of Auto Scaling group names | `list(string)` | n/a | yes |
| <a name="input_codedeploy_role_arns"></a> [codedeploy\_role\_arns](#input\_codedeploy\_role\_arns) | A list of CodeDeploy role ARNs | `list(string)` | n/a | yes |
| <a name="input_codedeploy_role_create"></a> [codedeploy\_role\_create](#input\_codedeploy\_role\_create) | Whether to create a new CodeDeploy IAM role | `bool` | n/a | yes |
| <a name="input_conf_all_at_once"></a> [conf\_all\_at\_once](#input\_conf\_all\_at\_once) | Configuration for deploying all instances at once | `string` | n/a | yes |
| <a name="input_conf_one_at_time"></a> [conf\_one\_at\_time](#input\_conf\_one\_at\_time) | Configuration for deploying one instance at a time | `string` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The desired capacity of the resources | `list(string)` | n/a | yes |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | The name of the ECS cluster | `string` | n/a | yes |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | A list of ECS service names | `list(string)` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | A list of environment names for the resources | `list(string)` | n/a | yes |
| <a name="input_main_listener"></a> [main\_listener](#input\_main\_listener) | The main listener configuration | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo) | `string` | n/a | yes |
| <a name="input_target_group_blue_names"></a> [target\_group\_blue\_names](#input\_target\_group\_blue\_names) | A list of blue target group names | `list(string)` | n/a | yes |
| <a name="input_target_group_green_names"></a> [target\_group\_green\_names](#input\_target\_group\_green\_names) | A list of green target group names | `list(string)` | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | The target type of the resources | `string` | n/a | yes |
| <a name="input_termination_wait_time_in_minutes"></a> [termination\_wait\_time\_in\_minutes](#input\_termination\_wait\_time\_in\_minutes) | The termination wait time in minutes for instances | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_name"></a> [application\_name](#output\_application\_name) | The name of the CodeDeploy application |
| <a name="output_codedeploy_role_arn"></a> [codedeploy\_role\_arn](#output\_codedeploy\_role\_arn) | The ARN of the CodeDeploy role |
| <a name="output_codedeploy_role_name"></a> [codedeploy\_role\_name](#output\_codedeploy\_role\_name) | The name of the CodeDeploy role |
| <a name="output_deployment_group_name_ec2"></a> [deployment\_group\_name\_ec2](#output\_deployment\_group\_name\_ec2) | The name of the EC2 deployment group |
| <a name="output_deployment_group_name_ecs"></a> [deployment\_group\_name\_ecs](#output\_deployment\_group\_name\_ecs) | The name of the ECS deployment group |
<!-- END_TF_DOCS -->
