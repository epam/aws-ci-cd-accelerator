{
  "Statement": [
    {
        "Action": [
           "s3:PutObject",
           "s3:GetObject",
           "s3:GetBucketAcl",
           "s3:GetObjectVersion",
           "s3:GetBucketVersioning",
           "s3:GetBucketLocation",
           "s3:ListBucket"
          ],
        "Resource": [
            "${ArtifactBucket}",
            "${ArtifactBucket}/*"
          ],
        "Effect": "Allow"
    },
    {
        "Action": [
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:UploadArchive",
            "codecommit:GetUploadArchiveStatus",
            "codecommit:CancelUploadArchive",
            "codecommit:GetRepository"
      ],
      "Resource": "arn:aws:codecommit:${Region}:${Account}:${RepoName}",
      "Effect": "Allow"
    },
    {
      "Action": [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild"
      ],
      "Resource": ["arn:aws:codebuild:${Region}:${Account}:project/${RepoName}-*"],
      "Effect": "Allow"
    },
    {
        "Effect": "Allow",
        "Action": [
            "codedeploy:CreateDeployment",
            "codedeploy:GetDeployment",
            "codedeploy:GetDeploymentConfig",
            "codedeploy:RegisterApplicationRevision",
            "codedeploy:GetApplication",
            "codedeploy:GetApplicationRevision",
            "sns:Publish"
        ],
        "Resource": [
            "*"
        ]
    },
    {
        "Action": [
            "kms:DescribeKey",
            "kms:GenerateDataKey*",
            "kms:Encrypt",
            "kms:ReEncrypt*",
            "kms:Decrypt"
        ],
        "Resource": "${AwsKmsKey}",
        "Effect": "Allow"
    },
    {
        "Effect": "Allow",
        "Action": [
            "codestar-connections:*"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "iam:PassRole"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ecs:DeregisterTaskDefinition",
            "ecs:RegisterTaskDefinition"
        ],
        "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}