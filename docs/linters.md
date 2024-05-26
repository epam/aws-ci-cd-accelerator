<h1 align="center">  Supported Linters and Static Code Analysis tools for Terraform </h1>

<hr>

Currently, we can use the following:
 * [TFLint](https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/config.md), a pluggable Terraform Linter
 * [Checkov](https://www.checkov.io/), a tool for scanning cloud infrastructure configuration misconfigurations.
 * [Regula](https://regula.dev/), a tool for scanning cloud infrastructure configuration misconfigurations.
 * [Cloud Custodian](https://cloudcustodian.io/), a rules engine for managing public cloud accounts and resources, it is needed to write your own policies in [custodian.yml](../custodian.yml) file.
 * [EPAM Syndicate Rule Engine](https://github.com/epam/ecc/blob/main/README.md), Custodian-as-a-service is a serverless service-wrapper over another opensource tool - [Cloud Custodian](https://cloudcustodian.io/).
 * [TFSec](https://tfsec.dev/), a static analysis security scanner for Terraform code.
 * [Infracost](https://www.infracost.io/), a cloud cost estimation tool for Terraform in pull requests.

In order to use a specific linter, you have to set the environmental variable of the linter to `1` in the [Atlantis workflow](../atlantis.yaml). If you don't want to use some linters, specify its environmental variable to `0`.
<hr>

## TFLint
TFLint is a framework and each feature is provided by plugins, the key features are as follows:

* Find possible errors (like invalid instance types) for Major Cloud providers (AWS/Azure/GCP).
* Warn about deprecated syntax, unused declarations.
* Enforce best practices, naming conventions.
* Configuration file [.tflint](../.tflint.hcl) we put to the root of the repository.
* To avoid getting an error, if you don't have installed TFLint locally, we added `exit 0`


## Terragrunt Hooks
* To integrate `TFLint`,`Checkov` and `TFSec` with `terragrunt` we use `terragrunt hook` accordingly this [terragrunt recommendation](https://terragrunt.gruntwork.io/docs/features/hooks/)
* To run `TFLint`,`Checkov` and `TFSec` automatically, we add commands to `terragrunt hook` in [**_envcommon/*.hcl**](../terragrunt-infrastructure-example/application-infrastructure/_envcommon/infrastructure-module.hcl) files, which we deploy from Atlantis:
    ```hcl
    terraform {
      source = "${local.base_source_url}"
      before_hook "validate_tflint" {
        commands = ["validate"]
        execute  = [
          "sh", "-c", <<EOT
                echo "---------------- TFLint Report --------------"
                tflint -v || exit 0
                tflint --init --config "${get_repo_root()}/.tflint.hcl" || exit 0
                tflint --config "${get_repo_root()}/.tflint.hcl" || exit 0
              EOT
        ]
      }
      before_hook "checkov" {
        commands = ["plan"]
        execute  = [
          "sh", "-c", <<EOT
                source $HOME/.venv/bin/activate || exit 0
                checkov -d . --quiet --framework terraform --skip-check CKV_TF_1 > /tmp/checkov_report.log || exit 0
                deactivate || exit 0
              EOT
        ]
      }
      after_hook "tfsec" {
        commands     = ["plan"]
        execute      = [
          "sh", "-c", <<EOT
                tfsec --no-colour --soft-fail -f json --concise-output --out /tmp/tfsec_report.log . || exit 0
              EOT
        ]
      }
    }
    ```
* You can change some parameters of utilities according to their documentation.
* You also can process sectool reports by AI Handler. For more details see the [link](./AI/ai_for_IaC.md)

## Infracost

To use `Infracost`, an API key must be generated. To do that, you need to:
```
$ curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh
$ infracost register
```
We use `INFRACOST_API_KEY` env in `./atlantis.yaml` to connect to Infracost.

You need to add `infracost_api_key` variable to [parameter_store.hcl](../terragrunt-infrastructure-example/parameter_store_example.hcl)

To calculate the estimated costs of your infrastructure, Infracost sends [data](https://www.infracost.io/docs/faq#what-data-is-sent-to-the-cloud-pricing-api) to the server where data is processed.

If `Infracost` was run initially, it would show the entire infrastructure's estimated cost. Consecutive runs will show only the *DELTA*.

**Example output:**

![example_output](pic/infracost.png)

If you don't want this to happen, either the tool can be disabled, or you can run your own [Cloud Pricing API](https://www.infracost.io/docs/faq#can-i-run-my-own-cloud-pricing-api).

#### All these tools are integrated into [atlantis](../atlantis.yaml) workflow.

## Further reading
* [AI Handler](AI/ai_for_IaC.md)
* [CI/CD](./cicd.md)
* [Application environments](../docs/app-envs.md)

#### [Main page](../README.md)
