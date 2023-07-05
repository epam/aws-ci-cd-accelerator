#================= AWS CodePipeline Policies ===============================#

data "aws_iam_policy_document" "codepipeline_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
    principals {
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name_prefix        = "Codepipeline-${var.repo_name}-${var.region_name}-"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_policy.json
}

# CodePipeline policy needed to use CodeCommit and CodeBuild
data "template_file" "codepipeline_policy_template" {
  template = file("${path.module}/iam-policies/codepipeline.tpl")
  vars     = {
    AwsKmsKey          = var.aws_kms_key_arn
    ArtifactBucket     = var.build_artifact_bucket_arn
    Project            = var.project
    CodestarConnection = "${var.connection_provider}-${var.region_name}-${var.repo_name}"
    DeploymentGroup    = "${var.repo_name}-${var.region_name}"
    Application        = "${var.repo_name}-${var.region_name}"
    Region             = var.region
    Account            = var.aws_account_id
    RepoName           = var.repo_name
  }
}

resource "aws_iam_policy" "codepipeline_policy" {
  name_prefix = "Codepipeline-policy-${var.repo_name}-${var.region_name}-"
  policy      = data.template_file.codepipeline_policy_template.rendered
}
resource "aws_iam_role_policy_attachment" "codepipeline_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

# CodeBuild IAM Permissions
data "aws_iam_policy_document" "codebuild_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
    principals {
      identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name_prefix        = "Codebuild-${var.repo_name}-${var.region_name}-"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_policy.json
}

resource "aws_iam_policy" "codebuild_policy_vpc" {
  name_prefix = "Policy-vpc-${var.repo_name}-${var.region_name}-"
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterfacePermission"
            ],
            "Resource": "arn:aws:ec2:${var.region}:${var.aws_account_id}:network-interface/*",
            "Condition": {
                "StringEquals": {
                    "ec2:Subnet": [
                        "arn:aws:ec2:${var.region}:${var.aws_account_id}:subnet/${var.private_subnet_ids[0]}",
                        "arn:aws:ec2:${var.region}:${var.aws_account_id}:subnet/${var.private_subnet_ids[1]}",
                        "arn:aws:ec2:${var.region}:${var.aws_account_id}:subnet/${var.private_subnet_ids[2]}"
                    ],
                    "ec2:AuthorizedService": "codebuild.amazonaws.com"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "policy-attach-vpc" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy_vpc.arn
}

data "template_file" "codebuild_policy_template" {
  template = file("${path.module}/iam-policies/codebuild.tpl")
  vars     = {
    ArtifactBucket = var.build_artifact_bucket_arn
    StorageBucket  = var.storage_bucket_arn
    AwsKmsKey      = var.aws_kms_key_arn
    Region         = var.region
    Account        = var.aws_account_id
    Project        = var.project
    RepoName       = var.repo_name
    ECR            = "${var.repo_name}-${var.region_name}"
  }
}

resource "aws_iam_policy" "codebuild_policies" {
  name_prefix = "Codebuild-policy-${var.repo_name}-${var.region_name}-"
  policy      = data.template_file.codebuild_policy_template.rendered
}

resource "aws_iam_role_policy_attachment" "codebuild_policies" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policies.arn
}

resource "aws_iam_role_policy_attachment" "dlt" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
}

#================================== AWS Codedeploy policies ========================#
data "aws_iam_policy_document" "codedeploy_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.${var.region}.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "codedeploy_role" {
  count              = var.target_type == "ip" || var.target_type == "instance" ? 1 : 0
  name_prefix        = "Codedeploy-${var.repo_name}-${var.region_name}-"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_policy.json
}
data "template_file" "codedeploy_policy_template" {
  template = file("${path.module}/iam-policies/codedeploy.tpl")
  vars     = {
    AwsKmsKey      = var.aws_kms_key_arn
    ArtifactBucket = var.build_artifact_bucket_arn
    StorageBucket  = var.storage_bucket_arn
    Region         = var.region
    Account        = var.aws_account_id
  }
}
resource "aws_iam_policy" "codedeploy_policies" {
  count       = var.target_type == "ip" || var.target_type == "instance" ? 1 : 0
  name_prefix = "Codedeploy-policy-${var.repo_name}-${var.region_name}-"
  policy      = data.template_file.codedeploy_policy_template.rendered
}

resource "aws_iam_role_policy_attachment" "codedeploy_policies" {
  count      = var.target_type == "ip" || var.target_type == "instance" ? 1 : 0
  role       = aws_iam_role.codedeploy_role[0].name
  policy_arn = aws_iam_policy.codedeploy_policies[0].arn
}

resource "aws_iam_role_policy_attachment" "codedeploy_ecs" {
  count      = var.target_type == "ip" ? 1 : 0
  role       = aws_iam_role.codedeploy_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role_policy_attachment" "codedeploy_ec2" {
  count      = var.target_type == "instance" ? 1 : 0
  role       = aws_iam_role.codedeploy_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

#============================= ECS Policies ===========================##
data "aws_iam_policy_document" "ecs_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs_execution_role" {
  count              = var.target_type == "ip" ? 1 : 0
  name_prefix        = "Ecs-Execution-${var.region_name}-${var.repo_name}-"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
}
resource "aws_iam_role_policy_attachment" "ecs_execution" {
  count      = var.target_type == "ip" ? 1 : 0
  role       = aws_iam_role.ecs_execution_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  count              = var.target_type == "ip" ? 1 : 0
  name_prefix        = "Ecs-Task-${var.region_name}-${var.repo_name}-"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
}
#============ Put Policies for Task Role here, if you need to get access to AWS Service ==========#
##======================== Policy for EKS ===============================##
resource "aws_iam_policy" "eks" {
  count  = var.target_type == "eks" ? 1 : 0
  name   = "EKS-${var.repo_name}-${var.region_name}"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action   = ["sts:AssumeRole"]
        Effect   = "Allow"
        Resource = "${var.eks_role_arn}"
      },
      {
        Action   = ["eks:Describe*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  count      = var.target_type == "eks" ? 1 : 0
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.eks[0].arn
}