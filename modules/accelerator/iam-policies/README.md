# iam-policies

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
| [aws_iam_policy.assume_codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.codebuild_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.codebuild_policy_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_artifact_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.assume_codedeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codepipeline_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.dlt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.policy_attach_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_codedeploy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codebuild_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codepipeline_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.codebuild_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.codepipeline_policy_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | Prefix for the S3 bucket where the artifacts are stored | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID where resources will be created | `string` | n/a | yes |
| <a name="input_codedeploy_role_arns"></a> [codedeploy\_role\_arns](#input\_codedeploy\_role\_arns) | List of Role ARNs for AWS CodeDeploy | `list(string)` | n/a | yes |
| <a name="input_eks_role_arn"></a> [eks\_role\_arn](#input\_eks\_role\_arn) | ARN of the IAM role used by EKS | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of VPC Private Subnet IDs | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Identifier for the project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | The name of the AWS region | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository | `string` | n/a | yes |
| <a name="input_service_bucket_arn"></a> [service\_bucket\_arn](#input\_service\_bucket\_arn) | ARN of the S3 bucket where service files are stored | `string` | n/a | yes |
| <a name="input_stages"></a> [stages](#input\_stages) | Map of stage settings. Each stage is a map including account id, regions, and region names | <pre>map(object({<br>    account      = string<br>    regions      = list(string)<br>    region_names = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Type of the deployment target (i.e., instance, lambda, or ecs) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_role_arn"></a> [codebuild\_role\_arn](#output\_codebuild\_role\_arn) | The ARN of the CodeBuild IAM role |
| <a name="output_codepipeline_role_arn"></a> [codepipeline\_role\_arn](#output\_codepipeline\_role\_arn) | The ARN of the CodePipeline IAM role |
| <a name="output_codepipeline_role_name"></a> [codepipeline\_role\_name](#output\_codepipeline\_role\_name) | The name of the CodePipeline IAM role |
<!-- END_TF_DOCS -->
