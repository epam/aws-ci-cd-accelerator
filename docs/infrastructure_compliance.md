<h1 align="center"> Infrastructure Compliance </h1> 

* [AWS Config](./infrastructure_compliance.md#aWS-Config)
* [AWS CloudTrail](./infrastructure_compliance.md#aWS-CloudTrail )

<hr>

## AWS Config

The infrastructure that is deployed is tracked and monitored by `AWS Config`.  

Several `AWS Config rules` are specified to check whether the resource is `compliant` or `not compliant`:
  * s3_bucket_public_read_prohibited - checks if the public read is prohibited in an S3 bucket
  * s3_bucket_versioning_enabled - checks if S3 bucket versioning is enabled
  * s3_bucket_server_side_encryption_enabled - checks whether S3 bucket server-side encryption is enabled
  * s3_bucket_public_write_prohibited - checks if S3 bucket public write is prohibited
  * instances_in_vpc - checks whether instances that are deployed in your VPC
  * root_account_mfa_enabled - checks if MFA is enabled for the `root` account
  * incoming_ssh_disabled - checks whether incoming SSH is disabled in your `Security Groups`
  * iam_password_policy - checks whether the account password policy meets the specified requirement
  * encrypted_volumes - checks if `EBS volumes` are using encryption
  * EC2-instances-managed-by-SSM - checks if `EC2 instances` are managed by `AWS Systems Manager`
  * Windows-EC2-managedinstance-applications-required - checks if `Windows EC2 instances` have the necessary software installed
  * Linux-EC2-managedinstance-applications-required - checks if `Linux EC2 instances` have the necessary software installed  

You can receive an `email` notification about a `not-compliant` resource, [email_addresses](../terragrunt_way/applications/example_application/application_vars.yml). You can specify the email addresses to which these notifications will be sent.  

Once every `24 hours` the snapshot with the history of your infrastructure will be sent to the `S3 bucket`.

##  AWS CloudTrail 

Tracks `User Activity` and `API Usage`. 

Optionally, you can specify the trail as `multi-region` by setting its value to `true` [here](../terragrunt_way/applications/example_application/application_vars.yml).

All `API calls` are logged and written to the `S3 bucket`.  

Modifications(deletions/updates) to the `S3 bucket` objects and `Lambda` functions are tracked as well.  

If you don't have enough time to wait until `CloudTrail` puts logs into the `S3 bucket`, you can monitor the `API usage` in near real-time using `CloudWatch Log groups` by selecting the created `Log group` and created `Log stream`.  

Also, you can receive an `email` notification when `CloudTrail` puts logs into the `S3 bucket. The email address to receive this notification is specified [here](../terragrunt_way/applications/example_application/application_vars.yml).