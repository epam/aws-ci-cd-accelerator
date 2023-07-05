#!/usr/bin/env bash

creds=$(aws sts assume-role --role-arn "$CUSTODIAN_ROLE" --role-session-name "RoleSession1" --duration-seconds 900)

sleep 2
AWS_ACCESS_KEY_ID=$(echo "$creds" | jq -r .Credentials.AccessKeyId)
AWS_SECRET_ACCESS_KEY=$(echo "$creds" | jq -r .Credentials.SecretAccessKey)
AWS_SESSION_TOKEN=$(echo "$creds" | jq -r .Credentials.SessionToken)

source /home/atlantis/.venv/bin/activate
c7n configure --api_link "$C7N_API"
c7n login --username "$C7N_USER" --password "$C7N_PASSWORD"

JOB_ID=$(c7n job submit aws -acc "$ACCOUNT_NAME" -trs FULL_AWS -ak "$AWS_ACCESS_KEY_ID" -sk "$AWS_SECRET_ACCESS_KEY" -st "$AWS_SESSION_TOKEN" -df "$AWS_REGION" --json | jq -r ".items[0].job_id")
echo "$JOB_ID"

while  true; do
  STATUS=$(c7n job describe --job_id "$JOB_ID" --json | jq -r ".items[0].status")
  if [ "$STATUS" = "SUCCEEDED" ];
    then  echo "$STATUS"; break
  else echo "$STATUS"; sleep 30
  fi
done

c7n report job --job_id "$JOB_ID"
c7n report push dojo -id "$JOB_ID"
deactivate