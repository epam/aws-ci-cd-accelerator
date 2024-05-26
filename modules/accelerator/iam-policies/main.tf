#======================= IAM for CodePipeline =======================#
locals {
  stage_regions = [for stage in keys(var.stages) : var.stages[stage].regions]
  regions       = [for region in distinct(flatten(local.stage_regions)) : region]
  buckets       = [for region in local.regions : "${var.artifact_bucket_prefix}-${var.repo_name}-${region}"]
}

data "aws_iam_policy_document" "codepipeline_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "Codepipeline-${var.repo_name}-${var.region_name}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_policy.json
}

# CodePipeline policy needed to use CodeCommit and CodeBuild
data "template_file" "codepipeline_policy_template" {
  template = file("${path.module}/iam-policies/codepipeline.tpl")
  vars = {
    REGION    = var.region
    ACCOUNT   = var.aws_account_id
    REPO_NAME = var.repo_name

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

data "aws_iam_policy_document" "codebuild_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "Codebuild-${var.repo_name}-${var.region_name}"
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
resource "aws_iam_role_policy_attachment" "policy_attach_vpc" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy_vpc.arn
}

data "template_file" "codebuild_policy_template" {
  template = file("${path.module}/iam-policies/codebuild.tpl")
  vars = {
    StorageBucket = var.service_bucket_arn
    REGION        = var.region
    ACCOUNT       = var.aws_account_id
    PROJECT       = var.project
    REPO_NAME     = var.repo_name
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

resource "aws_iam_policy" "s3_artifact_policy" {
  name        = "S3BucketAccessPolicy-${var.repo_name}-${var.region_name}"
  description = "Policy to grant access to several S3 buckets with region-specific names"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetBucketAcl",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetReplicationConfiguration",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        "Resource" : flatten([
          [for bucket in local.buckets : "arn:aws:s3:::${bucket}"],
          [for bucket in local.buckets : "arn:aws:s3:::${bucket}/*"]
        ])
      },
      {
        "Action" : [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_bucket_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.s3_artifact_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_bucket_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.s3_artifact_policy.arn
}
