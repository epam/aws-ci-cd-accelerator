variable "environments" {
  description = "A list of environment names for the resources"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs in the VPC"
  type        = list(string)
}

variable "project" {
  description = "The project name"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "asg_security_groups" {
  description = "A list of security group IDs for the Auto Scaling group"
  type        = list(string)
}

variable "elb_target_group_arns" {
  description = "The Amazon Resource Name (ARN) of the Elastic Load Balancer target group"
  type        = list(string)
}

variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository (e.g., new-repo)"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type for the Auto Scaling group"
  type        = string
}

# Numbers of instances in ASG or containers in ECS
variable "desired_capacity" {
  description = "A list of desired capacity for the Auto Scaling group or ECS containers"
  type        = list(string)
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling group or ECS containers"
  type        = list(string)
}

variable "min_size" {
  description = "The minimum size of the Auto Scaling group or ECS containers"
  type        = list(string)
}

variable "artifact_bucket_prefix" {
  description = "The prefix for the artifacts bucket"
  type        = string
}
