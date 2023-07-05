<h1 align="center"> AWS native CI/CD accelerator </h1>

* [AWS native CI/CD accelerator](./README.md)
  * [Introduction](./README.md#introduction)
  * [Architecture](./README.md#architecture)
* [Infrastructure deployment](docs/infra.md)
  * [Manual](docs/infra.md#manual)
  * [Semi-automatic](docs/infra.md#semi-automatic)
* [Terraform Linters](docs/linters.md)
  * [Infracost](docs/linters.md#infracost)
  * [TFSec](docs/linters.md#TFSec)
* [Distributed Load Testing on AWS Provisioning](docs/dlt.md)
  * [Architecture overview](docs/dlt.md#architecture-overview)
  * [DLT deployment](docs/dlt.md#dlt-deployment)
* [SonarCloud configuration](docs/SonarCloud_configuration.md)  
* [Infrastructure Compliance](docs/infrastructure_compliance.md)
  * [AWS Config](docs/infrastructure_compliance.md#aws-config)
  * [AWS CloudTrail](docs/infrastructure_compliance.md#aws-cloudtrail)
* [CI/CD](docs/cicd.md)
  * [Continuous Integration](docs/cicd.md#continuous-integration)
  * [Continuous Delivery](docs/cicd.md#continuous-delivery)
* [Notifications](docs/notifications.md)
  * [Email](docs/notifications.md#email)
  * [Microsoft Teams and Slack](docs/notifications.md#microsoft-teams-and-slack)
* [Pull Request Analysis](docs/PRanalysis.md)
  * [GitHub/Bitbucket Pull Requests](docs/PRanalysis.md#githubbitbucket-pull-requests)
  * [CodeCommit Pull Requests](docs/PRanalysis.md#codecommit-pull-requests)
  * [GitLab Merge requests](docs/PRanalysis.md#gitlab-merge-requests)
* [Report Portal](docs/Report_Portal.md)
  * [Architecture overview](docs/Report_Portal.md#architecture-overview)
  * [3 easy steps to get started with ReportPortal](docs/Report_Portal.md#3-easy-steps-to-get-started-with-reportportal)
  * [Integration with AWS Accelerator](docs/Report_Portal.md#integration-examples-for-supported-languages)
  * [Integration examples for supported languages](docs/Report_Portal.md#integration-examples-for-supported-languages)
* [Application Code Hosting Platforms](docs/app-vcs.md)
  * [GitHub and Bitbucket](docs/app-vcs.md#github-and-bitbucket)
  * [CodeCommit and GitLab](docs/app-vcs.md#codecommit-and-gitlab)
* [Application environments](docs/app-envs.md)
  * [Deploy to EC2](docs/app-envs.md#deploy-to-ec2)
  * [Deploy to ECS](docs/app-envs.md#deploy-to-ecs)
  * [Deploy to EKS](docs/app-envs.md#deploy-to-eks)

<hr>

## Introduction

AWS native CI/CD accelerator is a product that brings a unified CI/CD approach with testing best practices out of the box and helps to manage infrastructure with a focus on code quality and security. In addition, it absorbs EPAM’s years of experience in designing and implementing CI/CD solutions for numerous clients across different business domains and countries.

Key points:

* is fully automated
* follows industry best practices for CI/CD and testing
* has minimum time for implementation
* serves as a secured gateway for infrastructure management
* offers cost-effective pipelines
* has integrations with major code hosting platforms
* does not require a separate experienced team for support

## Architecture

![General architecture](docs/pic/general-arch.png)

Technologies used by AWS Accelerator:

|  #  |                       Feature                       |                                      Tools                                      |
|:---:|:---------------------------------------------------:|:-------------------------------------------------------------------------------:|
|  1  |                VCSs for IaC hosting                 |                      Bitbucket, <br/> GitHub,<br/> GitLab                       |
|  2  |         VCSs for applications code hosting          |           AWS CodeCommit, <br/> Bitbucket,<br/> GitHub, <br/> GitLab            |
|  3  |            Static code analysis for IaC             |            Checkov,<br/> Cloud Custodian,<br/> Regula, <br/> TFLint             |
|  4  |        Static code analysis for applications        |                  AWS CodeGuru (Java, Python),<br/> SonarCloud                   |
|  5  |                 Functional testing                  |                                    Selenium                                     |
|  6  |                 Performance testing                 | Distributed Load Testing on AWS,<br/> CloudWatch and DLT Web UI (visualization) |
|  7  |         Pull request analysis (SonarCloud)          |            AWS CodeCommit,<br/> Bitbucket,<br/> GitHub,<br/> GitLab             |
|  8  |           Pull request automation for IaC           |                                    Atlantis                                     |
|  9  |            Platform Events Notification             |         Failed (Successful) builds in AWS via<br/> Mail, MsTeams, Slack         |
| 10  |                 Supported languages                 |                         Golang,<br/> Java,<br/> Python                          |
| 11  |                        CI/CD                        |                                AWS CodePipeline                                 |
| 12  |         Test results analysis and reporting         |                                  Report Portal                                  |
| 13  |         Infrastructure Security Compliance          |                      Cloud Custodian,<br/> EPAM Custodian                       |
| 14  | Infrastructure supported for application deployment |                                  EC2, ECS, EKS                                  |

The Accelerator supports:
* [GitLab](https://gitlab.com/), [GitHub](https://github.com/) and [Bitbucket](https://bitbucket.org/) for IaC code hosting
* [CodeCommit](https://aws.amazon.com/codecommit/), [GitHub](https://github.com/) and [Bitbucket](https://bitbucket.org/) for application code hosting ([see more](./docs/app-vcs.md))
* [Terragrunt](https://terragrunt.gruntwork.io/), Infrastructure as Code tool
* AWS:
    * CodeBuild, CodeDeploy, CodePipeline
    * CodeGuru
    * EC2 (ALB, ASG)
    * ECS, ECR, EKS
    * IAM
    * SNS
    * Lambda
    * VPC
* [Atlantis](https://www.runatlantis.io/), Terraform Pull Request Automation
* [Checkov](https://github.com/bridgecrewio/checkov), a static code analysis tool for infrastructure-as-code
* [Cloud Custodian](https://cloudcustodian.io/), a tool for cloud security, governance and management
* [Distributed Load Testing on AWS](https://docs.aws.amazon.com/solutions/latest/distributed-load-testing-on-aws/welcome.html), a Lambda-based performance testing tool
* [SonarCloud](https://sonarcloud.io), cloud-based code quality and security service
* [Tfsec](https://tfsec.dev/), a static analysis security scanner for Terraform code
* [Infracost](https://www.infracost.io/), cloud cost estimation tool for Terraform in pull requests
* [Report Portal](https://reportportal.io/) is a service that provides increased capabilities to speed up results analysis and reporting using built-in analytic features.

To test CI/CD workflow Java and Golang applications can be used:
* [java Spring Boot based application](https://github.com/spring-projects/spring-petclinic)
* [golang task tracker](https://github.com/thewhitetulip/Tasks)

## Further reading

* [Infrastructure deployment](docs/infra.md)
* [CI/CD](docs/cicd.md)
* [Application environments](docs/app-envs.md)