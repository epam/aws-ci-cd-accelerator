## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm_certificate"></a> [acm\_certificate](#module\_acm\_certificate) | ../../acm_certificate | n/a |
| <a name="module_alb"></a> [alb](#module\_alb) | ../alb_deploy | n/a |
| <a name="module_asg"></a> [asg](#module\_asg) | ../autoscaling_groups | n/a |
| <a name="module_codedeploy"></a> [codedeploy](#module\_codedeploy) | ../codedeploy | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ../ecs | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ../kms | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../core/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerator_account_id"></a> [accelerator\_account\_id](#input\_accelerator\_account\_id) | The AWS account ID for the accelerator account | `string` | `""` | no |
| <a name="input_accelerator_region"></a> [accelerator\_region](#input\_accelerator\_region) | A region where AWS CodePipeline is deployed | `string` | n/a | yes |
| <a name="input_additional_security_groups"></a> [additional\_security\_groups](#input\_additional\_security\_groups) | Additional SG with ports for application needs | `list(string)` | `[]` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of allowed CIDR blocks for access to the application | `list(string)` | `[]` | no |
| <a name="input_allowed_prefix_list_ids"></a> [allowed\_prefix\_list\_ids](#input\_allowed\_prefix\_list\_ids) | List of allowed Prefix List IDs for access to the application | `list(string)` | `[]` | no |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | Port where a loadbalanser redirects traffic | `string` | n/a | yes |
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | n/a | `string` | `"Prefix name for an artifact bucket"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID | `string` | n/a | yes |
| <a name="input_codedeploy_role_arns"></a> [codedeploy\_role\_arns](#input\_codedeploy\_role\_arns) | List of AWS CodeDeploy role ARNs | `list(string)` | n/a | yes |
| <a name="input_codedeploy_role_create"></a> [codedeploy\_role\_create](#input\_codedeploy\_role\_create) | Whether the module should create an AWS CodeDeploy role | `bool` | n/a | yes |
| <a name="input_codedeploy_role_names"></a> [codedeploy\_role\_names](#input\_codedeploy\_role\_names) | List of AWS CodeDeploy role names | `list(string)` | n/a | yes |
| <a name="input_conf_all_at_once"></a> [conf\_all\_at\_once](#input\_conf\_all\_at\_once) | Deployment configuration if desired capacity equal 1 (CodeDeployDefault.AllAtOnce) | `string` | `"CodeDeployDefault.AllAtOnce"` | no |
| <a name="input_conf_one_at_time"></a> [conf\_one\_at\_time](#input\_conf\_one\_at\_time) | Deployment configuration if desired capacity more than 1, you can change the strategy (e.g., CodeDeployDefault.OneAtATime) | `string` | `"CodeDeployDefault.OneAtATime"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The name of the container to be deployed | `string` | `"application"` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU size for a container, minimum value is 218 | `number` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | List of desired capacity values for instances in ASG or containers in ECS | `list(string)` | n/a | yes |
| <a name="input_dns_record_names"></a> [dns\_record\_names](#input\_dns\_record\_names) | List of Route53 Record Names for Stages | `list(string)` | `[]` | no |
| <a name="input_ecr_repo_name"></a> [ecr\_repo\_name](#input\_ecr\_repo\_name) | The name of the ECR repository | `string` | n/a | yes |
| <a name="input_egress_cidr_blocks"></a> [egress\_cidr\_blocks](#input\_egress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all egress rules | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Flag to specify whether to create NAT Gateways for the private networks | `bool` | `true` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | List of environment names | `list(string)` | n/a | yes |
| <a name="input_external_nat_ip_ids"></a> [external\_nat\_ip\_ids](#input\_external\_nat\_ip\_ids) | List of EIP IDs to be assigned to the NAT gateways (used in combination with reuse\_nat\_ips) | `list(string)` | `[]` | no |
| <a name="input_health_path"></a> [health\_path](#input\_health\_path) | The health check path for the load balancer | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the launch template (e.g. t3.micro) | `string` | `"t3.micro"` | no |
| <a name="input_key_service_users"></a> [key\_service\_users](#input\_key\_service\_users) | List of AWS IAM users for KMS key service | `list(string)` | `[]` | no |
| <a name="input_key_users"></a> [key\_users](#input\_key\_users) | List of AWS IAM users for KMS key | `list(string)` | `[]` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | List of maximum capacity values for instances in ASG or containers in ECS | `list(string)` | `[]` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory size for a container, minimum value is 512 | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | List of minimum capacity values for instances in ASG or containers in ECS | `list(string)` | `[]` | no |
| <a name="input_nat_prefix_list_ids"></a> [nat\_prefix\_list\_ids](#input\_nat\_prefix\_list\_ids) | List of Prefix List IDs of EIPs to be attached to the NAT gateways | `list(string)` | `[]` | no |
| <a name="input_nat_security_group_id"></a> [nat\_security\_group\_id](#input\_nat\_security\_group\_id) | The ID of the existing NAT security group. Leave empty if using the VPC resource created by the module | `string` | `""` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs to use for the deployment | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of the project for tags and resource naming | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of public subnet IDs to use for the deployment | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region for the deployment | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | The name of the AWS region for the deployment | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the repository | `string` | n/a | yes |
| <a name="input_reuse_nat_ips"></a> [reuse\_nat\_ips](#input\_reuse\_nat\_ips) | Flag to specify whether to reuse existing EIPs for the NAT gateways (requires external\_nat\_ip\_ids) | `bool` | `false` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The name of the Route53 hosted zone | `string` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Flag to specify whether to create a single shared NAT Gateway for all private networks | `bool` | `false` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | The target type for the load balancer ('instance' or 'ip') | `string` | n/a | yes |
| <a name="input_vpc_create"></a> [vpc\_create](#input\_vpc\_create) | Flag to specify whether the module should create a new VPC. | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the existing VPC. Leave empty if creating a new VPC (vpc\_create = true) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_fqdn"></a> [app\_fqdn](#output\_app\_fqdn) | The fully qualified domain name of the Application Load Balancer. |
| <a name="output_application_name"></a> [application\_name](#output\_application\_name) | The name of the CodeDeploy application. |
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | The Amazon Resource Name (ARN) of the Auto Scaling Group. |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | The name of the Auto Scaling Group. |
| <a name="output_deployment_group_name"></a> [deployment\_group\_name](#output\_deployment\_group\_name) | The name of the deployment group used for deploying the application. |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | The name of the ECS Cluster. |
| <a name="output_ecs_execution_role_arn"></a> [ecs\_execution\_role\_arn](#output\_ecs\_execution\_role\_arn) | The ARN of the ECS Execution Role. |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | The name of the ECS Service. |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | The ARN of the ECS Task Role. |
| <a name="output_http_security_groups"></a> [http\_security\_groups](#output\_http\_security\_groups) | The security groups associated with HTTP traffic for the Application Load Balancer. |
| <a name="output_https_security_groups"></a> [https\_security\_groups](#output\_https\_security\_groups) | The security groups associated with HTTPS traffic for the Application Load Balancer. |
| <a name="output_lt_id"></a> [lt\_id](#output\_lt\_id) | The ID of the Launch Template associated with the Auto Scaling Group. |
| <a name="output_main_listener"></a> [main\_listener](#output\_main\_listener) | The main listener for the Application Load Balancer. |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | The public IPs of the NAT gateways in the VPC. |
| <a name="output_target_group_blue_name"></a> [target\_group\_blue\_name](#output\_target\_group\_blue\_name) | The name of the blue target group for the blue-green deployment. |
| <a name="output_target_group_green_name"></a> [target\_group\_green\_name](#output\_target\_group\_green\_name) | The name of the green target group for the blue-green deployment. |
| <a name="output_target_group_name"></a> [target\_group\_name](#output\_target\_group\_name) | The name of the default target group for the Application Load Balancer. |
| <a name="output_template_name"></a> [template\_name](#output\_template\_name) | The name of the Launch Template used by the Auto Scaling Group. |
| <a name="output_vpc_nat_security_group"></a> [vpc\_nat\_security\_group](#output\_vpc\_nat\_security\_group) | The security group associated with the NAT gateways in the VPC. |
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
| <a name="module_acm_certificate"></a> [acm\_certificate](#module\_acm\_certificate) | ../../acm_certificate | n/a |
| <a name="module_alb"></a> [alb](#module\_alb) | ../alb_deploy | n/a |
| <a name="module_asg"></a> [asg](#module\_asg) | ../autoscaling_groups | n/a |
| <a name="module_codedeploy"></a> [codedeploy](#module\_codedeploy) | ../codedeploy | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ../ecs | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | ../kms | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../core/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accelerator_account_id"></a> [accelerator\_account\_id](#input\_accelerator\_account\_id) | The AWS account ID for the accelerator account | `string` | n/a | yes |
| <a name="input_accelerator_region"></a> [accelerator\_region](#input\_accelerator\_region) | A region where AWS CodePipeline is deployed | `string` | n/a | yes |
| <a name="input_additional_security_groups"></a> [additional\_security\_groups](#input\_additional\_security\_groups) | Additional SG with ports for application needs | `list(string)` | `[]` | no |
| <a name="input_alb_access_logs"></a> [alb\_access\_logs](#input\_alb\_access\_logs) | Enabled ALB Access Logs | `bool` | `false` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of allowed CIDR blocks for access to the application | `list(string)` | `[]` | no |
| <a name="input_allowed_prefix_list_ids"></a> [allowed\_prefix\_list\_ids](#input\_allowed\_prefix\_list\_ids) | List of allowed Prefix List IDs for access to the application | `list(string)` | `[]` | no |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | Port where a loadbalanser redirects traffic | `string` | n/a | yes |
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | Prefix name for an artifact bucket | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID | `string` | n/a | yes |
| <a name="input_codedeploy_role_arns"></a> [codedeploy\_role\_arns](#input\_codedeploy\_role\_arns) | List of AWS CodeDeploy role ARNs | `list(string)` | n/a | yes |
| <a name="input_codedeploy_role_create"></a> [codedeploy\_role\_create](#input\_codedeploy\_role\_create) | Whether the module should create an AWS CodeDeploy role | `bool` | n/a | yes |
| <a name="input_conf_all_at_once"></a> [conf\_all\_at\_once](#input\_conf\_all\_at\_once) | Deployment configuration if desired capacity equal 1 (CodeDeployDefault.AllAtOnce) | `string` | `"CodeDeployDefault.AllAtOnce"` | no |
| <a name="input_conf_one_at_time"></a> [conf\_one\_at\_time](#input\_conf\_one\_at\_time) | Deployment configuration if desired capacity more than 1, you can change the strategy (e.g., CodeDeployDefault.OneAtATime) | `string` | `"CodeDeployDefault.OneAtATime"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The name of the container to be deployed | `string` | `"application"` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU size for a container, minimum value is 218 | `number` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | List of desired capacity values for instances in ASG or containers in ECS | `list(string)` | n/a | yes |
| <a name="input_dns_record_names"></a> [dns\_record\_names](#input\_dns\_record\_names) | List of Route53 Record Names for Stages | `list(string)` | `[]` | no |
| <a name="input_ecr_repo_name"></a> [ecr\_repo\_name](#input\_ecr\_repo\_name) | The name of the ECR repository | `string` | n/a | yes |
| <a name="input_egress_cidr_blocks"></a> [egress\_cidr\_blocks](#input\_egress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all egress rules | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Flag to specify whether to create NAT Gateways for the private networks | `bool` | `true` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | List of environment names | `list(string)` | n/a | yes |
| <a name="input_external_nat_ip_ids"></a> [external\_nat\_ip\_ids](#input\_external\_nat\_ip\_ids) | List of EIP IDs to be assigned to the NAT gateways (used in combination with reuse\_nat\_ips) | `list(string)` | `[]` | no |
| <a name="input_health_path"></a> [health\_path](#input\_health\_path) | The health check path for the load balancer | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the launch template (e.g. t3.micro) | `string` | `"t3.micro"` | no |
| <a name="input_key_service_users"></a> [key\_service\_users](#input\_key\_service\_users) | List of AWS IAM users for KMS key service | `list(string)` | `[]` | no |
| <a name="input_key_users"></a> [key\_users](#input\_key\_users) | List of AWS IAM users for KMS key | `list(string)` | `[]` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | List of maximum capacity values for instances in ASG or containers in ECS | `list(string)` | `[]` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory size for a container, minimum value is 512 | `number` | n/a | yes |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | List of minimum capacity values for instances in ASG or containers in ECS | `list(string)` | `[]` | no |
| <a name="input_nat_prefix_list_ids"></a> [nat\_prefix\_list\_ids](#input\_nat\_prefix\_list\_ids) | List of Prefix List IDs of EIPs to be attached to the NAT gateways | `list(string)` | `[]` | no |
| <a name="input_nat_security_group_id"></a> [nat\_security\_group\_id](#input\_nat\_security\_group\_id) | The ID of the existing VPC NAT security group. Leave empty if using the VPC resource created by the module | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs to use for the deployment | `list(string)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of the project for tags and resource naming | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of public subnet IDs to use for the deployment | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region for the deployment | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the repository | `string` | n/a | yes |
| <a name="input_reuse_nat_ips"></a> [reuse\_nat\_ips](#input\_reuse\_nat\_ips) | Flag to specify whether to reuse existing EIPs for the NAT gateways (requires external\_nat\_ip\_ids) | `bool` | `false` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The name of the Route53 hosted zone | `string` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Flag to specify whether to create a single shared NAT Gateway for all private networks | `bool` | `false` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | The target type for the load balancer ('instance' or 'ip') | `string` | n/a | yes |
| <a name="input_vpc_create"></a> [vpc\_create](#input\_vpc\_create) | Flag to specify whether the module should create a new VPC. | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the existing VPC. Leave empty if creating a new VPC (vpc\_create = true) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_fqdn"></a> [app\_fqdn](#output\_app\_fqdn) | The fully qualified domain name of the Application Load Balancer |
| <a name="output_application_name"></a> [application\_name](#output\_application\_name) | The name of the CodeDeploy application |
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | The Amazon Resource Name (ARN) of the Auto Scaling Group |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | The name of the Auto Scaling Group |
| <a name="output_deployment_group_name"></a> [deployment\_group\_name](#output\_deployment\_group\_name) | The name of the deployment group used for deploying the application |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | The name of the ECS Cluster |
| <a name="output_ecs_execution_role_arn"></a> [ecs\_execution\_role\_arn](#output\_ecs\_execution\_role\_arn) | The ARN of the ECS Execution Role |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | The name of the ECS Service |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | The ARN of the ECS Task Role |
| <a name="output_http_security_groups"></a> [http\_security\_groups](#output\_http\_security\_groups) | The security groups associated with HTTP traffic for the Application Load Balancer |
| <a name="output_https_security_groups"></a> [https\_security\_groups](#output\_https\_security\_groups) | The security groups associated with HTTPS traffic for the Application Load Balancer |
| <a name="output_lt_id"></a> [lt\_id](#output\_lt\_id) | The ID of the Launch Template associated with the Auto Scaling Group |
| <a name="output_main_listener"></a> [main\_listener](#output\_main\_listener) | The main listener for the Application Load Balancer |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | The public IPs of the NAT gateways in the VPC |
| <a name="output_target_group_blue_name"></a> [target\_group\_blue\_name](#output\_target\_group\_blue\_name) | The name of the blue target group for the blue-green deployment |
| <a name="output_target_group_green_name"></a> [target\_group\_green\_name](#output\_target\_group\_green\_name) | The name of the green target group for the blue-green deployment |
| <a name="output_target_group_name"></a> [target\_group\_name](#output\_target\_group\_name) | The name of the default target group for the Application Load Balancer |
| <a name="output_template_name"></a> [template\_name](#output\_template\_name) | The name of the Launch Template used by the Auto Scaling Group |
| <a name="output_vpc_nat_security_group"></a> [vpc\_nat\_security\_group](#output\_vpc\_nat\_security\_group) | The security group associated with the NAT gateways in the VPC |
<!-- END_TF_DOCS -->
