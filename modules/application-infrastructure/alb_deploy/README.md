## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_group_http"></a> [security\_group\_http](#module\_security\_group\_http) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_security_group_https"></a> [security\_group\_https](#module\_security\_group\_https) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_security_group_self_port"></a> [security\_group\_self\_port](#module\_security\_group\_self\_port) | terraform-aws-modules/security-group/aws | 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_lb.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.ec2_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.ecs_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.blue_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.green_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.main_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.region_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.poc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | Allowed CIDR blocks for access to the application | `list(string)` | n/a | yes |
| <a name="input_allowed_prefix_list_ids"></a> [allowed\_prefix\_list\_ids](#input\_allowed\_prefix\_list\_ids) | Allowed prefix list IDs for access to the application | `list(string)` | n/a | yes |
| <a name="input_aws_acm_certificate_arn"></a> [aws\_acm\_certificate\_arn](#input\_aws\_acm\_certificate\_arn) | The Amazon Resource Name (ARN) of the AWS Certificate Manager certificate | `string` | n/a | yes |
| <a name="input_dns_record_names"></a> [dns\_record\_names](#input\_dns\_record\_names) | Route53 Record Name for Stages | `list(string)` | n/a | yes |
| <a name="input_egress_cidr_blocks"></a> [egress\_cidr\_blocks](#input\_egress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all egress rules | `list(string)` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | A list of environment names for the resources | `list(string)` | n/a | yes |
| <a name="input_health_path"></a> [health\_path](#input\_health\_path) | The health check PATH for the application | `string` | n/a | yes |
| <a name="input_nat_security_group_id"></a> [nat\_security\_group\_id](#input\_nat\_security\_group\_id) | The security group ID of the NAT gateway | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | A list of public subnet IDs in the VPC | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository | `string` | n/a | yes |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The Route53 zone name | `string` | n/a | yes |
| <a name="input_target_port"></a> [target\_port](#input\_target\_port) | The target port for the resources | `string` | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | The target type of the resources | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to deploy resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_id"></a> [alb\_id](#output\_alb\_id) | n/a |
| <a name="output_alb_name"></a> [alb\_name](#output\_alb\_name) | n/a |
| <a name="output_app_fqdn"></a> [app\_fqdn](#output\_app\_fqdn) | n/a |
| <a name="output_main_listener"></a> [main\_listener](#output\_main\_listener) | n/a |
| <a name="output_security_group_http"></a> [security\_group\_http](#output\_security\_group\_http) | n/a |
| <a name="output_security_group_https"></a> [security\_group\_https](#output\_security\_group\_https) | n/a |
| <a name="output_security_group_self_port"></a> [security\_group\_self\_port](#output\_security\_group\_self\_port) | n/a |
| <a name="output_target_group_arn"></a> [target\_group\_arn](#output\_target\_group\_arn) | n/a |
| <a name="output_target_group_blue_arn"></a> [target\_group\_blue\_arn](#output\_target\_group\_blue\_arn) | n/a |
| <a name="output_target_group_blue_name"></a> [target\_group\_blue\_name](#output\_target\_group\_blue\_name) | #================== ECS =================================== |
| <a name="output_target_group_green_arn"></a> [target\_group\_green\_arn](#output\_target\_group\_green\_arn) | n/a |
| <a name="output_target_group_green_name"></a> [target\_group\_green\_name](#output\_target\_group\_green\_name) | n/a |
| <a name="output_target_group_name"></a> [target\_group\_name](#output\_target\_group\_name) | #=========================== EC2 ======================== |
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
| <a name="module_log_bucket"></a> [log\_bucket](#module\_log\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.0 |
| <a name="module_security_group_http"></a> [security\_group\_http](#module\_security\_group\_http) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_security_group_https"></a> [security\_group\_https](#module\_security\_group\_https) | terraform-aws-modules/security-group/aws | 5.1.0 |
| <a name="module_security_group_self_port"></a> [security\_group\_self\_port](#module\_security\_group\_self\_port) | terraform-aws-modules/security-group/aws | 5.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_lb.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.ec2_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.ecs_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.blue_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.green_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.main_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.region_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.poc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_access_logs"></a> [alb\_access\_logs](#input\_alb\_access\_logs) | Enabled ALB Access Logs | `bool` | n/a | yes |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | Allowed CIDR blocks for access to the application | `list(string)` | n/a | yes |
| <a name="input_allowed_prefix_list_ids"></a> [allowed\_prefix\_list\_ids](#input\_allowed\_prefix\_list\_ids) | Allowed prefix list IDs for access to the application | `list(string)` | n/a | yes |
| <a name="input_aws_acm_certificate_arn"></a> [aws\_acm\_certificate\_arn](#input\_aws\_acm\_certificate\_arn) | The Amazon Resource Name (ARN) of the AWS Certificate Manager certificate | `string` | n/a | yes |
| <a name="input_dns_record_names"></a> [dns\_record\_names](#input\_dns\_record\_names) | Route53 Record Name for Stages | `list(string)` | n/a | yes |
| <a name="input_egress_cidr_blocks"></a> [egress\_cidr\_blocks](#input\_egress\_cidr\_blocks) | List of IPv4 CIDR ranges to use on all egress rules | `list(string)` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | A list of environment names for the resources | `list(string)` | n/a | yes |
| <a name="input_health_path"></a> [health\_path](#input\_health\_path) | The health check PATH for the application | `string` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS Key to encrypt logs | `string` | n/a | yes |
| <a name="input_nat_security_group_id"></a> [nat\_security\_group\_id](#input\_nat\_security\_group\_id) | The security group ID of the NAT gateway | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | n/a | yes |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | A list of public subnet IDs in the VPC | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository | `string` | n/a | yes |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The Route53 zone name | `string` | n/a | yes |
| <a name="input_target_port"></a> [target\_port](#input\_target\_port) | The target port for the resources | `string` | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | The target type of the resources | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to deploy resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_id"></a> [alb\_id](#output\_alb\_id) | The id of the application load balancer |
| <a name="output_alb_name"></a> [alb\_name](#output\_alb\_name) | The name of the application load balancer |
| <a name="output_app_fqdn"></a> [app\_fqdn](#output\_app\_fqdn) | The fully qualified domain name of the app |
| <a name="output_main_listener"></a> [main\_listener](#output\_main\_listener) | The ARN of the main listener |
| <a name="output_security_group_http"></a> [security\_group\_http](#output\_security\_group\_http) | The security group id for HTTP |
| <a name="output_security_group_https"></a> [security\_group\_https](#output\_security\_group\_https) | The security group id for HTTPS |
| <a name="output_security_group_self_port"></a> [security\_group\_self\_port](#output\_security\_group\_self\_port) | The security group id for self port |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | The ARNs of the target groups for instances |
| <a name="output_target_group_blue_arns"></a> [target\_group\_blue\_arns](#output\_target\_group\_blue\_arns) | The ARNs of the target blue groups for IPs |
| <a name="output_target_group_blue_names"></a> [target\_group\_blue\_names](#output\_target\_group\_blue\_names) | The names of the target blue groups for IPs |
| <a name="output_target_group_green_arns"></a> [target\_group\_green\_arns](#output\_target\_group\_green\_arns) | The ARNs of the target green groups for IPs |
| <a name="output_target_group_green_names"></a> [target\_group\_green\_names](#output\_target\_group\_green\_names) | The names of the target green groups for IPs |
| <a name="output_target_group_names"></a> [target\_group\_names](#output\_target\_group\_names) | The names of the target groups for instances |
<!-- END_TF_DOCS -->
