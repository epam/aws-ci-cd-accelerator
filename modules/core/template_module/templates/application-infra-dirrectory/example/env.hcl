# Set common variables for the environment. This is automatically pulled in the root terragrunt.hcl configuration to
# feed forward to the child modules.

locals {
  ##=========================== Core Block ===========================##
  accelerator_account_id     = "" # AWS account ID
  accelerator_region         = "" # Main AWS region of the project
  repo_name                  = "${repo_name}" # Git repository name
  ecr_repo_name              = local.repo_name # AWS ECR repository name
  environments               = split("-", "${environments}") # Environments for pipeline
  vpc_create                 = false # Create your own VPC, or use an existing one (true/false)
  vpc_id                     = "" # ID for VPC (If vpc_create = false)
  nat_security_group_id      = "" # ID for NAT security group (If vpc_create = false)
  public_subnet_ids          = [] # ID for Public subnet
  private_subnet_ids         = [] # ID for Private subnet
  enable_nat_gateway         = true # Providing NAT gateways for each private network (If vpc_create = true)
  single_nat_gateway         = true # Providing a single shared NAT Gateway across all private networks (If vpc_create = true)
  reuse_nat_ips              = false # Prevent the creation of EIP for NAT gateways. Instead, EIPs will be passed through the external_nat_ip_ids variable. (If vpc_create = true)
  ##=========================== Application infrastructure Block ===========================##
  cpu                        = 256 # CPU for ECS tasks
  memory                     = 512 # Memory for ECS tasks.
  instance_type              = "t3.micro" # The instance type for EC2 deployment
  desired_capacity           = ["1"] # Desired capacity for AutoScaling, ECS, or EKS deployment (per stage)
  min_size                   = ["1"] # Minimal capacity for AutoScaling, ECS, or EKS deployment (per stage)
  max_size                   = ["1"] # Maximal capacity for AutoScaling, ECS, or EKS deployment (per stage)
  application_port           = "" # Application Port
  health_path                = "" # Path for LoadBalancer Health Check
  target_type                = "" # "instance", "ip", "eks", or "kube_cluster"
  alb_access_logs            = false # ALB access logging turn on/off
  route53_zone_name          = "" # Route53 Zone Record Name
  dns_record_names           = [] # DNS Records for each stage
  allowed_cidr_blocks        = [] # Cidr Blocks to be allowed access to Application through LoadBalancer
  allowed_prefix_list_ids    = [] # Prefix List IDs to be allowed access to Application through LoadBalancer
  additional_security_groups = [] # Additional SG for ECS Service or ASG
  ##=========================== CodeDeploy Block ===========================##
  codedeploy_role_create = true # If we deploy the same infrastructure in a second region, set false
}
