<h1 align="center"> Variables for the project </h1>

- [Common](./variables.md#common)
- [Sensitive](./variables.md#sensetive)
- [Integration](variables.md#integration)
- [Application](variables.md#application)

<hr>

## Common
* Variables for VPC, Atlantis - [common_vars_example.yml](../terragrunt_way/common_vars_example.yml)

|           Variables           |                                                          Description                                                           |    Default     |
|:-----------------------------:|:------------------------------------------------------------------------------------------------------------------------------:|:--------------:|
|        tf_state_bucket        |                                                Name of the bucket for TF State.                                                |       -        |
|        aws_account_id         |                                                        AWS Account ID.                                                         |       -        |
|            region             |                                                          AWS Region.                                                           |  eu-central-1  |
|              azs              |                                                  Availability zone suffixes.                                                   |    a, b, c     |
|       route53_zone_name       |                                               Route53 zone name for the project.                                               |       -        |
|            project            |                                     Project name prefix for naming and tagging resources .                                     |       -        |
|           vpc_range           |                                                           VPC range.                                                           |  10.10.0.0/16  |
|        public_subnets         |                                                      VPC Public subnets.                                                       | 10.10.0-2.0/24 |
|        private_subnets        |                                                      VPC Private subnets.                                                      | 10.10.3-5.0/24 |
|          enable_eip           |                     Elastic IP for NAT VPC. If true, new EIP will be released, false you use Reserved EIP.                     |      true      |
|              eip              |                                                      Reserved elastic IP.                                                      |       -        |
|      nat_prefix_list_ids      | If we use Prefix Lists instead of Cider Blocks, we have to include EIP to this Prefix List for creating security group for NAT |       -        |
|   atlantis_prefix_list_ids    |                  Contains all IPs from GitHub, GitLab, Bitbucket that are allowed to interact with `atlantis`                  |       -        |
|    allowed_prefix_list_ids    |                                       Contains all allowed IPs to interact with our VPC.                                       |       -        |
|         atlantis_name         |                                                       Name for Atlantis.                                                       |    atlantis    |
|        app_cidr_blocks        |                                                  CIDR blocks for application.                                                  |       -        |
|     atlantis_cidr_blocks      |                                              CIDR blocks for access to Atlantis.                                               |       -        |
|         atlantis_name         |                                                     The name for Atlantis.                                                     |       -        |
| ecs_service_assign_public_ip  |                                                Assigning public IP to atlantis.                                                |      true      |
|        repo_whitelist         |                                            List of repos atlantis will be managing.                                            |       -        |


## Sensitive 
* Variables [parameter_store_example.yml](../terragrunt_way/parameter_store_example.yml)

|                Variables                 |                               Descriptions                               |          Default           |
|:----------------------------------------:|:------------------------------------------------------------------------:|:--------------------------:|
|             sonarcloud_token             |                          Token for SonarCloud.                           |             -              |
|              teams_web_hook              |            Teams WebHook if you use Teams for Notifications.             |             -              |
|              slack_web_hook              |            Slack WebHook if you use Slack for Notifications.             |             -              |
|            infracost_api_key             |                           Token for Infracost.                           |             -              |
|             cognito_password             | Password  you will replace during your first visit to DLT Test Web Page. |             -              |
|                 rp_token                 |                         Token for Report Portal.                         |             -              |
|                 c7n_user                 |                      The EPAM Custodian User Name.                       |             -              |
|               c7n_password               |                      Password from EPAM Custodian.                       |             -              |
|               c7n_api_url                |                           EPAM Custodian URL.                            |             -              |
|               dojo_api_key               |                Token from DOJO if you use EPAM Custodian.                |             -              |

| *Atlantis*: one of VSC we need to choose  |           Variables           |          Description           |  Default  |
|:-----------------------------------------:|:-----------------------------:|:------------------------------:|:---------:|
|                  GitHub                   |          github_user          |     GitHub technical user      |     -     |
|                                           |  atlantis_github_user_token   |  GitHub technical user token   |     -     |
|                                           |       organization_name       |    GitHub organization name    |     -     |
|                                           |        infra_repo_name        |   IaC GitHub Repository Name   |     -     |
|                                           |              vcs              |              VCS               |  github   |
|                  GitLab                   |          gitlab_user          |     GitLab technical user      |     -     |
|                                           |  atlantis_gitlab_user_token   |  GitLab technical user token   |     -     |
|                                           |   atlantis_gitlab_hostname    |      GitLab hostname URL       |     -     |
|                                           |          project_id           |       GitLab project id        |     -     |
|                                           |        infra_repo_name        |   IaC GitLab Repository Name   |     -     |
|                                           |              vcs              |              VCS               |  gitlab   |
|                 BitBucket                 |        bitbucket_user         |    BitBucket technical user    |     -     |
|                                           | atlantis_bitbucket_user_token | BitBucket technical user token |     -     |
|                                           |  atlantis_bitbucket_base_url  |       BitBucket base URL       |     -     |
|                                           |        infra_repo_name        | IaC BitBucket Repository Name  |     -     |
|                                           |              vcs              |              VCS               | bitbucket |

## Integration 
* GitLab with AWS CodePipeline integration file [gitlab_example.tfvars](../terragrunt_way/gitlab_integration/example/gitlab_example.tfvars)

|     Variables     |                           Descriptions                            |        Default        |
|:-----------------:|:-----------------------------------------------------------------:|:---------------------:|
|  gitlab_hostname  |                          GitLab HostName                          |           -           |
|    project_id     |                         GitLab Project ID                         |           -           |
|   aws_user_name   |         AWS User whose SSH key we use for AWS CodeCommit          |           -           |
|   gitlab_token    |                     Token for GitLab Project                      |           -           |
|   aws_repo_name   |       Name of AWS CodeCommit Repository(The same as GitLab)       |           -           |
|     sonar_url     |                             Sonar URI                             | https://sonarcloud.io |
| sonarcloud_token  |                            Sonar Token                            |           -           |
| organization_name | Organisation or Group Name of Repository which connect with Sonar |           -           |
|    project_key    |                         Sonar project key                         |           -           |
|      project      |                        Sonar Project Name                         |           -           |
|   sonar_timeout   |                  Sonar timeout for quality gate                   |          300          |

## Application 
* CI/CD Infrastructure [application.yml](../terragrunt_way/applications/example_application/application_vars.yml)

|          Variables          |                                                               Description                                                               |             Default             |
|:---------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------:|:-------------------------------:|
|          repo_name          |                                                 The name of the application repository.                                                 |         "my_repo_name"          |
|     repo_default_branch     |                                                Default branch name for AWS CodePipeline.                                                |             "main"              |
|        environments         |                                                 Environment names for AWS CodePipeline.                                                 |      ["dev", "qa", "uat"]       |
|       email_addresses       |               List of email addresses for email notifications. First email will be used for receiving password from DLT.                |    ["my_user@my_domain.com"]    |
|      organization_name      |                                                      Organization name for Sonar.                                                       |                -                |
|         project_key         |                                                         Project key for Sonar.                                                          |                -                |
|         admin_name          |                                        Administrator account name for the dlt console. Any name.                                        |             "user"              |
|    cognito_password_name    | The path for the dlt password in the AWS ParameterStore where DLT `password` store.   See the [dlt.md](./dlt.md) file for more details. |       "/cognito/password"       |
|     connection_provider     |                             Connection provider for pull requests (Bitbucket, GitHub, GitLab, CodeCommit).                              |            "GitLab"             |
|      application_port       |                                                      The port for an application.                                                       |             "8080"              |
|    docker_container_port    |                                          External port for docker containers with application                                           |             "8080"              |
|             cpu             |                                             CPU allocation (for ECS deployment type only).                                              |               256               |
|           memory            |                                              Memory allocation (Only for ECS deploy type).                                              |               512               |
|      desired_capacity       |                              Desired capacity of autoscale group or ECS task, according to `environment`.                               |         ["1", "1", "1"]         |
|          max_size           |                                                Maximum autoscale group or ECS task size.                                                |         ["2", "2", "2"]         |
|          min_size           |                                                Minimum autoscale group or ECS task size.                                                |         ["0", "0", "0"]         |
|         target_type         |                               Deployment switch ("ip" for ECS deployment / "instance" for EC2 deployment)                               |              "ip"               |
|        instance_type        |                                                    Instance type for EC2 deployment.                                                    |           "t2.micro"            |
|         health_path         |                                             Health check path for application LoadBalancer.                                             |               "/"               |
|          sonar_url          |                                                           Sonar node address.                                                           |     "https://sonarcloud.io"     |
|    sonarcloud_token_name    |                                         The path for the Sonar login in the AWS ParameterStore.                                         |         "/sonar/token"          |
|     connection_provider     |                                   CodestarConnection with specified provider, e.g. Bitbucket, GitHub.                                   |                                 |
|       source_provider       |                 "CodeStarSourceConnection" if you use GitHub or BitBucket, and "CodeCommit" for CodeCommit, and GitLab.                 |          "CodeCommit"           |
|       expiration_days       |                                Amount of days after artifacts of the AWS Code Pipeline will be removed.                                 |              "30"               |
|        force_destroy        |                                             Delete bucket when destroy: "true" or "false".                                              |             "true"              |
|         versioning          |                                    Versioning bucket for artifacts enabled: "Enabled" or "Disabled".                                    |           "Disabled"            |
|     storage_bucket_name     |                                               Name of the bucket with pipeline settings.                                                |                -                |
|    artifact_bucket_name     |                                               Name for a bucket with pipeline artifacts.                                                |                -                |
|        build_success        |                                   If "true", you will also get notifications about successful builds.                                   |             "false"             |
|        display_name         |                        Name that is displayed as a sender when you receive notifications on your email address.                         |           "SNS-Email"           |
|        rp_token_name        |                                     The path for the ReportPortal token in the AWS ParameterStore.                                      |     "/report/portal/token"      |
|         rp_project          |                                                   Name of a project in ReportPortal.                                                    |                -                |
|         rp_endpoint         |                                                       ReportPortal endpoint URL.                                                        | "https://reportportal.epam.com" |
|         region_name         |                                         AWS region name for prefixes (for example, "Ireland").                                          |            "Central"            |
|        cluster_name         |                                                   The name of the Kubernetes cluster.                                                   |                -                |
|        eks_role_arn         |                                     The role created EKS Cluster administrator to manage Helm Chart                                     |                -                |
|  cluster_public_subnet_ids  |                                                     ID for cluster public network.                                                      |                -                |
| cluster_acm_certificate_arn |                                                            ARN certificate.                                                             |                -                |
|   cluster_security_groups   |                                                     Security group for the cluster.                                                     |                -                |
|       cluster_region        |                                                         Region for the cluster.                                                         |                -                |
|       cluster_config        |                                                     The name of the cluster config.                                                     |                -                |
|         docker_repo         |                                                              Docker repo.                                                               |                -                |
|         docker_user         |                                                            Docker user name.                                                            |                -                |
|       docker_password       |                                                          Docker user password.                                                          |                -                |
|          app_fqdn           |                                                     FQDN for application endpoints.                                                     |                -                |
|         helm_chart          |                                                            Helm Chart Store.                                                            |                -                |
|     helm_chart_version      |                                                           Helm Chart version.                                                           |                -                |