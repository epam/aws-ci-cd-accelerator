variable "project" {
  description = "Name of the project for tags and resource naming"
  type        = string
}

variable "repo_name" {
  description = "Name of the repository"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "region" {
  description = "The AWS region for the deployment"
  type        = string
}

variable "accelerator_account_id" {
  description = "The AWS account ID for the accelerator account"
  type        = string
}

#=========================== VPC =========================================
variable "vpc_create" {
  description = "Flag to specify whether the module should create a new VPC."
  type        = bool
  default     = false
}

variable "allowed_cidr_blocks" {
  description = "List of allowed CIDR blocks for access to the application"
  type        = list(string)
  default     = []
}

variable "allowed_prefix_list_ids" {
  description = "List of allowed Prefix List IDs for access to the application"
  type        = list(string)
  default     = []
}

variable "nat_prefix_list_ids" {
  description = "List of Prefix List IDs of EIPs to be attached to the NAT gateways"
  type        = list(string)
  default     = []
}

variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to use for the deployment"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to use for the deployment"
  type        = list(string)
  default     = []
}

variable "reuse_nat_ips" {
  description = "Flag to specify whether to reuse existing EIPs for the NAT gateways (requires external_nat_ip_ids)"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT gateways (used in combination with reuse_nat_ips)"
  type        = list(string)
  default     = []
}

variable "single_nat_gateway" {
  description = "Flag to specify whether to create a single shared NAT Gateway for all private networks"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Flag to specify whether to create NAT Gateways for the private networks"
  type        = bool
  default     = true
}

#================================ VPC if Exist ==========================#
variable "vpc_id" {
  description = "The ID of the existing VPC. Leave empty if creating a new VPC (vpc_create = true)"
  type        = string
}

variable "nat_security_group_id" {
  description = "The ID of the existing VPC NAT security group. Leave empty if using the VPC resource created by the module"
  type        = string
}

#================================ Route53 ====================================#
variable "route53_zone_name" {
  description = "The name of the Route53 hosted zone"
  type        = string
}

variable "dns_record_names" {
  description = "List of Route53 Record Names for Stages"
  type        = list(string)
  default     = []
}

variable "health_path" {
  description = "The health check path for the load balancer"
  type        = string
}

variable "alb_access_logs" {
  description = "Enabled ALB Access Logs"
  type        = bool
  default     = false
}
variable "environments" {
  description = "List of environment names"
  type        = list(string)
}

variable "target_type" {
  description = "The target type for the load balancer ('instance' or 'ip')"
  type        = string
}

variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "conf_all_at_once" {
  description = "Deployment configuration if desired capacity equal 1 (CodeDeployDefault.AllAtOnce)"
  type        = string
  default     = "CodeDeployDefault.AllAtOnce"
}

variable "conf_one_at_time" {
  description = "Deployment configuration if desired capacity more than 1, you can change the strategy (e.g., CodeDeployDefault.OneAtATime)"
  type        = string
  default     = "CodeDeployDefault.OneAtATime"
}

variable "codedeploy_role_arns" {
  description = "List of AWS CodeDeploy role ARNs"
  type        = list(string)
}

variable "desired_capacity" {
  description = "List of desired capacity values for instances in ASG or containers in ECS"
  type        = list(string)
}

variable "max_size" {
  description = "List of maximum capacity values for instances in ASG or containers in ECS"
  type        = list(string)
  default     = []
}

variable "min_size" {
  description = "List of minimum capacity values for instances in ASG or containers in ECS"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "Instance type for the launch template (e.g. t3.micro)"
  type        = string
  default     = "t3.micro"
}

variable "container_name" {
  description = "The name of the container to be deployed"
  default     = "application"
  type        = string
}

variable "application_port" {
  description = "Port where a loadbalanser redirects traffic"
  type        = string
}

variable "cpu" {
  description = "CPU size for a container, minimum value is 218"
  type        = number
}

variable "memory" {
  description = "Memory size for a container, minimum value is 512"
  type        = number
}

variable "artifact_bucket_prefix" {
  description = "Prefix name for an artifact bucket"
  type        = string
}

variable "accelerator_region" {
  description = "A region where AWS CodePipeline is deployed"
  type        = string
}

variable "key_service_users" {
  description = "List of AWS IAM users for KMS key service"
  type        = list(string)
  default     = []
}

variable "key_users" {
  description = "List of AWS IAM users for KMS key"
  type        = list(string)
  default     = []
}

variable "codedeploy_role_create" {
  description = "Whether the module should create an AWS CodeDeploy role"
  type        = bool
}
variable "additional_security_groups" {
  description = "Additional SG with ports for application needs"
  type        = list(string)
  default     = []
}
