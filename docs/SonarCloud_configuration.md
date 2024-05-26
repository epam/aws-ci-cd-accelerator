<h1 align="center"> SonarCloud configuration </h1>

To transfer data to `SonarCloud`, some configuration needs to be done on the `SonarCloud` and `VCS` side. First, you must sign in to `SonarCloud` using your `VCS` account and authorize your SonarCloud organization. You can now add the GitHub organization you are using to SonarCloud by clicking the + next to your account.

![sonarcloud_1](pic/sonarcloud_1.png)

SonarCloud will be installed as a GitHub App for that organization.

![sonarcloud_2](pic/sonarcloud_2.png)

Please check if the SonarCloud app is installed in your organization on GitHub yourself or have the admin check it for you.

![sonarcloud_3](pic/sonarcloud_3.png)

Then you need to give SonarCloud access to your repository.

![sonarcloud_4](pic/sonarcloud_4.png)

In SonarCloud you can now create an organization.

![sonarcloud_5](pic/sonarcloud_5.png)

And choose a plan for this.

![sonarcloud_6](pic/sonarcloud_6.png)

Then start to analyze a new project.

![sonarcloud_7](pic/sonarcloud_7.png)

If everything is ok, you should be able to see something like this.

![sonarcloud_8](pic/sonarcloud_8.png)

For a more complete setup of SonarCloud, refer to the [official documentation](https://sonarcloud.io).

After this step, put the file [buildspec_sonar.yml](template_config_files/buildspec_sonar.yml) to the root of the application repository.

Define all variables for `Sonar` in [env.hcl](../terragrunt-infrastructure-example/accelerator/accounts/aws_account_id/regions/example/setup_folder/applications/example/env.hcl) file and `sonarcloud_token` in [app_parameter_store.hcl](../terragrunt-infrastructure-example/accelerator/accounts/aws_account_id/regions/example/setup_folder/applications/example/app_parameter_store_example.hcl) file.
