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
| <a name="module_aws_codeartifact"></a> [aws\_codeartifact](#module\_aws\_codeartifact) | ../aws_codeartifact | n/a |
| <a name="module_aws_policies"></a> [aws\_policies](#module\_aws\_policies) | ../iam-policies | n/a |
| <a name="module_buckets"></a> [buckets](#module\_buckets) | ../accelerator_storages | n/a |
| <a name="module_pipeline"></a> [pipeline](#module\_pipeline) | ../aws-codepipeline | n/a |
| <a name="module_pr"></a> [pr](#module\_pr) | ../PR-analysis | n/a |
| <a name="module_pr_codecommit"></a> [pr\_codecommit](#module\_pr\_codecommit) | ../PR-analysis-CodeCommit | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | ../notifications | n/a |
| <a name="module_synthetics"></a> [synthetics](#module\_synthetics) | ../synthetics | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_identifiers"></a> [account\_identifiers](#input\_account\_identifiers) | Identifiers for the AWS account | `list(string)` | n/a | yes |
| <a name="input_admin_name"></a> [admin\_name](#input\_admin\_name) | User Name for access to DLT WEB UI | `string` | `"user"` | no |
| <a name="input_app_fqdn"></a> [app\_fqdn](#input\_app\_fqdn) | List of Fully Qualified Domain Names (FQDN) for the application | `list(string)` | `[]` | no |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | AWS CodeDeploy Application Name | `string` | `""` | no |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | Port where a load balancer redirects traffic | `string` | `"8080"` | no |
| <a name="input_artifact_bucket_identifiers"></a> [artifact\_bucket\_identifiers](#input\_artifact\_bucket\_identifiers) | Identifiers for the artifact bucket | `list(string)` | n/a | yes |
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | Prefix for the artifact bucket | `string` | `"artifact-bucket-for"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID | `string` | n/a | yes |
| <a name="input_bitbucket_user"></a> [bitbucket\_user](#input\_bitbucket\_user) | Username for Bitbucket integration | `string` | `""` | no |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | The build instance type for CodeBuild (default: BUILD\_GENERAL1\_SMALL) | `string` | `"BUILD_GENERAL1_MEDIUM"` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | The build image for CodeBuild to use (default: aws/codebuild/standard:6.0) | `string` | `"aws/codebuild/standard:6.0"` | no |
| <a name="input_build_success"></a> [build\_success](#input\_build\_success) | If true, you will also get notifications about successful builds | `bool` | `false` | no |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | The time to wait for a CodeBuild to complete before timing out in minutes (default: 5) | `string` | `"30"` | no |
| <a name="input_buildspec_carrier"></a> [buildspec\_carrier](#input\_buildspec\_carrier) | The name of buildspec file if we use Carrier | `string` | `"buildspec_carrier.yml"` | no |
| <a name="input_buildspec_dlt"></a> [buildspec\_dlt](#input\_buildspec\_dlt) | The buildspec to be used for the Performance Test stage | `string` | `"buildspec_dlt.yml"` | no |
| <a name="input_buildspec_docker"></a> [buildspec\_docker](#input\_buildspec\_docker) | The buildspec file to be used for the Package stage on ECS | `string` | `"buildspec_docker.yml"` | no |
| <a name="input_buildspec_eks"></a> [buildspec\_eks](#input\_buildspec\_eks) | Buildspec file to be used for EKS deployment | `string` | `"buildspec_eks.yml"` | no |
| <a name="input_buildspec_package"></a> [buildspec\_package](#input\_buildspec\_package) | The buildspec file to be used for the Package stage on EC2 | `string` | `"buildspec.yml"` | no |
| <a name="input_buildspec_selenium"></a> [buildspec\_selenium](#input\_buildspec\_selenium) | The buildspec file to be used for the Func Test stage. | `string` | `"buildspec_selenium.yml"` | no |
| <a name="input_buildspec_sonar"></a> [buildspec\_sonar](#input\_buildspec\_sonar) | The buildspec file to be used for the Test stage. | `string` | `"buildspec_sonar.yml"` | no |
| <a name="input_buildspec_unit"></a> [buildspec\_unit](#input\_buildspec\_unit) | The buildspec file to be used for Unit Tests stage | `string` | `"buildspec_unit_tests.yml"` | no |
| <a name="input_carrier_create"></a> [carrier\_create](#input\_carrier\_create) | Flag to specify whether to create Carrier resources | `bool` | `false` | no |
| <a name="input_carrier_project_id"></a> [carrier\_project\_id](#input\_carrier\_project\_id) | The Carrier project ID | `string` | `""` | no |
| <a name="input_carrier_test_id"></a> [carrier\_test\_id](#input\_carrier\_test\_id) | The Carrier test ID | `string` | `""` | no |
| <a name="input_carrier_token_name"></a> [carrier\_token\_name](#input\_carrier\_token\_name) | Name of the Parameter Store variable for Carrier token | `string` | `"/carrier/token"` | no |
| <a name="input_carrier_url"></a> [carrier\_url](#input\_carrier\_url) | URL for Carrier integration | `string` | `""` | no |
| <a name="input_cluster_config"></a> [cluster\_config](#input\_cluster\_config) | Name of AWS Parameter Store Variable, where K8s Cluster config stored in base64 | `string` | `""` | no |
| <a name="input_cluster_region"></a> [cluster\_region](#input\_cluster\_region) | Region for the EKS cluster | `string` | `""` | no |
| <a name="input_codeartifact_create"></a> [codeartifact\_create](#input\_codeartifact\_create) | Create AWS Codeartifact for JAVA Application | `bool` | `false` | no |
| <a name="input_codedeploy_role_arns"></a> [codedeploy\_role\_arns](#input\_codedeploy\_role\_arns) | List of AWS CodeDeploy role ARNs | `list(string)` | `[]` | no |
| <a name="input_cognito_client_id"></a> [cognito\_client\_id](#input\_cognito\_client\_id) | Cognito Client ID for the DLT test | `string` | `""` | no |
| <a name="input_cognito_identity_pool_id"></a> [cognito\_identity\_pool\_id](#input\_cognito\_identity\_pool\_id) | Cognito Identity Pool ID for the DLT test | `string` | `""` | no |
| <a name="input_cognito_password_name"></a> [cognito\_password\_name](#input\_cognito\_password\_name) | Parameter Store variable name for Cognito User for DLT | `string` | `"/cognito/password"` | no |
| <a name="input_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#input\_cognito\_user\_pool\_id) | Cognito User Pool ID for the DLT test | `string` | `""` | no |
| <a name="input_concurrency"></a> [concurrency](#input\_concurrency) | The number of concurrent virtual users generated per task. The recommended limit based on default settings is 200 virtual users. | `number` | `1` | no |
| <a name="input_connection_provider"></a> [connection\_provider](#input\_connection\_provider) | Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer; leave blank for others | `string` | `"GitHub"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Container name for the application | `string` | `"application"` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU Size for container, min=256 | `number` | n/a | yes |
| <a name="input_deployment_group_names"></a> [deployment\_group\_names](#input\_deployment\_group\_names) | AWS CodeDeploy Deployment Group | `list(string)` | `[]` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for AWS CodePipeline notifications | `string` | `"AWS CodePipeline Notification"` | no |
| <a name="input_dlt_api_host"></a> [dlt\_api\_host](#input\_dlt\_api\_host) | API host for the DLT test | `string` | `""` | no |
| <a name="input_dlt_create"></a> [dlt\_create](#input\_dlt\_create) | Flag to specify whether to create DLT test resources | `bool` | `true` | no |
| <a name="input_dlt_fqdn"></a> [dlt\_fqdn](#input\_dlt\_fqdn) | Fully Qualified Domain Name (FQDN) for the DLT test | `string` | `""` | no |
| <a name="input_dlt_task_count"></a> [dlt\_task\_count](#input\_dlt\_task\_count) | Number of containers that will be launched in the Fargate cluster to run the test scenario. Additional tasks will not be created once the account limit on Fargate resources has been reached, however tasks already running will continue. | `number` | `1` | no |
| <a name="input_dlt_test_id"></a> [dlt\_test\_id](#input\_dlt\_test\_id) | The ID of your load test. | `string` | `""` | no |
| <a name="input_dlt_test_name"></a> [dlt\_test\_name](#input\_dlt\_test\_name) | The name of your load test. | `string` | `""` | no |
| <a name="input_dlt_test_type"></a> [dlt\_test\_type](#input\_dlt\_test\_type) | Can be `simple` or `jmeter`. | `string` | `"simple"` | no |
| <a name="input_dlt_ui_url"></a> [dlt\_ui\_url](#input\_dlt\_ui\_url) | URL for the DLT WEB UI | `string` | `""` | no |
| <a name="input_docker_password"></a> [docker\_password](#input\_docker\_password) | AWS Parameter Store variable Name to get password for Docker Registry | `string` | `""` | no |
| <a name="input_docker_repo"></a> [docker\_repo](#input\_docker\_repo) | Name for Docker Registry REPO/NAME | `string` | `""` | no |
| <a name="input_docker_user"></a> [docker\_user](#input\_docker\_user) | AWS Parameter Store variable of User to get Image from Docker Registry | `string` | `""` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_role_arn"></a> [eks\_role\_arn](#input\_eks\_role\_arn) | ARN of the role used for EKS resources | `string` | `""` | no |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | List of email addresses to receive AWS CodePipeline notifications | `list(string)` | `[]` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Map containing environment variables per environment | `map(list(map(string)))` | <pre>{<br>  "dev": [],<br>  "qa": [],<br>  "uat": []<br>}</pre> | no |
| <a name="input_environments"></a> [environments](#input\_environments) | List of environment names | `list(string)` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Delete bucket when destroy: true or false | `bool` | n/a | yes |
| <a name="input_github_token_name"></a> [github\_token\_name](#input\_github\_token\_name) | Parameter Store Variable Name for GitHub | `string` | n/a | yes |
| <a name="input_helm_chart"></a> [helm\_chart](#input\_helm\_chart) | Helm Chart URL with release | `string` | `""` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Version of the Helm chart to use | `string` | `""` | no |
| <a name="input_hold_for"></a> [hold\_for](#input\_hold\_for) | Time to hold target concurrency. | `string` | `"1m"` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Mutability of docker image tag of application | `string` | `"IMMUTABLE"` | no |
| <a name="input_key_service_users"></a> [key\_service\_users](#input\_key\_service\_users) | A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration) | `list(string)` | `[]` | no |
| <a name="input_kms_identifiers"></a> [kms\_identifiers](#input\_kms\_identifiers) | Identifiers for KMS policy. | `list(string)` | `[]` | no |
| <a name="input_llm_model"></a> [llm\_model](#input\_llm\_model) | LLM Model for AI | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory size for container, min=512 | `number` | n/a | yes |
| <a name="input_openai_api_endpoint"></a> [openai\_api\_endpoint](#input\_openai\_api\_endpoint) | Open AI Endpoint | `string` | n/a | yes |
| <a name="input_openai_token_name"></a> [openai\_token\_name](#input\_openai\_token\_name) | Parameter Store Variable Name for OPEN AI API KEY | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | Name of a Sonar Organization | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs to use for the deployment | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of the project for tags and resource naming | `string` | n/a | yes |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | Project key for SonarQube | `string` | n/a | yes |
| <a name="input_ramp_up"></a> [ramp\_up](#input\_ramp\_up) | The time to reach target concurrency. | `string` | `"1m"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy into | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | Name of region\_name to deploy application, use for resources naming | `string` | n/a | yes |
| <a name="input_repo_default_branch"></a> [repo\_default\_branch](#input\_repo\_default\_branch) | Default branch name for the repository | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of an application repository | `string` | n/a | yes |
| <a name="input_report_portal_environments"></a> [report\_portal\_environments](#input\_report\_portal\_environments) | List of Report Portal environments to deploy | `list(map(string))` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map containing secret variables per environment | `map(list(map(string)))` | <pre>{<br>  "dev": [],<br>  "qa": [],<br>  "uat": []<br>}</pre> | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security group IDs to associate with resources for testing | `list(string)` | `[]` | no |
| <a name="input_selenium_create"></a> [selenium\_create](#input\_selenium\_create) | Flag to specify whether to create Selenium resources | `bool` | `false` | no |
| <a name="input_service_bucket_prefix"></a> [service\_bucket\_prefix](#input\_service\_bucket\_prefix) | Prefix for the storage bucket | `string` | `"service-bucket-for"` | no |
| <a name="input_sonar_url"></a> [sonar\_url](#input\_sonar\_url) | URL for SonarQube or SonarCloud instance | `string` | n/a | yes |
| <a name="input_sonarcloud_token_name"></a> [sonarcloud\_token\_name](#input\_sonarcloud\_token\_name) | Name of the Parameter Store variable for SonarCloud token | `string` | n/a | yes |
| <a name="input_stage_regions"></a> [stage\_regions](#input\_stage\_regions) | List of lists containing stage regions | `list(list(string))` | n/a | yes |
| <a name="input_stages"></a> [stages](#input\_stages) | Map of stage settings | <pre>map(object({<br>    account      = string<br>    regions      = list(string)<br>    region_names = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_synthetics_create"></a> [synthetics\_create](#input\_synthetics\_create) | Flag to specify whether to create Synthetics resources | `bool` | `false` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Target type: <instance> for EC2 or <ip> for ECS | `string` | n/a | yes |
| <a name="input_tryvi_severity"></a> [tryvi\_severity](#input\_tryvi\_severity) | Trivy Scan Severity | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the existing VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact_bucket_arn"></a> [artifact\_bucket\_arn](#output\_artifact\_bucket\_arn) | The Amazon Resource Name (ARN) of the artifact S3 bucket |
| <a name="output_ecr_repo_name"></a> [ecr\_repo\_name](#output\_ecr\_repo\_name) | The name of the Amazon Elastic Container Registry (ECR) repository |
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
| <a name="module_aws_codeartifact"></a> [aws\_codeartifact](#module\_aws\_codeartifact) | ../aws_codeartifact | n/a |
| <a name="module_aws_policies"></a> [aws\_policies](#module\_aws\_policies) | ../iam-policies | n/a |
| <a name="module_buckets"></a> [buckets](#module\_buckets) | ../accelerator_storages | n/a |
| <a name="module_pipeline"></a> [pipeline](#module\_pipeline) | ../aws-codepipeline | n/a |
| <a name="module_pr"></a> [pr](#module\_pr) | ../PR-analysis | n/a |
| <a name="module_pr_codecommit"></a> [pr\_codecommit](#module\_pr\_codecommit) | ../PR-analysis-CodeCommit | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | ../notifications | n/a |
| <a name="module_synthetics"></a> [synthetics](#module\_synthetics) | ../synthetics | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_identifiers"></a> [account\_identifiers](#input\_account\_identifiers) | Identifiers for the AWS account | `list(string)` | n/a | yes |
| <a name="input_admin_name"></a> [admin\_name](#input\_admin\_name) | User Name for access to DLT WEB UI | `string` | `"user"` | no |
| <a name="input_app_fqdn"></a> [app\_fqdn](#input\_app\_fqdn) | List of Fully Qualified Domain Names (FQDN) for the application | `list(string)` | `[]` | no |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | AWS CodeDeploy Application Name | `string` | `""` | no |
| <a name="input_application_port"></a> [application\_port](#input\_application\_port) | Port where a load balancer redirects traffic | `string` | `"8080"` | no |
| <a name="input_artifact_bucket_identifiers"></a> [artifact\_bucket\_identifiers](#input\_artifact\_bucket\_identifiers) | Identifiers for the artifact bucket | `list(string)` | n/a | yes |
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | Prefix for an artifact bucket | `string` | `"artifact-bucket"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID | `string` | n/a | yes |
| <a name="input_bitbucket_user"></a> [bitbucket\_user](#input\_bitbucket\_user) | Username for Bitbucket integration | `string` | `""` | no |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | The build instance type for CodeBuild (default: BUILD\_GENERAL1\_SMALL) | `string` | `"BUILD_GENERAL1_MEDIUM"` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | The build image for CodeBuild to use (default: aws/codebuild/standard:6.0) | `string` | `"aws/codebuild/standard:6.0"` | no |
| <a name="input_build_success"></a> [build\_success](#input\_build\_success) | If true, you will also get notifications about successful builds | `bool` | `false` | no |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | The time to wait for a CodeBuild to complete before timing out in minutes (default: 5) | `string` | `"30"` | no |
| <a name="input_buildspec_carrier"></a> [buildspec\_carrier](#input\_buildspec\_carrier) | The name of buildspec file if we use Carrier | `string` | `"buildspec_carrier.yml"` | no |
| <a name="input_buildspec_dlt"></a> [buildspec\_dlt](#input\_buildspec\_dlt) | The buildspec to be used for the Performance Test stage | `string` | `"buildspec_dlt.yml"` | no |
| <a name="input_buildspec_docker"></a> [buildspec\_docker](#input\_buildspec\_docker) | The buildspec file to be used for the Package stage on ECS | `string` | `"buildspec_docker.yml"` | no |
| <a name="input_buildspec_eks"></a> [buildspec\_eks](#input\_buildspec\_eks) | Buildspec file to be used for EKS deployment | `string` | `"buildspec_eks.yml"` | no |
| <a name="input_buildspec_package"></a> [buildspec\_package](#input\_buildspec\_package) | The buildspec file to be used for the Package stage on EC2 | `string` | `"buildspec.yml"` | no |
| <a name="input_buildspec_selenium"></a> [buildspec\_selenium](#input\_buildspec\_selenium) | The buildspec file to be used for the Func Test stage. | `string` | `"buildspec_selenium.yml"` | no |
| <a name="input_buildspec_sonar"></a> [buildspec\_sonar](#input\_buildspec\_sonar) | The buildspec file to be used for the Test stage. | `string` | `"buildspec_sonar.yml"` | no |
| <a name="input_buildspec_unit"></a> [buildspec\_unit](#input\_buildspec\_unit) | The buildspec file to be used for Unit Tests stage | `string` | `"buildspec_unit_tests.yml"` | no |
| <a name="input_carrier_create"></a> [carrier\_create](#input\_carrier\_create) | Flag to specify whether to create Carrier resources | `bool` | `false` | no |
| <a name="input_carrier_project_id"></a> [carrier\_project\_id](#input\_carrier\_project\_id) | The Carrier project ID | `string` | `""` | no |
| <a name="input_carrier_test_id"></a> [carrier\_test\_id](#input\_carrier\_test\_id) | The Carrier test ID | `string` | `""` | no |
| <a name="input_carrier_token_name"></a> [carrier\_token\_name](#input\_carrier\_token\_name) | Name of the Parameter Store variable for Carrier token | `string` | `"/carrier/token"` | no |
| <a name="input_carrier_url"></a> [carrier\_url](#input\_carrier\_url) | URL for Carrier integration | `string` | `""` | no |
| <a name="input_cluster_config"></a> [cluster\_config](#input\_cluster\_config) | Name of AWS Parameter Store Variable, where K8s Cluster config stored in base64 | `string` | `""` | no |
| <a name="input_cluster_region"></a> [cluster\_region](#input\_cluster\_region) | Region for the EKS cluster | `string` | `""` | no |
| <a name="input_codeartifact_create"></a> [codeartifact\_create](#input\_codeartifact\_create) | Create AWS Codeartifact for JAVA Application | `bool` | `false` | no |
| <a name="input_codedeploy_role_arns"></a> [codedeploy\_role\_arns](#input\_codedeploy\_role\_arns) | List of AWS CodeDeploy role ARNs | `list(string)` | `[]` | no |
| <a name="input_codestarconnection_host_arn"></a> [codestarconnection\_host\_arn](#input\_codestarconnection\_host\_arn) | The ARN of the host that the connection is associated with | `string` | `""` | no |
| <a name="input_cognito_client_id"></a> [cognito\_client\_id](#input\_cognito\_client\_id) | Cognito Client ID for the DLT test | `string` | `""` | no |
| <a name="input_cognito_identity_pool_id"></a> [cognito\_identity\_pool\_id](#input\_cognito\_identity\_pool\_id) | Cognito Identity Pool ID for the DLT test | `string` | `""` | no |
| <a name="input_cognito_password_name"></a> [cognito\_password\_name](#input\_cognito\_password\_name) | Parameter Store variable name for Cognito User for DLT | `string` | `"/cognito/password"` | no |
| <a name="input_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#input\_cognito\_user\_pool\_id) | Cognito User Pool ID for the DLT test | `string` | `""` | no |
| <a name="input_concurrency"></a> [concurrency](#input\_concurrency) | The number of concurrent virtual users generated per task. The recommended limit based on default settings is 200 virtual users. | `number` | `1` | no |
| <a name="input_connection_provider"></a> [connection\_provider](#input\_connection\_provider) | Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer; leave blank for others | `string` | `"GitHub"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Container name for the application | `string` | `"application"` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU Size for container, min=256 | `number` | n/a | yes |
| <a name="input_deployment_group_names"></a> [deployment\_group\_names](#input\_deployment\_group\_names) | AWS CodeDeploy Deployment Group | `list(string)` | `[]` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for AWS CodePipeline notifications | `string` | `"AWS CodePipeline Notification"` | no |
| <a name="input_dlt_api_host"></a> [dlt\_api\_host](#input\_dlt\_api\_host) | API host for the DLT test | `string` | `""` | no |
| <a name="input_dlt_create"></a> [dlt\_create](#input\_dlt\_create) | Flag to specify whether to create DLT test resources | `bool` | `true` | no |
| <a name="input_dlt_fqdn"></a> [dlt\_fqdn](#input\_dlt\_fqdn) | Fully Qualified Domain Name (FQDN) for the DLT test | `string` | `""` | no |
| <a name="input_dlt_task_count"></a> [dlt\_task\_count](#input\_dlt\_task\_count) | Number of containers that will be launched in the Fargate cluster to run the test scenario. Additional tasks will not be created once the account limit on Fargate resources has been reached, however tasks already running will continue. | `number` | `1` | no |
| <a name="input_dlt_test_id"></a> [dlt\_test\_id](#input\_dlt\_test\_id) | The ID of your load test. | `string` | `""` | no |
| <a name="input_dlt_test_name"></a> [dlt\_test\_name](#input\_dlt\_test\_name) | The name of your load test. | `string` | `""` | no |
| <a name="input_dlt_test_type"></a> [dlt\_test\_type](#input\_dlt\_test\_type) | DLT test type (`simple` / `jmeter`) | `string` | `"simple"` | no |
| <a name="input_dlt_ui_url"></a> [dlt\_ui\_url](#input\_dlt\_ui\_url) | URL for the DLT WEB UI | `string` | `""` | no |
| <a name="input_docker_password"></a> [docker\_password](#input\_docker\_password) | AWS Parameter Store variable Name to get password for Docker Registry | `string` | `""` | no |
| <a name="input_docker_repo"></a> [docker\_repo](#input\_docker\_repo) | Name for Docker Registry REPO/NAME | `string` | `""` | no |
| <a name="input_docker_user"></a> [docker\_user](#input\_docker\_user) | AWS Parameter Store variable of User to get Image from Docker Registry | `string` | `""` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_role_arn"></a> [eks\_role\_arn](#input\_eks\_role\_arn) | ARN of the role used for EKS resources | `string` | `""` | no |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | List of email addresses to receive AWS CodePipeline notifications | `list(string)` | `[]` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Map containing environment variables per environment | `map(list(map(string)))` | <pre>{<br>  "dev": [],<br>  "qa": [],<br>  "uat": []<br>}</pre> | no |
| <a name="input_environments"></a> [environments](#input\_environments) | List of environment names | `list(string)` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Delete bucket when destroy: true or false | `bool` | n/a | yes |
| <a name="input_git_owner"></a> [git\_owner](#input\_git\_owner) | Git Repository Owner | `string` | n/a | yes |
| <a name="input_helm_chart"></a> [helm\_chart](#input\_helm\_chart) | Helm Chart URL with release | `string` | `""` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Version of the Helm chart to use | `string` | `""` | no |
| <a name="input_hold_for"></a> [hold\_for](#input\_hold\_for) | Time to hold target concurrency. | `string` | `"1m"` | no |
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | Mutability of docker image tag of application | `string` | `"IMMUTABLE"` | no |
| <a name="input_key_service_users"></a> [key\_service\_users](#input\_key\_service\_users) | A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration) | `list(string)` | `[]` | no |
| <a name="input_kms_identifiers"></a> [kms\_identifiers](#input\_kms\_identifiers) | Identifiers for KMS policy. | `list(string)` | `[]` | no |
| <a name="input_llm_model"></a> [llm\_model](#input\_llm\_model) | LLM Model for AI | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory size for container, min=512 | `number` | n/a | yes |
| <a name="input_openai_api_endpoint"></a> [openai\_api\_endpoint](#input\_openai\_api\_endpoint) | Open AI Endpoint | `string` | n/a | yes |
| <a name="input_openai_token_name"></a> [openai\_token\_name](#input\_openai\_token\_name) | Parameter Store Variable Name for OPEN AI API KEY | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | Name of a Sonar Organization | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of private subnet IDs to use for the deployment | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of the project for tags and resource naming | `string` | n/a | yes |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | Project key for SonarQube | `string` | n/a | yes |
| <a name="input_provider_endpoint"></a> [provider\_endpoint](#input\_provider\_endpoint) | Endpoint for the provider | `string` | n/a | yes |
| <a name="input_ramp_up"></a> [ramp\_up](#input\_ramp\_up) | The time to reach target concurrency. | `string` | `"1m"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy into | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | Name of region\_name to deploy application, use for resources naming | `string` | n/a | yes |
| <a name="input_repo_default_branch"></a> [repo\_default\_branch](#input\_repo\_default\_branch) | Default branch name for the repository | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of an application repository | `string` | n/a | yes |
| <a name="input_report_portal_environments"></a> [report\_portal\_environments](#input\_report\_portal\_environments) | List of Report Portal environments to deploy | `list(map(string))` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map containing secret variables per environment | `map(list(map(string)))` | <pre>{<br>  "dev": [],<br>  "qa": [],<br>  "uat": []<br>}</pre> | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security group IDs to associate with resources for testing | `list(string)` | `[]` | no |
| <a name="input_selenium_create"></a> [selenium\_create](#input\_selenium\_create) | Flag to specify whether to create Selenium resources | `bool` | `false` | no |
| <a name="input_service_bucket_prefix"></a> [service\_bucket\_prefix](#input\_service\_bucket\_prefix) | Prefix for a storage bucket | `string` | `"service-bucket"` | no |
| <a name="input_sonar_url"></a> [sonar\_url](#input\_sonar\_url) | URL for SonarQube or SonarCloud instance | `string` | n/a | yes |
| <a name="input_sonarcloud_token_name"></a> [sonarcloud\_token\_name](#input\_sonarcloud\_token\_name) | Name of the Parameter Store variable for SonarCloud token | `string` | n/a | yes |
| <a name="input_stage_regions"></a> [stage\_regions](#input\_stage\_regions) | List of lists containing stage regions | `list(list(string))` | n/a | yes |
| <a name="input_stages"></a> [stages](#input\_stages) | Map of stage settings | <pre>map(object({<br>    account      = string<br>    regions      = list(string)<br>    region_names = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_synthetics_create"></a> [synthetics\_create](#input\_synthetics\_create) | Flag to specify whether to create Synthetics resources | `bool` | `false` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Target type: <instance> for EC2 or <ip> for ECS | `string` | n/a | yes |
| <a name="input_tryvi_severity"></a> [tryvi\_severity](#input\_tryvi\_severity) | Trivy Scan Severity | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the existing VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifact_bucket_arn"></a> [artifact\_bucket\_arn](#output\_artifact\_bucket\_arn) | The Amazon Resource Name (ARN) of the artifact S3 bucket |
| <a name="output_ecr_repo_name"></a> [ecr\_repo\_name](#output\_ecr\_repo\_name) | The name of the Amazon Elastic Container Registry (ECR) repository |
<!-- END_TF_DOCS -->
