# bitbucket

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_bitbucket"></a> [bitbucket](#requirement\_bitbucket) | 2.38.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_bitbucket"></a> [bitbucket](#provider\_bitbucket) | 2.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [bitbucket_hook.ai_handler](https://registry.terraform.io/providers/DrFaust92/bitbucket/2.38.0/docs/resources/hook) | resource |
| [bitbucket_hook.this](https://registry.terraform.io/providers/DrFaust92/bitbucket/2.38.0/docs/resources/hook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_handler_create"></a> [ai\_handler\_create](#input\_ai\_handler\_create) | To chose if deploy AI Handler module | `bool` | n/a | yes |
| <a name="input_atlantis_url_events"></a> [atlantis\_url\_events](#input\_atlantis\_url\_events) | The URL for handling Atlantis events | `string` | n/a | yes |
| <a name="input_function_url"></a> [function\_url](#input\_function\_url) | Lambda function to be triggered if PR Comment is updated | `list(string)` | n/a | yes |
| <a name="input_git_owner"></a> [git\_owner](#input\_git\_owner) | Repository Owner, Workspace ID | `string` | n/a | yes |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | The Bitbucket token for the user running the Atlantis command | `string` | n/a | yes |
| <a name="input_git_user"></a> [git\_user](#input\_git\_user) | The Bitbucket username associated with the Atlantis command | `string` | n/a | yes |
| <a name="input_repo_names"></a> [repo\_names](#input\_repo\_names) | Names of the infrastructure repository | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
