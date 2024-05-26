{
  "Statement": [
    {
        "Action": [
            "codecommit:GetBranch",
            "codecommit:GetCommit",
            "codecommit:UploadArchive",
            "codecommit:GetUploadArchiveStatus",
            "codecommit:CancelUploadArchive",
            "codecommit:GetRepository"
      ],
      "Resource": "arn:aws:codecommit:${REGION}:${ACCOUNT}:${REPO_NAME}",
      "Effect": "Allow"
    },
    {
      "Action": [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild"
      ],
      "Resource": ["arn:aws:codebuild:${REGION}:${ACCOUNT}:project/${REPO_NAME}-*"],
      "Effect": "Allow"
    },
    {
        "Effect": "Allow",
        "Action": [
            "sns:Publish"
        ],
        "Resource": [
            "arn:aws:sns:${REGION}:${ACCOUNT}:${REPO_NAME}-*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "codestar-connections:*"
        ],
        "Resource":  [
            "arn:aws:codestar-connections:${REGION}:${ACCOUNT}:connection/*",
            "arn:aws:codeconnections:${REGION}:${ACCOUNT}:connection/*"
            ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "states:StartExecution",
            "states:DescribeStateMachine",
            "states:DescribeExecution"
        ],
        "Resource": [
            "arn:aws:states:${REGION}:${ACCOUNT}:stateMachine:CanaryStateMachine_${REPO_NAME}",
            "arn:aws:states:${REGION}:${ACCOUNT}:stateMachine:CanaryStateMachine_${REPO_NAME}:*",
            "arn:aws:states:${REGION}:${ACCOUNT}:execution:CanaryStateMachine_${REPO_NAME}:*"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "iam:PassRole"
        ],
        "Resource": [
        "arn:aws:iam::${ACCOUNT}:role/Codebuild-${REPO_NAME}-*",
        "arn:aws:iam::${ACCOUNT}:role/step-function-${REPO_NAME}-role"
        ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "iam:PassRole"
        ],
        "Resource": ["*"],
        "Condition": {
            "StringEquals": {
                "iam:PassedToService": [
                    "codedeploy.amazonaws.com"
                ]
            }
        }
    }
  ],
  "Version": "2012-10-17"
}
