## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | \>= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | \>= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | \>= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.carrier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.dlt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.package](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.test_selenium](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.unit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.build_deploy_to_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.build_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.carrier_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.dlt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.test_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.test_selenium](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.unit_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codepipeline.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline.codepipeline_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline.codepipeline_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codestarconnections_connection.codestar_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_name"></a> [admin\_name](#input\_admin\_name) | n/a | `any` | n/a | yes |
| <a name="input_app_fqdn"></a> [app\_fqdn](#input\_app\_fqdn) | n/a | `list(string)` | n/a | yes |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | n/a | `string` | n/a | yes |
| <a name="input_approve_sns_arn"></a> [approve\_sns\_arn](#input\_approve\_sns\_arn) | n/a | `string` | n/a | yes |
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID to deploy to | `any` | n/a | yes |
| <a name="input_aws_kms_key"></a> [aws\_kms\_key](#input\_aws\_kms\_key) | n/a | `any` | n/a | yes |
| <a name="input_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#input\_aws\_kms\_key\_arn) | n/a | `any` | n/a | yes |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | The build instance type for CodeBuild (default: BUILD\_GENERAL1\_SMALL) | `any` | n/a | yes |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | The build image for CodeBuild to use (default: aws/codebuild/standard:4.0) | `any` | n/a | yes |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | The time to wait for a CodeBuild to complete before timing out in minutes (default: 5) | `any` | n/a | yes |
| <a name="input_buildspec_carrier"></a> [buildspec\_carrier](#input\_buildspec\_carrier) | The name of buildspec file if we use Carrier | `any` | n/a | yes |
| <a name="input_buildspec_dlt"></a> [buildspec\_dlt](#input\_buildspec\_dlt) | The buildspec to be used for the Performance Test | `any` | n/a | yes |
| <a name="input_buildspec_eks"></a> [buildspec\_eks](#input\_buildspec\_eks) | ============================ EKS ==========================# | `any` | n/a | yes |
| <a name="input_buildspec_package"></a> [buildspec\_package](#input\_buildspec\_package) | The buildspec file to be used for the Package stage on EC2 or ECS | `any` | n/a | yes |
| <a name="input_buildspec_selenium"></a> [buildspec\_selenium](#input\_buildspec\_selenium) | The buildspec file to be used for the Func Test stage. | `any` | n/a | yes |
| <a name="input_buildspec_sonar"></a> [buildspec\_sonar](#input\_buildspec\_sonar) | The buildspec file to be used for the Sonar Test stage. | `any` | n/a | yes |
| <a name="input_buildspec_unit"></a> [buildspec\_unit](#input\_buildspec\_unit) | ======================= Unit Tests ===========================# | `string` | n/a | yes |
| <a name="input_carrier_create"></a> [carrier\_create](#input\_carrier\_create) | =============== Carrrier ======================= | `bool` | n/a | yes |
| <a name="input_carrier_project_id"></a> [carrier\_project\_id](#input\_carrier\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_carrier_test_id"></a> [carrier\_test\_id](#input\_carrier\_test\_id) | n/a | `string` | n/a | yes |
| <a name="input_carrier_token_name"></a> [carrier\_token\_name](#input\_carrier\_token\_name) | n/a | `string` | n/a | yes |
| <a name="input_carrier_url"></a> [carrier\_url](#input\_carrier\_url) | n/a | `string` | n/a | yes |
| <a name="input_cluster_config"></a> [cluster\_config](#input\_cluster\_config) | Name of AWS Parameter Store Variable, where K8s Cluster config stored in base64 | `any` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_cluster_region"></a> [cluster\_region](#input\_cluster\_region) | n/a | `any` | n/a | yes |
| <a name="input_codeartifact_domain"></a> [codeartifact\_domain](#input\_codeartifact\_domain) | Use for Java application | `any` | n/a | yes |
| <a name="input_codeartifact_repo"></a> [codeartifact\_repo](#input\_codeartifact\_repo) | Use for Java application | `any` | n/a | yes |
| <a name="input_codebuild_role"></a> [codebuild\_role](#input\_codebuild\_role) | n/a | `any` | n/a | yes |
| <a name="input_codedeploy_role_arns"></a> [codedeploy\_role\_arns](#input\_codedeploy\_role\_arns) | n/a | `list(string)` | n/a | yes |
| <a name="input_codepipeline_role"></a> [codepipeline\_role](#input\_codepipeline\_role) | n/a | `any` | n/a | yes |
| <a name="input_cognito_client_id"></a> [cognito\_client\_id](#input\_cognito\_client\_id) | n/a | `any` | n/a | yes |
| <a name="input_cognito_identity_pool_id"></a> [cognito\_identity\_pool\_id](#input\_cognito\_identity\_pool\_id) | n/a | `any` | n/a | yes |
| <a name="input_cognito_password_name"></a> [cognito\_password\_name](#input\_cognito\_password\_name) | n/a | `any` | n/a | yes |
| <a name="input_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#input\_cognito\_user\_pool\_id) | n/a | `any` | n/a | yes |
| <a name="input_concurrency"></a> [concurrency](#input\_concurrency) | n/a | `number` | n/a | yes |
| <a name="input_connection_provider"></a> [connection\_provider](#input\_connection\_provider) | Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer. | `string` | n/a | yes |
| <a name="input_deployment_group_names"></a> [deployment\_group\_names](#input\_deployment\_group\_names) | =============== Codedeploy ===================================# | `list(string)` | n/a | yes |
| <a name="input_dlt_api_host"></a> [dlt\_api\_host](#input\_dlt\_api\_host) | n/a | `any` | n/a | yes |
| <a name="input_dlt_create"></a> [dlt\_create](#input\_dlt\_create) | =============== Variables for DLT Test ============== | `bool` | n/a | yes |
| <a name="input_dlt_fqdn"></a> [dlt\_fqdn](#input\_dlt\_fqdn) | n/a | `any` | n/a | yes |
| <a name="input_dlt_task_count"></a> [dlt\_task\_count](#input\_dlt\_task\_count) | n/a | `number` | n/a | yes |
| <a name="input_dlt_test_id"></a> [dlt\_test\_id](#input\_dlt\_test\_id) | n/a | `any` | n/a | yes |
| <a name="input_dlt_test_name"></a> [dlt\_test\_name](#input\_dlt\_test\_name) | n/a | `any` | n/a | yes |
| <a name="input_dlt_test_type"></a> [dlt\_test\_type](#input\_dlt\_test\_type) | n/a | `any` | n/a | yes |
| <a name="input_dlt_ui_url"></a> [dlt\_ui\_url](#input\_dlt\_ui\_url) | n/a | `string` | n/a | yes |
| <a name="input_docker_password"></a> [docker\_password](#input\_docker\_password) | AWS Parameter Store variable Name to get password for Docker Registry | `any` | n/a | yes |
| <a name="input_docker_repo"></a> [docker\_repo](#input\_docker\_repo) | Name for Docker Registry REPO/NAME | `any` | n/a | yes |
| <a name="input_docker_user"></a> [docker\_user](#input\_docker\_user) | User for Docker Registry to get Image from | `any` | n/a | yes |
| <a name="input_ecr_repo_name"></a> [ecr\_repo\_name](#input\_ecr\_repo\_name) | n/a | `any` | n/a | yes |
| <a name="input_eks_role_arn"></a> [eks\_role\_arn](#input\_eks\_role\_arn) | n/a | `any` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | List of enviroments for deployments. Used for creation according CodeGuru profiling\_groups | `list(string)` | n/a | yes |
| <a name="input_helm_chart"></a> [helm\_chart](#input\_helm\_chart) | Helm Chart URL with release | `any` | n/a | yes |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | n/a | `any` | n/a | yes |
| <a name="input_hold_for"></a> [hold\_for](#input\_hold\_for) | n/a | `any` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The organization name for Sonar | `any` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | Project Key for Sonar | `string` | n/a | yes |
| <a name="input_ramp_up"></a> [ramp\_up](#input\_ramp\_up) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | n/a | `any` | n/a | yes |
| <a name="input_repo_default_branch"></a> [repo\_default\_branch](#input\_repo\_default\_branch) | The name of the default repository branch (default: master) | `any` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository (e.g. new-repo). | `any` | n/a | yes |
| <a name="input_report_portal_environments"></a> [report\_portal\_environments](#input\_report\_portal\_environments) | n/a | `list(map(string))` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | n/a | `list(string)` | n/a | yes |
| <a name="input_selenium_create"></a> [selenium\_create](#input\_selenium\_create) | n/a | `bool` | n/a | yes |
| <a name="input_sonar_url"></a> [sonar\_url](#input\_sonar\_url) | Sonar URL | `string` | n/a | yes |
| <a name="input_sonarcloud_token_name"></a> [sonarcloud\_token\_name](#input\_sonarcloud\_token\_name) | n/a | `string` | n/a | yes |
| <a name="input_stage_regions"></a> [stage\_regions](#input\_stage\_regions) | Regions where application infrastructure for stage is deployed | `list(list(string))` | n/a | yes |
| <a name="input_statemachine_arn"></a> [statemachine\_arn](#input\_statemachine\_arn) | n/a | `string` | n/a | yes |
| <a name="input_storage_bucket"></a> [storage\_bucket](#input\_storage\_bucket) | Bucket where additional artifacts store(for dlt, deb script) | `string` | n/a | yes |
| <a name="input_synthetics_create"></a> [synthetics\_create](#input\_synthetics\_create) | ========================= Synthetics ======================# | `bool` | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | n/a | `any` | n/a | yes |
| <a name="input_tryvi_severity"></a> [tryvi\_severity](#input\_tryvi\_severity) | ========================= Docker Image Scan ==================# | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_build_project"></a> [build\_project](#output\_build\_project) | n/a |
| <a name="output_codepipeline_arn"></a> [codepipeline\_arn](#output\_codepipeline\_arn) | n/a |
| <a name="output_codepipeline_name"></a> [codepipeline\_name](#output\_codepipeline\_name) | n/a |
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
| [aws_cloudformation_stack.codestar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_cloudwatch_log_group.carrier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.dlt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.package](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.test_selenium](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.unit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codebuild_project.build_deploy_to_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.build_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.carrier_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.dlt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.test_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.test_selenium](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.unit_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codepipeline.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline.codepipeline_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline.codepipeline_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codestarconnections_connection.codestar_connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection) | resource |
| [aws_codestarconnections_host.myhost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_host) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_name"></a> [admin\_name](#input\_admin\_name) | Name of the admin user | `string` | n/a | yes |
| <a name="input_app_fqdn"></a> [app\_fqdn](#input\_app\_fqdn) | Fully Qualified Domain Name of the application | `list(string)` | n/a | yes |
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name of the application for AWS CodeDeploy | `string` | n/a | yes |
| <a name="input_approve_sns_arn"></a> [approve\_sns\_arn](#input\_approve\_sns\_arn) | SNS Topic ARN for approval notifications | `string` | n/a | yes |
| <a name="input_artifact_bucket_prefix"></a> [artifact\_bucket\_prefix](#input\_artifact\_bucket\_prefix) | Prefix for the S3 bucket where the artifacts are stored | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID where resources will be created | `string` | n/a | yes |
| <a name="input_aws_kms_key"></a> [aws\_kms\_key](#input\_aws\_kms\_key) | AWS KMS Key used for encryption and decryption | `string` | n/a | yes |
| <a name="input_aws_kms_key_arn"></a> [aws\_kms\_key\_arn](#input\_aws\_kms\_key\_arn) | AWS KMS Key ARN used for encryption and decryption | `string` | n/a | yes |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | The build instance type for CodeBuild | `string` | n/a | yes |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | The build image for CodeBuild to use | `string` | n/a | yes |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | The time to wait for a CodeBuild to complete before timing out in minutes | `string` | n/a | yes |
| <a name="input_buildspec_carrier"></a> [buildspec\_carrier](#input\_buildspec\_carrier) | The buildspec for Carrier | `string` | n/a | yes |
| <a name="input_buildspec_dlt"></a> [buildspec\_dlt](#input\_buildspec\_dlt) | The buildspec to be used for the Performance Test | `string` | n/a | yes |
| <a name="input_buildspec_eks"></a> [buildspec\_eks](#input\_buildspec\_eks) | The buildspec for EKS | `string` | n/a | yes |
| <a name="input_buildspec_package"></a> [buildspec\_package](#input\_buildspec\_package) | The buildspec file to be used for the Package stage on EC2 or ECS | `string` | n/a | yes |
| <a name="input_buildspec_selenium"></a> [buildspec\_selenium](#input\_buildspec\_selenium) | The buildspec file to be used for the Func Test stage | `string` | n/a | yes |
| <a name="input_buildspec_sonar"></a> [buildspec\_sonar](#input\_buildspec\_sonar) | The buildspec file to be used for the Sonar Test stage | `string` | n/a | yes |
| <a name="input_buildspec_unit"></a> [buildspec\_unit](#input\_buildspec\_unit) | The buildspec for unit tests | `string` | n/a | yes |
| <a name="input_carrier_create"></a> [carrier\_create](#input\_carrier\_create) | Flag to enable the creation of Carrier resources | `bool` | n/a | yes |
| <a name="input_carrier_project_id"></a> [carrier\_project\_id](#input\_carrier\_project\_id) | Project ID for Carrier | `string` | n/a | yes |
| <a name="input_carrier_test_id"></a> [carrier\_test\_id](#input\_carrier\_test\_id) | Test ID for Carrier | `string` | n/a | yes |
| <a name="input_carrier_token_name"></a> [carrier\_token\_name](#input\_carrier\_token\_name) | Name of Carrier token | `string` | n/a | yes |
| <a name="input_carrier_url"></a> [carrier\_url](#input\_carrier\_url) | URL for Carrier | `string` | n/a | yes |
| <a name="input_cluster_config"></a> [cluster\_config](#input\_cluster\_config) | Base64-encoded K8s cluster configuration | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_region"></a> [cluster\_region](#input\_cluster\_region) | AWS region where the cluster is located | `string` | n/a | yes |
| <a name="input_codeartifact_domain"></a> [codeartifact\_domain](#input\_codeartifact\_domain) | Domain for AWS CodeArtifact, used for Java applications | `string` | n/a | yes |
| <a name="input_codeartifact_repo"></a> [codeartifact\_repo](#input\_codeartifact\_repo) | Repository for AWS CodeArtifact, used for Java applications | `string` | n/a | yes |
| <a name="input_codebuild_role"></a> [codebuild\_role](#input\_codebuild\_role) | IAM Role for AWS CodeBuild | `string` | n/a | yes |
| <a name="input_codedeploy_role_arns"></a> [codedeploy\_role\_arns](#input\_codedeploy\_role\_arns) | List of Role ARNs for AWS CodeDeploy | `list(string)` | n/a | yes |
| <a name="input_codepipeline_role"></a> [codepipeline\_role](#input\_codepipeline\_role) | IAM Role for AWS CodePipeline | `string` | n/a | yes |
| <a name="input_codestarconnection_host_arn"></a> [codestarconnection\_host\_arn](#input\_codestarconnection\_host\_arn) | The ARN of the host that the connection is associated with | `string` | n/a | yes |
| <a name="input_cognito_client_id"></a> [cognito\_client\_id](#input\_cognito\_client\_id) | ID of AWS Cognito Client | `string` | n/a | yes |
| <a name="input_cognito_identity_pool_id"></a> [cognito\_identity\_pool\_id](#input\_cognito\_identity\_pool\_id) | ID of AWS Cognito Identity Pool | `string` | n/a | yes |
| <a name="input_cognito_password_name"></a> [cognito\_password\_name](#input\_cognito\_password\_name) | The name of the AWS Cognito password | `string` | n/a | yes |
| <a name="input_cognito_user_pool_id"></a> [cognito\_user\_pool\_id](#input\_cognito\_user\_pool\_id) | ID of AWS Cognito User Pool | `string` | n/a | yes |
| <a name="input_concurrency"></a> [concurrency](#input\_concurrency) | Concurrency level for tasks | `number` | n/a | yes |
| <a name="input_connection_provider"></a> [connection\_provider](#input\_connection\_provider) | Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer | `string` | n/a | yes |
| <a name="input_deployment_group_names"></a> [deployment\_group\_names](#input\_deployment\_group\_names) | List of deployment group names for AWS CodeDeploy | `list(string)` | n/a | yes |
| <a name="input_dlt_api_host"></a> [dlt\_api\_host](#input\_dlt\_api\_host) | Host for DLT API | `string` | n/a | yes |
| <a name="input_dlt_create"></a> [dlt\_create](#input\_dlt\_create) | Flag to control the creation of DLT Test resources | `bool` | n/a | yes |
| <a name="input_dlt_fqdn"></a> [dlt\_fqdn](#input\_dlt\_fqdn) | Fully Qualified Domain Name for DLT service | `string` | n/a | yes |
| <a name="input_dlt_task_count"></a> [dlt\_task\_count](#input\_dlt\_task\_count) | Count of DLT tasks | `number` | n/a | yes |
| <a name="input_dlt_test_id"></a> [dlt\_test\_id](#input\_dlt\_test\_id) | ID of the DLT Test | `string` | n/a | yes |
| <a name="input_dlt_test_name"></a> [dlt\_test\_name](#input\_dlt\_test\_name) | Name of the DLT Test | `string` | n/a | yes |
| <a name="input_dlt_test_type"></a> [dlt\_test\_type](#input\_dlt\_test\_type) | Type of the DLT Test | `string` | n/a | yes |
| <a name="input_dlt_ui_url"></a> [dlt\_ui\_url](#input\_dlt\_ui\_url) | User Interface URL for DLT | `string` | n/a | yes |
| <a name="input_docker_password"></a> [docker\_password](#input\_docker\_password) | Name of the AWS Parameter Store variable storing the Docker Registry password | `string` | n/a | yes |
| <a name="input_docker_repo"></a> [docker\_repo](#input\_docker\_repo) | Name for Docker Registry repository | `string` | n/a | yes |
| <a name="input_docker_user"></a> [docker\_user](#input\_docker\_user) | Username for Docker Registry | `string` | n/a | yes |
| <a name="input_ecr_repo_name"></a> [ecr\_repo\_name](#input\_ecr\_repo\_name) | Name of the ECR repository | `string` | n/a | yes |
| <a name="input_eks_role_arn"></a> [eks\_role\_arn](#input\_eks\_role\_arn) | ARN of the IAM role used by EKS | `string` | n/a | yes |
| <a name="input_environments"></a> [environments](#input\_environments) | List of environments for deployments. Used for creation according CodeGuru profiling groups | `list(string)` | n/a | yes |
| <a name="input_git_owner"></a> [git\_owner](#input\_git\_owner) | The owner of the git repository | `string` | n/a | yes |
| <a name="input_helm_chart"></a> [helm\_chart](#input\_helm\_chart) | Url to the Helm chart with release | `string` | n/a | yes |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Version of the Helm chart | `string` | n/a | yes |
| <a name="input_hold_for"></a> [hold\_for](#input\_hold\_for) | Duration to hold for tasks | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | The organization name for Sonar | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | List of VPC Private Subnet IDs | `list(string)` | n/a | yes |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | Project Key for Sonar | `string` | n/a | yes |
| <a name="input_provider_endpoint"></a> [provider\_endpoint](#input\_provider\_endpoint) | Endpoint for the provider | `string` | n/a | yes |
| <a name="input_ramp_up"></a> [ramp\_up](#input\_ramp\_up) | Ramp up time for tasks | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region where resources will be created | `string` | n/a | yes |
| <a name="input_region_name"></a> [region\_name](#input\_region\_name) | Name of the AWS region | `string` | n/a | yes |
| <a name="input_repo_default_branch"></a> [repo\_default\_branch](#input\_repo\_default\_branch) | The name of the default repository branch | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The name of the GitHub/Bitbucket/CodeCommit repository | `string` | n/a | yes |
| <a name="input_report_portal_environments"></a> [report\_portal\_environments](#input\_report\_portal\_environments) | List of environments for AWS Report Portal | `list(map(string))` | n/a | yes |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security group IDs to be applied to resources | `list(string)` | n/a | yes |
| <a name="input_selenium_create"></a> [selenium\_create](#input\_selenium\_create) | Flag to control the creation of Selenium resources | `bool` | n/a | yes |
| <a name="input_service_bucket"></a> [service\_bucket](#input\_service\_bucket) | Bucket where additional files are stored (for ECS task definitions, deb script) | `string` | n/a | yes |
| <a name="input_sonar_url"></a> [sonar\_url](#input\_sonar\_url) | Sonar URL | `string` | n/a | yes |
| <a name="input_sonarcloud_token_name"></a> [sonarcloud\_token\_name](#input\_sonarcloud\_token\_name) | The name of the SonarCloud token | `string` | n/a | yes |
| <a name="input_stage_regions"></a> [stage\_regions](#input\_stage\_regions) | List of regions where application infrastructure for stage is deployed | `list(list(string))` | n/a | yes |
| <a name="input_statemachine_arn"></a> [statemachine\_arn](#input\_statemachine\_arn) | ARN of the StateMachine for Synthetics | `string` | n/a | yes |
| <a name="input_synthetics_create"></a> [synthetics\_create](#input\_synthetics\_create) | Flag to enable the creation of Synthetics resources | `bool` | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Type of the deployment target (e.g., instance, lambda, or ecs) | `string` | n/a | yes |
| <a name="input_tryvi_severity"></a> [tryvi\_severity](#input\_tryvi\_severity) | Severity level for Trivy (a vulnerability scanner for containers) | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which resources will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codepipeline_arn"></a> [codepipeline\_arn](#output\_codepipeline\_arn) | The ARN of the CodePipeline |
| <a name="output_codepipeline_name"></a> [codepipeline\_name](#output\_codepipeline\_name) | The name of the CodePipeline |
<!-- END_TF_DOCS -->
