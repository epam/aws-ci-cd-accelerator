<h1 align="center"> AI Tools for Applications repositories </h1>
<hr>

> **Disclaimer!** *When using our solution to review your IaC and application code with any external or internal AI platform, we strongly recommend paying particular attention to your responsibility for securing confidential data.*
> *We do not store confidential data and cannot guarantee that the information you provide when using such platforms will remain confidential. Furthermore, we are not responsible for interactions between our solution and any platform, and all potential risks are solely the user's.*
> *Always ensure that all the code and data you share do not contain any confidential or sensitive information. Disclosed data should be de-identified or otherwise prepared in compliance with all data protection requirements. Be informed and clearly understand that you only share data that can be safely disclosed.*
> *By confirming the use of our solution, you agree to take full responsibility for any potential risks associated with revealing your data.*



# AI Handler for Applications repositories

## Description
For application repositories, we have implemented a solution that works with pull request comments requests. Depending on the comments we have several actions for AI:

1) unit tests generation
2) code explanation
3) code coverage by comments

## Workflow:

PR Comment in a specific format → GitHub webhook triggered by ISSUE_COMMENT event → Lambda as a front door of the request → CodeBuild as a main handler and communicator with AI → output in PR comments (by default) or as a new PR

## Diagram

![Workflow_diagram](../AI/pic/ai_handler/workflow_diagram.png)

## Terraform module
There is Terraform module [ai_handler](../../modules/accelerator/ai_handler) for this solution.

You can deploy it by setting variable `ai_handler_create = true` in [env.hcl](../../terragrunt-infrastructure-example/accelerator/accounts/aws_account_id/regions/example/setup_folder/applications/example/env.hcl) file, when you do initial setup for application CI/CD and deploy [setup_folder](../../terragrunt-infrastructure-example/accelerator/accounts/aws_account_id/regions/example/setup_folder)

![enable_variable](../AI/pic/ai_handler/enable_variable.png)


## Webhook
Webhook URL is a URL of Lambda function. Webhook and its settings are created automatically once the terraform code deployed

![Webhook](../AI/pic/ai_handler/webhook_url.png)

We react on **ISSUE_COMMENT** event only

![Webhook_event](../AI/pic/ai_handler/webhook_event.png)

# **Infrastructure**
## Lambda

Lambda is the main point to receive a payload of GitHub webhook. Parse it, detect a keyword we check to start AI handler, and check action type (unit test, code explanation, comment coverage). Detect repository parameters: PR number, owner of the repository, repository name, and whether we create a new PR with results or not. It has several main options

### Layer

It contains a request Python module because it doesn't support Lambda by default. An additional layer is a workaround on how to install it

![Layer](../AI/pic/ai_handler/lambda_layer.png)

The Terraform module has a zip file with this Layer we deploy along with the Terraform code.

The Layer contains the Request Python module zip file which is not available in Lambda by default.

![Request_python_module](../AI/pic/ai_handler/python.zip.png)


### Environment variables

CodeBuild name and GitHub Token

![Codebuild_env_var](../AI/pic/ai_handler/codebuild_env_var.png)

### Python code

It resides in the terraform code and is deployed by terraform

![Python_code](../AI/pic/ai_handler/lambda_tf.png)

### Runtime

As Python 3.11

![Python_code](../AI/pic/ai_handler/lambda_runtime.png)

### Enabled Function URL

We use it as a front door to trigger the Lambda function by a webhook from GitHub

![Lambda_URL](../AI/pic/ai_handler/lambda_url.png)

## CodeBuild

If the condition of a comment in a PR is met our conditions, it triggers a CodeBuild, which executes AI handler script [ai_cicd_analyzer.py](../../docs/template_config_files/scripts/ai/ai_cicd_analyzer.py).

- [**buildspec_with_ai.yml**](../../docs/template_config_files/buildspec_with_ai.yml) should be copied to the application repository.

## Python code

As a step of codebuild we must run our AI script
```
build:
  commands:
    - python ${CODEBUILD_SRC_DIR}/scripts/ai/ai_cicd_analyzer.py
```

Source code also exists in the Infra repository for reference but in the target application repository it should be placed manually in the folder scripts/ai together with requirements.txt in the scripts folder

## Environment variables

They passed by Lambda directly

![Codebuild_env_var](../AI/pic/ai_handler/codebuild_env_var.png)

## Source of CodeBuild

An important step to force it to work properly. Settings deployed by Terraform code.

![Source_codebuild](../AI/pic/ai_handler/codebuild_source.png)

## Results
Call for a Help Menu

![Help_menu](../AI/pic/ai_handler/help_menu.png)
![Help_menu](../AI/pic/ai_handler/help_menu_2.png)
![Help_menu](../AI/pic/ai_handler/help_menu_3.png)

## Unit test generation

![Unit_test_result](../AI/pic/ai_handler/unit_test_result.png)

## Code explanation

![Code_explanation_result](../AI/pic/ai_handler/doc_results.png)

## Code coverage by comments

![Comments](../AI/pic/ai_handler/comment_results.png)


## Wrong file path or name

![Wrong_file_name](../AI/pic/ai_handler/no_file.png)

## With pull request option (for comments and unit tests only)
![PR](../AI/pic/ai_handler/pr_option.png)

![Files_changed](../AI/pic/ai_handler/files_changed.png)

## If the branch generated by AI already exists

![Branch_exist](../AI/pic/ai_handler/branch_exist.png)


<hr>

# QualityGate issues handler for App repositories

## Goal
Auto fix of SonarQube Quality Gate issues for application repositories

## Workflow:
1) Once a new PR is created, we trigger a CodeBuild by a webhook

2) Sonar scanner preinstalled in CodeBuild. If the quality gate fails during the scan we execute AI script

3) The script grabs all the files and all the related issues. Send to AI. Receive some output.

4) Create a new branch with a prefix (001 for example)

5) Create a new PR from the new branch

6) Run the same process again

7) If Quality Gate fails check with AI again.

8) Create a new branch with the prefix 002

9) Create a new PR from the branch

10) If Quality Gate fails again we send a comment in PR that we reached a maximum number of iteration.

## Diagram

![Workflow_diagram](../AI/pic/quality_gate_issue_handler/diagram.png)

## Terraform code
We do not have some specific terraform code for this solution since this is a part of our previous solution for the sonar scanner based on pull request events.

## Source code
- Buildspec for CodeBuild

This [buildspec_pr.yml](../AI/quality_gate_error_handler/buildspec_pr.yml) must be placed in the root folder of the repository with the application. Codebuild we use for Sonar Scaner configured already to use this file name.

- AI script [sonar_handler.py](../../docs/template_config_files/scripts/ai/sonar_handler.py) and requirements we store in [ai](../../docs/template_config_files/scripts/ai) folder in `scripts` directory.
- We run AI script if internal CodeBuild variable CODEBUILD_BUILD_SUCCEEDING  = 0 (if the build step fails. It is possible only if the quality gate failed) and at the same time we provide AI token (currently is OpenAI)


## Results
- An initial pull request created

![Initial_PR](../AI/pic/quality_gate_issue_handler/initial_pr.png)

- An issue happened and we ran a script to create a new branch with -001 prefix and a pull request from it

![New_branch](../AI/pic/quality_gate_issue_handler/new_branch.png)

- A new pull request

![New_PR](../AI/pic/quality_gate_issue_handler/new_pr.png)

- If the Quality Gate still fails after AI modifications in the problematic files we run the process again

![second_iteration](../AI/pic/quality_gate_issue_handler/second_iteration.png)

- A branch with the prefix -002 will be the last iteration in case AI can not fix the issue completely and some issue still exist

![third_iteration](../AI/pic/quality_gate_issue_handler/third_iteration.png)

- Also, if we try to run AI script from the branch that already has AI-generated branch we will receive a warning in the PR comments

![already_exist](../AI/pic/quality_gate_issue_handler/branch_exist.png)

- Results of files modifications in a PR

![files_changed](../AI/pic/quality_gate_issue_handler/files_changed.png)

#### [Main page](../infra.md)
