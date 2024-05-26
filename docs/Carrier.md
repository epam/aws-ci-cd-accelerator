<h1 align="center">Carrier</h1>

You can find all the necessary information via the [link](https://getcarrier.io/#about).

After Carrier is deployed and QA set up a test environment on it, we can run these tests from AWS CodePipeline.

To run test we use docker command with variables:
```bash
docker run -e galloper_url=${galloper_url} -e project_id=${project_id} \
-e token=${auth_token}  getcarrier/control_tower:2.5 --test_id=${test_id}
```

##  Integration with Project

1. To set variable `carrier_create = true` in terraform variables. It adds stage with Carrier test to AWS CodePipeline.
2. Define all variables for Carrier in the `env.hcl`.

#### [Previous page](../README.md)
