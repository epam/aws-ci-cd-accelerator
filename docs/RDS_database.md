<h1 align="center">External database on AWS RDS for the application</h1>


1. You can either create new Databases or ask your DBA to provide credentials for the application connection with DB. You will need next information about the DB:
   * Amazon RDS endpoint for your MySQL database. It typically resembles "my-database.abcdefghij.us-west-1.rds.amazonaws.com".
   * Port used for connecting to the MySQL database (usually port 3306).
   * Master account's username.
   * Master account's password.

2. Put it all together into one row for connection via connection driver `<db_scheme>://<username>:<password>@<rds_hostname>:<port>/<database_name>`. For example:
   `mysql+pymysql://qa_admin:my_Password@my-database.abcdefghij.us-west-1.rds.amazonaws.com:3306/qa`. Alternatively, you can simply pass all the parameters separately, it all depends on the specific requirements of the application. If you follow our instructions, these variables will end up in clear form in the environment variables directly in the instance, task, or pod where the application will be deployed. Then the application will interact with them directly.

3. Define variables with data for connecting to the database.
   * EC2 deployment - Create 3 ParameterStore / SecretsManager (add extra costs for using) parameters (one per each environment:dev,qa,uat) with name structure /<my_local_repo_name>/<environment_name>/db For example: /<my_repo_name>/<stage(dev,qa,uat)>/db. Alternatively, you can simply pass all the parameters separately, it all depends on the specific requirements of the application. Store the [get_environment.sh](./template_config_files/scripts/get_environment.sh) file into scripts dirrectory in the root of you application repository and Select the source parameter for the *SWITCH* variable: `PARAMETERSTORE, SECRETSMANAGER or BOTH`.
   * ECS deployment - As in the previous option, create the required number of variables for each of the environments in the env_vars and secrets variables, passing each value in the Jason format: `{ name = "Key1", value = "Data1"}, { name = "Key2", value = "Data2"}` separating the variables and the values inside them with commas. After this, the variables will go inside the container with the application in the form of environment variables.
   * EKS deployment - For the EKS option, we suggest using standard Kubernetis tools, such as secret for sensitive variables and configmap for everything else. To do this, it is enough to create one for the namespace (environment) in the cluster. As an alternative to this method, use automation tools such as: [External Secrets Operator](https://external-secrets.io/main/guides/introduction/).

4. Set up the Security Groups in AWS:
   * If a Security Group is already associated with your RDS instance, you can modify it. If not, create a new one with a name like <"my-db-sg">, and assign it to the necessary VPC.
   * Add an inbound rule to <"your_db_sg"> with the following details:
     - Type: MYSQL/Aurora
     - Protocol: TCP
     - Port Range: 3306
     - Source: the security group name of your EC2, ECS, or EKS instances.
   * Create another Security Group for your EC2, ECS, or EKS instances, name it "my-app-sg", and assign it to the same VPC.
   * Add an inbound rule to "my-app-sg" depending on your app requirements:
     - Type: MYSQL/Aurora
     - Source: the security group name of your DB.
   * Apply the ID for <"your_app_sg"> to the EC2, ECS application infrastructure via **additional_security_groups** in `/application-infrastructure/application/accounts/<"environment">/regions/. <"your_region_1">/infrastructure-module/env.hcl` and <"your_db_sg"> to your MySQL RDS instance. For more information, please visit [link](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ConnectToInstance.html).
5. Check if everything works as expected. To do this, you need to make a test connection to the instance, task, or pod on which your application will run. An example procedure is described in this [document](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Troubleshooting.html).
