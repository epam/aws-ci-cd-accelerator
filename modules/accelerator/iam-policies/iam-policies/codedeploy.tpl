{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"kms:DescribeKey",
                "kms:GenerateDataKey",
                "kms:Encrypt",
                "kms:Decrypt"
			],
			"Resource": "${AwsKmsKey}"
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
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": [
                "${ArtifactBucket}",
                "${ArtifactBucket}/*",
                "${StorageBucket}",
                "${StorageBucket}/*"
            ]
        }
    ]
}