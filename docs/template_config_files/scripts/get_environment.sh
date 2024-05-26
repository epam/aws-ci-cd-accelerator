#!/bin/bash

# Select the source: PARAMETERSTORE, SECRETSMANAGER or BOTH
SWITCH="PARAMETERSTORE"

# For the script to work correctly, do not change the value of automatic variables!
# Getting token for IMDSv2
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Getting AWS region from instance metadata
AWS_REGION=$(curl -sL -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)
# Getting environment from instance metadata
ENVIRONMENT=$(curl -sL -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/tags/instance/Environment)
# Getting repository name from instance metadata
REPO_NAME=$(curl -sL -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/tags/instance/Repo_name)

# Checking if jq utility is installed, if not - installing
if ! type jq > /dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install jq -y
fi

# Defining prefix
PREFIX="/${REPO_NAME}/${ENVIRONMENT}/"


# Fetch secrets if SWITCH is set to SECRETSMANAGER or BOTH
if [ "$SWITCH" = "SECRETSMANAGER" ] || [ "$SWITCH" = "BOTH" ]; then
  SECRETS=$(aws secretsmanager list-secrets --region ${AWS_REGION} --query 'SecretList[].[Name]' --output text | tr '\t' '\n' | grep "^${PREFIX}" | grep -v "${REPO_NAME}$" | grep -v "${ENVIRONMENT}$")

  # Processing each secret
  for SECRET in $SECRETS; do
    SECRET_VALUE=$(aws secretsmanager get-secret-value --secret-id ${SECRET} --region ${AWS_REGION} --query SecretString --output text)

    # If SECRET_VALUE is a JSON data
    if echo "${SECRET_VALUE}" | jq . > /dev/null 2>&1; then
      SECRET_VALUE_JSON=$(echo "${SECRET_VALUE}" | jq -r 'to_entries|map("\(.key)=\(.value)")|.[]')
      for ENTRY in ${SECRET_VALUE_JSON}; do
        KEY=$(echo "${ENTRY}" | cut -d'=' -f1)
        VALUE=$(echo "${ENTRY}" | cut -d'=' -f2)

        if [ -n "${KEY}" ]; then
         echo "${KEY}=${VALUE}"
         export ${KEY}=${VALUE}
        fi
      done
    else
      echo "Failed to parse JSON for ${SECRET}: ${SECRET_VALUE}"
    fi
  done
fi

# Fetch parameters if SWITCH is set to PARAMETERSTORE or BOTH
if [ "$SWITCH" = "PARAMETERSTORE" ] || [ "$SWITCH" = "BOTH" ]; then
  PARAMS=$(aws --region=${AWS_REGION} ssm describe-parameters --query "Parameters[*].[Name]" --output text | tr '\t' '\n' | grep "^${PREFIX}")

  # Processing each PARAMETER
  for PARAM in $PARAMS; do
    PARAM_VALUE=$(aws --region=${AWS_REGION} ssm get-parameters --name "$PARAM" --with-decryption --output text --query "Parameters[*].{Value:Value}")
    PARAM_NAME=$(echo $PARAM | rev | cut -d'/' -f1 | rev)
    if echo "$PARAM_VALUE" | jq . >/dev/null 2>&1; then
      PARAM_VALUE_JSON=$(echo "${PARAM_VALUE}" | jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]')
      for ENTRY in ${PARAM_VALUE_JSON}; do
        KEY=$(echo "${ENTRY}" | cut -d'=' -f1)
        VALUE=$(echo "${ENTRY}" | cut -d'=' -f2)

        if [ -n "${KEY}" ]; then
          echo "${KEY}=${VALUE}"
          export ${KEY}=${VALUE}
        fi
      done
    else
      echo "$PARAM_NAME=$PARAM_VALUE"
      export "$PARAM_NAME=$PARAM_VALUE"
    fi
  done
fi
