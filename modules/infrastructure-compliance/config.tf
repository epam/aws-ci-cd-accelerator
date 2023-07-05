
#-----Hardcoded due to the existance of the role, since it was created before it's not possible to recreate it using terraform-----#

resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "config-recorder"

  role_arn = aws_iam_role.config.arn

  recording_group {
    include_global_resource_types = true
  }
}

resource "aws_iam_role" "config" {
  name = "AwsConfig-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "config" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
  role       = aws_iam_role.config.name
}
#-----------------------------------------------------------------------------------------------------------------------------------#

resource "aws_config_delivery_channel" "config_recorder_delivery_channel" {
  depends_on = [aws_config_configuration_recorder.config_recorder]

  name           = "config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_recorder.id
  sns_topic_arn = aws_sns_topic.notif.arn
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
}

resource "aws_config_configuration_recorder_status" "recorder_status" {
  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.config_recorder_delivery_channel]
}

resource "aws_s3_bucket" "config_recorder" {
  bucket = "config-recorder-${local.account_id}-${var.region}"
  force_destroy = var.force_destroy
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.cloudtrail_kms_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  versioning {
    enabled = var.versioning
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.config_recorder.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "config" {
  bucket = aws_s3_bucket.config_recorder.id

  rule {
    id     = "log"
    status = "Enabled"

#    expiration {
#      days = 90
#    }
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_acl" "versioning_config_bucket_acl" {
  bucket = aws_s3_bucket.config_recorder.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "config" {
  bucket = aws_s3_bucket.config_recorder.id
  policy = data.aws_iam_policy_document.config_recorder.json
}

data "aws_iam_policy_document" "config_recorder" {
  statement {
    sid = "DenyUnsecuredTransport"
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    condition {
      test = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "true",
      ]
    }

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    resources = [
      aws_s3_bucket.config_recorder.arn,
      "${aws_s3_bucket.config_recorder.arn}/*",
    ]
  }
}

#-----------------------# RULES #------------------------------#
resource "aws_config_config_rule" "linux-ec2-application-required" {
  name = "Linux-EC2-managedinstance-applications-required"
  source {
    owner = "AWS"
    source_identifier = "EC2_MANAGEDINSTANCE_APPLICATIONS_REQUIRED"
  }
  input_parameters = "{\"platformType\": \"Linux\", \"applicationNames\": \"Qualys Cloud Security Agent\"}"
}

resource "aws_config_config_rule" "windows-ec2-application-required" {
  name = "Windows-EC2-managedinstance-applications-required"
  source {
    owner = "AWS"
    source_identifier = "EC2_MANAGEDINSTANCE_APPLICATIONS_REQUIRED"
  }
  input_parameters = "{\"platformType\": \"Windows\", \"applicationNames\": \"Qualys Cloud Security Agent\"}"
}

resource "aws_config_config_rule" "ec2-managed-by-ssm" {
  name = "EC2-instances-managed-by-SSM"
  source {
    owner = "AWS"
    source_identifier = "EC2_INSTANCE_MANAGED_BY_SSM"
  }
}

resource "aws_config_config_rule" "root_account_mfa_enabled" {
  name = "root_account_mfa_enabled"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "s3_versioning" {
  name = "s3_bucket_versioning_enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  name = "s3_bucket_public_read_prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "s3_bucket_public_write_prohibited" {
  name = "s3_bucket_public_write_prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "s3_bucket_server_side_encryption_enabled" {
  name = "s3_bucket_server_side_encryption_enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}

resource "aws_config_config_rule" "instances_in_vpc" {
  name = "instances_in_vpc"

  source {
    owner             = "AWS"
    source_identifier = "INSTANCES_IN_VPC"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}
resource "aws_config_config_rule" "encrypted_volumes" {
  name = "encrypted_volumes"

  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}
resource "aws_config_config_rule" "incoming_ssh_disabled" {
  name = "incoming_ssh_disabled"

  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}
#----Incoming SSH disabled remediation rule----#
resource "aws_config_remediation_configuration" "incoming_ssh" {
  config_rule_name = aws_config_config_rule.incoming_ssh_disabled.name
  target_type      = "SSM_DOCUMENT"
  target_id        = "AWS-DisableIncomingSSHOnPort22"
  target_version   = "1"

  parameter {
    name           = "SecurityGroupIds"
    resource_value = "RESOURCE_ID"
  }
}


resource "aws_config_config_rule" "iam_password_policy" {
  name = "iam_password_policy"

  source {
    owner             = "AWS"
    source_identifier = "IAM_PASSWORD_POLICY"
  }

  input_parameters = <<EOF
{
  "RequireUppercaseCharacters" : "true",
  "RequireLowercaseCharacters" : "true",
  "RequireSymbols" : "true",
  "RequireNumbers" : "true",
  "MinimumPasswordLength" : "16",
  "PasswordReusePrevention" : "12",
  "MaxPasswordAge" : "30"
}
EOF

  depends_on = [aws_config_configuration_recorder.config_recorder]
}