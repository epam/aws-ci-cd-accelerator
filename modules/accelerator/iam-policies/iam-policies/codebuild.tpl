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
            "${StorageBucket}",
            "${StorageBucket}/*"
          ],
          "Effect": "Allow"
        },
		{
			"Effect": "Allow",
			"Action": [
			    "logs:CreateLogStream",
			    "logs:PutLogEvents"
			],
			"Resource": "arn:aws:logs:${REGION}:${ACCOUNT}:log-group:/aws/codebuild/${REPO_NAME}-*"
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
            "Resource": [
                "arn:aws:codebuild:${REGION}:${ACCOUNT}:project/${REPO_NAME}-*",
                "arn:aws:codebuild:${REGION}:${ACCOUNT}:report-group/${REPO_NAME}-*"
            ]
        },
		{
			"Effect": "Allow",
			"Action": [
                "ssm:GetParameters",
                "ssm:GetParameter"
			],
			"Resource": "arn:aws:ssm:${REGION}:${ACCOUNT}:*"
		},
		{
            "Effect" : "Allow",
            "Action" : [
                "secretsmanager:GetSecretValue"
            ],
            "Resource" : "arn:aws:secretsmanager:${REGION}:${ACCOUNT}:secret:*"
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "kms:Decrypt"
            ],
            "Resource" : "arn:aws:kms:${REGION}:${ACCOUNT}:key/*"
        },
		{
            "Sid":"GetAuthorizationToken",
            "Effect":"Allow",
            "Action":[
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
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
            "Resource": "arn:aws:ecr:${REGION}:${ACCOUNT}:repository/${REPO_NAME}"
        },
        {
            "Action": [
                "codecommit:GitPull"
            ],
            "Resource": "arn:aws:codecommit:${REGION}:${ACCOUNT}:${REPO_NAME}",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": [
                "arn:aws:codestar-connections:${REGION}:${ACCOUNT}:connection/*",
                "arn:aws:codeconnections:${REGION}:${ACCOUNT}:connection/*"
            ]
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
            "Resource": "arn:aws:codeartifact:${REGION}:${ACCOUNT}:repository/${PROJECT}/${REPO_NAME}"
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
