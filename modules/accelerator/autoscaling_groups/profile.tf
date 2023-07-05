resource "aws_iam_instance_profile" "profile" {
  name = "${var.repo_name}-${var.region_name}-profile"
  role = aws_iam_role.deploy_role.name
}

resource "aws_iam_role" "deploy_role" {
  description = "Allows EC2 instances to call AWS services on your behalf"
  name        = "${var.repo_name}-${var.region_name}-role"
  path        = "/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action : "sts:AssumeRole",
        Principal : {
          "Service" : "ec2.amazonaws.com"
        },
        Effect : "Allow",
        Sid : ""
      }
    ]
  })
}

resource "aws_iam_policy" "profile_s3_policy" {
  name_prefix = "Policy-s3-${var.repo_name}"
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
              "s3:Get*",
              "s3:List*"
          ],
          "Resource": [
              "arn:aws:s3:::${var.artifact_bucket}",
              "arn:aws:s3:::${var.artifact_bucket}/*"
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
            "Effect": "Allow",
            "Resource": "${var.aws_kms_key_arn}"
        }
    ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "s3_read" {
  role       = aws_iam_role.deploy_role.name
  policy_arn = aws_iam_policy.profile_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.deploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_agent" {
  role       = aws_iam_role.deploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}