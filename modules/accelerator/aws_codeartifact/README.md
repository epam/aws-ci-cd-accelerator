# aws_codeartifact

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
| [aws_codeartifact_domain.project_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain) | resource |
| [aws_codeartifact_domain_permissions_policy.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain_permissions_policy) | resource |
| [aws_codeartifact_repository.maven](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository) | resource |
| [aws_codeartifact_repository_permissions_policy.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository_permissions_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_codebuild_role_arn"></a> [codebuild\_role\_arn](#input\_codebuild\_role\_arn) | The Amazon Resource Name (ARN) of the IAM role for CodeBuild to assume | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codeartifact_domain"></a> [codeartifact\_domain](#output\_codeartifact\_domain) | The domain of the CodeArtifact |
| <a name="output_codeartifact_repo"></a> [codeartifact\_repo](#output\_codeartifact\_repo) | The repository of the CodeArtifact |
<!-- END_TF_DOCS -->
