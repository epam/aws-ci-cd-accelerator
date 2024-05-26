{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"kms:Decrypt",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
			],
			"Resource": "*",
			"Condition": {
                "StringEquals": {
                    "kms:ViaService": "s3.${REGION}.amazonaws.com"
                }
            }
		},
        {
            "Action": [
               "s3:GetObject",
               "s3:GetBucketAcl",
               "s3:GetObjectVersion",
               "s3:GetBucketVersioning",
               "s3:GetBucketLocation",
               "s3:ListBucket",
               "s3:GetReplicationConfiguration",
               "s3:GetObjectVersionForReplication",
               "s3:GetObjectVersionAcl",
               "s3:GetObjectVersionTagging"
            ],
            "Effect": "Allow",
            "Resource": [
                "${ArtifactBucket}/*",
                "${ArtifactBucket}"
            ]
        },
        {
			"Effect": "Allow",
			"Action": [
				"codedeploy:*"
			],
			"Resource": [
                "arn:aws:codedeploy:${REGION}:${AWS_ACCOUNT_ID}:application:${REPO_NAME}",
                "arn:aws:codedeploy:${REGION}:${AWS_ACCOUNT_ID}:deploymentgroup:${REPO_NAME}/${REPO_NAME}-${ENV}",
                "arn:aws:codedeploy:${REGION}:${AWS_ACCOUNT_ID}:deploymentconfig:*",
                "arn:aws:codedeploy:${REGION}:${AWS_ACCOUNT_ID}:deployment:*"
			]
		},
		{
            "Action": [
                "ecs:RegisterTaskDefinition",
                "ecs:DeregisterTaskDefinition",
                "ecs:DescribeTaskDefinition",
                "ecs:ListTaskDefinitions"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        },
        {
            "Action": [
                "iam:PassRole"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": [
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "*"
        }
    ]
}
