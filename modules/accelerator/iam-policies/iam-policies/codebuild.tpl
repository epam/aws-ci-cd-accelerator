{
	"Version": "2012-10-17",
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
            "${ArtifactBucket}/*",
            "${StorageBucket}",
            "${StorageBucket}/*"
          ],
          "Effect": "Allow"
        },
		{
			"Effect": "Allow",
			"Action": [
				"kms:DescribeKey",
                "kms:GenerateDataKey*",
                "kms:Encrypt",
                "kms:ReEncrypt*",
                "kms:Decrypt"
			],
			"Resource": "${AwsKmsKey}"
		},
		{
			"Effect": "Allow",
			"Action": [
			    "logs:CreateLogStream",
			    "logs:PutLogEvents"
			],
			"Resource": "arn:aws:logs:${Region}:${Account}:log-group:/aws/codebuild/${RepoName}-*"
		},
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameters"
            ],
            "Resource": "*"
        },
		{
			"Effect": "Allow",
			"Action": ["ssm:GetParameters","ssm:GetParameter","ssm:GetParametersByPath"],
			"Resource": "arn:aws:ssm:${Region}:${Account}:parameter/*"
		},
		{
            "Sid":"GetAuthorizationToken",
            "Effect":"Allow",
            "Action":[
                "ecr:GetAuthorizationToken"
            ],
            "Resource":"*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:PutImage"
            ],
            "Resource": "arn:aws:ecr:${Region}:${Account}:repository/${ECR}"
        },
        {
            "Action": [
                "codecommit:GitPull"
            ],
            "Resource": "arn:aws:codecommit:${Region}:${Account}:${RepoName}",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
            "codeartifact:List*",
            "codeartifact:Describe*",
            "codeartifact:Get*",
            "codeartifact:Read*",
            "codeartifact:GetAuthorizationToken",
            "codeartifact:PublishPackageVersion",
            "codeartifact:PutPackageMetadata",
            "codeartifact:ReadFromRepository",
            "codeartifact:GetRepositoryEndpoint"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "sts:GetServiceBearerToken",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "sts:AWSServiceName": "codeartifact.amazonaws.com"
                }
            }
        }
    ]
}