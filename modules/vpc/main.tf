## VPC, Security Groups, ACM for apps and USA regions

locals {
  vcs_cidr_blocks = compact(concat( var.gitlab_user != "" ? [
    "174.128.60.0/24"
  ] : var.github_user != "" ? ["140.82.112.0/20", "185.199.108.0/22", "192.30.252.0/22", "143.55.64.0/20"] : var.bitbucket_user != "" ? [
    "13.52.5.96/28", "13.236.8.224/28", "18.136.214.96/28", "18.184.99.224/28", "18.234.32.224/28", "18.246.31.224/28",
    "52.215.192.224/28",
    "104.192.137.240/28", "104.192.138.240/28", "104.192.140.240/28", "104.192.142.240/28", "104.192.143.240/28",
    "185.166.143.240/28",
    "185.166.142.240/28"
  ] :  try(var.atlantis_cidr_blocks, [])))
}

resource "aws_vpc" "core" {
  cidr_block           = var.vpc_range
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags                 = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.core.id

  tags = {
    Name = "${var.project}-admin-igw"
  }
}

resource "aws_security_group" "application_https" {
  name        = "${var.project}-application-https"
  description = "Application security group for HTTPS access"
  vpc_id      = aws_vpc.core.id

  tags = {
    Name = "${var.project}-application-SG"
  }
  dynamic "ingress" {
    for_each = ["443"]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      prefix_list_ids = var.allowed_prefix_list_ids == [] ? null : var.allowed_prefix_list_ids
      cidr_blocks     = var.app_cidr_blocks == [] ? null : var.app_cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}
resource "aws_security_group" "application_http" {
  name        = "${var.project}-application-http"
  description = "Application security group for HTTP access"
  vpc_id      = aws_vpc.core.id

  tags = {
    Name = "${var.project}-application-SG"
  }
  dynamic "ingress" {
    for_each = ["80"]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      prefix_list_ids = var.allowed_prefix_list_ids == [] ? null : var.allowed_prefix_list_ids
      cidr_blocks     = var.app_cidr_blocks == [] ? null : var.app_cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}
resource "aws_security_group" "application_nat" {
  name        = "${var.project}-application-nat"
  description = "Application security group for HTTP and HTTPS access from NAT"
  vpc_id      = aws_vpc.core.id

  tags = {
    Name = "${var.project}-application-SG"
  }
  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      prefix_list_ids = var.nat_prefix_list_ids == [] ? null : var.nat_prefix_list_ids
      cidr_blocks     = var.enable_eip ? ["${aws_nat_gateway.nat_gw.public_ip}/32"] : null
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}
#========================== Atlantis SG ==============================#
resource "aws_security_group" "atlantis" {
  name        = "${var.project}-atlantis-sg"
  description = "Atlantis security group for HTTPS access"
  vpc_id      = aws_vpc.core.id

  tags = {
    Name = "${var.project}-atlantis-SG"
  }
  dynamic "ingress" {
    for_each = ["443"]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      prefix_list_ids = var.atlantis_prefix_list_ids == [] ? null : var.atlantis_prefix_list_ids
      cidr_blocks     = local.vcs_cidr_blocks == [] ? null : local.vcs_cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.core.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = "${var.region}${var.azs[count.index]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-${var.azs[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.core.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = "${var.region}${var.azs[count.index]}"

  tags = {
    Name = "${var.project}-private-${var.azs[count.index]}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.core.id

  tags = {
    Name = "${var.project}-admin-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.core.id

  tags = {
    Name = "${var.project}-admin-private"
  }
}

resource "aws_route" "public_rt_default_to_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_to_public_subnets" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private_rt_to_private_subnets" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat_gw_ip" {
  count = var.enable_eip  ? 1 : 0
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = var.enable_eip  ? aws_eip.nat_gw_ip[0].id : var.eip
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project}-NAT-GW"
  }
}

resource "aws_route" "public_rt_default_to_ngw" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

##========= ECR for Atlantis ======================#
resource "aws_ecr_repository" "atlantis" {
  name                 = "atlantis"
  image_tag_mutability = "MUTABLE"
  tags                 = {
    Name = "${var.project}-atlantis"
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

resource "aws_iam_policy" "tfstate_policy" {
  name_prefix = "Atlantis-Policy"
  path        = "/"
  description = "Terraform state bucket access policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
           {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [ "arn:aws:s3:::${var.tf_state_bucket}/*", "arn:aws:s3:::${var.tf_state_bucket}" ]
        }
    ]
}
EOF
}

# SSL/TLS certificate for Accelerator
module "acm" {
  source            = "../acm_certificate"
  project           = var.project
  route53_zone_name = var.route53_zone_name
}

module "acm_usa" {
  providers = {
    aws = aws.east
  }
  source            = "../acm_certificate"
  project           = var.project
  route53_zone_name = var.route53_zone_name
}