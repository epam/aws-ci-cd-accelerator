# github

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_repository_webhook.ai_handler](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |
| [github_repository_webhook.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_handler_create"></a> [ai\_handler\_create](#input\_ai\_handler\_create) | To chose if deploy AI Handler module | `bool` | n/a | yes |
| <a name="input_atlantis_url_events"></a> [atlantis\_url\_events](#input\_atlantis\_url\_events) | The URL for handling Atlantis events on GitHub | `string` | n/a | yes |
| <a name="input_atlantis_webhook_secret"></a> [atlantis\_webhook\_secret](#input\_atlantis\_webhook\_secret) | The secret used for securing Atlantis webhook communication on GitHub | `string` | n/a | yes |
| <a name="input_function_url"></a> [function\_url](#input\_function\_url) | Lambda function to be triggered if PR Comment is updated | `list(string)` | n/a | yes |
| <a name="input_git_owner"></a> [git\_owner](#input\_git\_owner) | GitHub owner name to use when creating a webhook | `string` | n/a | yes |
| <a name="input_git_token"></a> [git\_token](#input\_git\_token) | GitHub token to use when creating a webhook | `string` | n/a | yes |
| <a name="input_repo_names"></a> [repo\_names](#input\_repo\_names) | The name of the infrastructure repositories on GitHub | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
