## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm_usa"></a> [acm\_usa](#module\_acm\_usa) | ../../acm_certificate | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.dlt_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_cloudfront_distribution.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_distribution) | data source |
| [aws_route53_zone.poc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | Email of the administrator responsible for managing the DLT framework | `string` | n/a | yes |
| <a name="input_admin_name"></a> [admin\_name](#input\_admin\_name) | Login to access to the DLT WEB UI | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs to be used within the VPC | `list(string)` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet CIDR blocks to be used within the VPC | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name used for resource tagging and naming | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where infrastructure resources will be deployed | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | The name of the region where infrastructure resources will be deployed (used for tagging and naming) | `string` | n/a | yes |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The name of the Route53 zone to be used for DNS records | `string` | n/a | yes |
| <a name="input_storage_bucket_prefix"></a> [storage\_bucket\_prefix](#input\_storage\_bucket\_prefix) | The prefix to be used for naming storage buckets | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block of the VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to be used for the infrastructure | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api"></a> [api](#output\_api) | The API endpoint created by the CloudFormation stack |
| <a name="output_cognito_client_id"></a> [cognito\_client\_id](#output\_cognito\_client\_id) | The Cognito Client ID created by the CloudFormation stack |
| <a name="output_cognito_identity_pool_id"></a> [cognito\_identity\_pool\_id](#output\_cognito\_identity\_pool\_id) | The Cognito Identity Pool ID created by the CloudFormation stack |
| <a name="output_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#output\_cognito\_user\_pool\_id) | The Cognito User Pool ID created by the CloudFormation stack |
| <a name="output_console"></a> [console](#output\_console) | The console created by the CloudFormation stack |
| <a name="output_dlt_fqdn"></a> [dlt\_fqdn](#output\_dlt\_fqdn) | The fully qualified domain name (FQDN) created for DLT WEB UI |
| <a name="output_solution_uuid"></a> [solution\_uuid](#output\_solution\_uuid) | The solution UUID created by the CloudFormation stack |
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
| <a name="provider_aws.global"></a> [aws.global](#provider\_aws.global) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm_usa"></a> [acm\_usa](#module\_acm\_usa) | ../../acm_certificate | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.dlt_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_waf_ipset.waf_ipset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_ipset) | resource |
| [aws_waf_rule.waf_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_rule) | resource |
| [aws_waf_web_acl.waf_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_web_acl) | resource |
| [aws_cloudfront_distribution.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_distribution) | data source |
| [aws_route53_zone.poc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | Email of the administrator responsible for managing the DLT framework | `string` | n/a | yes |
| <a name="input_admin_name"></a> [admin\_name](#input\_admin\_name) | Login to access to the DLT WEB UI | `string` | n/a | yes |
| <a name="input_enable_waf"></a> [enable\_waf](#input\_enable\_waf) | Enable or disable WAF for DLT web interface | `bool` | `false` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs to be used within the VPC | `list(string)` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnet CIDR blocks to be used within the VPC | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name used for resource tagging and naming | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where infrastructure resources will be deployed | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | The name of the region where infrastructure resources will be deployed (used for tagging and naming) | `string` | n/a | yes |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The name of the Route53 zone to be used for DNS records | `string` | n/a | yes |
| <a name="input_storage_bucket_prefix"></a> [storage\_bucket\_prefix](#input\_storage\_bucket\_prefix) | The prefix to be used for naming storage bucket | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block of the VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC to be used for the infrastructure | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api"></a> [api](#output\_api) | The API endpoint created by the CloudFormation stack |
| <a name="output_cognito_client_id"></a> [cognito\_client\_id](#output\_cognito\_client\_id) | The Cognito Client ID created by the CloudFormation stack |
| <a name="output_cognito_identity_pool_id"></a> [cognito\_identity\_pool\_id](#output\_cognito\_identity\_pool\_id) | The Cognito Identity Pool ID created by the CloudFormation stack |
| <a name="output_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#output\_cognito\_user\_pool\_id) | The Cognito User Pool ID created by the CloudFormation stack |
| <a name="output_console"></a> [console](#output\_console) | The console created by the CloudFormation stack |
| <a name="output_dlt_fqdn"></a> [dlt\_fqdn](#output\_dlt\_fqdn) | The fully qualified domain name (FQDN) created for DLT WEB UI |
| <a name="output_solution_uuid"></a> [solution\_uuid](#output\_solution\_uuid) | The solution UUID created by the CloudFormation stack |
<!-- END_TF_DOCS -->
