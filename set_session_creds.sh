#!/usr/bin/env bash

set -e -x

[ -z $1 ] && (echo "base aws profile must be set"; exit 1)
[ -z $2 ] && (echo "mfa device arn must be set"; exit 1)
[ -z $3 ] && (echo "mfa code must be set"; exit 1)

export AWS_DEFAULT_PROFILE=${1}
AWS_TEMP_PROFILE=${1}-session
creds=$(aws sts get-session-token --serial-number ${2} --token-code ${3})

aws configure set aws_access_key_id $(echo $creds | jq -r .Credentials.AccessKeyId) --profile ${AWS_TEMP_PROFILE}
aws configure set aws_secret_access_key $(echo $creds | jq -r .Credentials.SecretAccessKey) --profile ${AWS_TEMP_PROFILE}
aws configure set aws_session_token $(echo $creds | jq -r .Credentials.SessionToken) --profile ${AWS_TEMP_PROFILE}

echo "export AWS_PROFILE=${AWS_TEMP_PROFILE}"
