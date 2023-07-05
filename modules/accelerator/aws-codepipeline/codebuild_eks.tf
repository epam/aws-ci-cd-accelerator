resource "aws_cloudwatch_log_group" "eks" {
  count             = var.target_type == "eks" || var.target_type == "kube_cluster" ? length(var.environments) : 0
  name              = "/aws/codebuild/${var.repo_name}-${var.region_name}-eks-${var.environments[count.index]}"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}

resource "aws_codebuild_project" "build_deploy_to_eks" {
  count          = var.target_type == "eks" || var.target_type == "kube_cluster" ? length(var.environments) : 0
  name           = "${var.repo_name}-${var.region_name}-eks-${var.environments[count.index]}"
  description    = "The CodeBuild project for deploying to EKS."
  service_role   = var.codebuild_role
  build_timeout  = var.build_timeout
  encryption_key = var.aws_kms_key
  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = "LINUX_CONTAINER"
    privileged_mode = var.build_privileged_override

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }
    environment_variable {
      name  = "AWS_CLUSTER_REGION"
      value = var.cluster_region
    }
    environment_variable {
      name  = "REPO_NAME"
      value = var.repo_name
    }
    environment_variable {
      name  = "CLUSTER_NAME"
      value = var.cluster_name
    }
    environment_variable {
      name  = "EKS_ROLE_ARN"
      value = var.eks_role_arn
    }
    environment_variable {
      name  = "ENVIRONMENT"
      value = var.environments[count.index]
    }
    environment_variable {
      name  = "SUBNETS"
      value = join("\\, ", var.cluster_public_subnet_ids)
    }
    environment_variable {
      name  = "SECURITY_GROUPS"
      value = join("\\, ", var.cluster_security_groups)
    }
    environment_variable {
      name  = "HEALTH_PATH"
      value = var.health_path
    }
    environment_variable {
      name  = "TARGET_PORT"
      value = var.target_port
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.image_repo_name
    }
    environment_variable {
      name  = "REPLICAS"
      value = var.desired_capacity[count.index]
    }
    environment_variable {
      name  = "CERTIFICATE_ARN"
      value = var.cluster_acm_certificate_arn
    }
    environment_variable {
      name  = "HELM_CHART"
      value = var.helm_chart
    }
    environment_variable {
      name  = "HELM_CHART_VERSION"
      value = var.helm_chart_version
    }
    environment_variable {
      name  = "DOCKER_REPO_PS"
      value = var.docker_repo
    }
    environment_variable {
      name  = "DOCKER_PASSWORD_PS"
      value = var.docker_password
    }
    environment_variable {
      name  = "DOCKER_USER_PS"
      value = var.docker_user
    }
    environment_variable {
      name  = "KUBECONFIG_NAME"
      value = var.cluster_config
    }
    environment_variable {
      name  = "APP_FQDN"
      value = var.app_fqdn[count.index]
    }
  }
  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = var.security_groups
  }
  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.eks[0].name
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_eks
  }
}

#========================================= ECR Repo ===========================================#
resource "aws_ecr_repository" "ecr-repo" {
  count                = var.target_type == "eks" || var.target_type == "kube_cluster" ? 1 : 0
  name                 = "${var.repo_name}-${var.region_name}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

resource "aws_ecr_repository_policy" "ecr_repository_policy" {
  count      = var.target_type == "eks" || var.target_type == "kube_cluster" ? 1 : 0
  repository = aws_ecr_repository.ecr-repo[0].name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "ecr_image_policies" {
  count      = var.target_type == "eks" || var.target_type == "kube_cluster" ? 1 : 0
  repository = aws_ecr_repository.ecr-repo[0].name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep last 10 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}