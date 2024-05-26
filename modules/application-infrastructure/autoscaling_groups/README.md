## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.asg_attachment_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.profile_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ec2_profile_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_ami.latest_ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.ec2_profile_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | The prefix for the artifacts bucket | `string` | n/a | yes |
| <a name="input_asg_security_groups"></a> [asg\_security\_groups](#input\_asg\_security\_groups) | A list of security group IDs for the Auto Scaling group | `list(string)` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | A list of desired capacity for the Auto Scaling group or ECS containers | `list(string)` | n/a | yes |
| <a name="input_elb_target_group_arn"></a> [elb\_target\_group\_arn](#input\_elb\_target\_group\_arn) | The Amazon Resource Name (ARN) of the Elastic Load Balancer target group | `any` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | A list of environment names for the resources | `list(string)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The EC2 instance type for the Auto Scaling group | `string` | n/a | yes |
| <a name="input_lb_id"></a> [lb\_id](#input\_lb\_id) | The load balancer ID | `any` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum size of the Auto Scaling group or ECS containers | `list(string)` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum size of the Auto Scaling group or ECS containers | `list(string)` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | A list of private subnet IDs in the VPC | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | n/a |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | n/a |
| <a name="output_launch_template_id"></a> [launch\_template\_id](#output\_launch\_template\_id) | n/a |
| <a name="output_template_name"></a> [template\_name](#output\_template\_name) | n/a |
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
| [aws_autoscaling_attachment.asg_attachment_app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.profile_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ec2_profile_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_ami.latest_ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ec2_profile_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | The prefix for the artifacts bucket | `string` | n/a | yes |
| <a name="input_asg_security_groups"></a> [asg\_security\_groups](#input\_asg\_security\_groups) | A list of security group IDs for the Auto Scaling group | `list(string)` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | A list of desired capacity for the Auto Scaling group or ECS containers | `list(string)` | n/a | yes |
| <a name="input_elb_target_group_arns"></a> [elb\_target\_group\_arns](#input\_elb\_target\_group\_arns) | The Amazon Resource Name (ARN) of the Elastic Load Balancer target group | `list(string)` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | A list of environment names for the resources | `list(string)` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The EC2 instance type for the Auto Scaling group | `string` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum size of the Auto Scaling group or ECS containers | `list(string)` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum size of the Auto Scaling group or ECS containers | `list(string)` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | A list of private subnet IDs in the VPC | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | The ARN of the Autoscaling Group (ASG) |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | The name of the Autoscaling Group (ASG) |
| <a name="output_launch_template_id"></a> [launch\_template\_id](#output\_launch\_template\_id) | The ID of the launch template |
| <a name="output_template_name"></a> [template\_name](#output\_template\_name) | The name of the launch template |
<!-- END_TF_DOCS -->
