# gitlab

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | 3.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | 3.20.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [gitlab_project_hook.ai_handler](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_hook) | resource |
| [gitlab_project_hook.this](https://registry.terraform.io/providers/gitlabhq/gitlab/3.20.0/docs/resources/project_hook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_handler_create"></a> [ai\_handler\_create](#input\_ai\_handler\_create) | To chose if deploy AI Handler module | `bool` | n/a | yes |
| <a name="input_atlantis_url_events"></a> [atlantis\_url\_events](#input\_atlantis\_url\_events) | The URL for handling Atlantis events on Git platforms | `string` | n/a | yes |
| <a name="input_atlantis_webhook_secret"></a> [atlantis\_webhook\_secret](#input\_atlantis\_webhook\_secret) | The secret used for securing Atlantis webhook communication on Git platforms | `string` | n/a | yes |
| <a name="input_function_url"></a> [function\_url](#input\_function\_url) | Lambda function to be triggered if PR Comment is updated | `list(string)` | n/a | yes |
| <a name="input_git_hostname"></a> [git\_hostname](#input\_git\_hostname) | The GitLab hostname | `string` | n/a | yes |
| <a name="input_git_owner"></a> [git\_owner](#input\_git\_owner) | GitLab Namespace | `string` | n/a | yes |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | The GitLab user token for Atlantis integration | `string` | n/a | yes |
| <a name="input_repo_names"></a> [repo\_names](#input\_repo\_names) | The GitLab projects names | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
