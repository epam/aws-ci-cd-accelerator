#!/bin/env bash
# Script for buildspec_eks.yml
#set -ex

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

export DOCKER_IMAGE="$(cat imageDetail.json | jq  -r '.ImageURI')"
echo "Docker Image: ${DOCKER_IMAGE}"
mkdir $HOME/.kube
export PATH=$PWD/:$PATH
if [[ $CLUSTER_NAME != "" ]];
then
  curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64
  chmod +x aws-iam-authenticator
  CREDENTIALS=$(aws sts assume-role --region $AWS_REGION --role-arn $EKS_ROLE_ARN --role-session-name codebuild-kubectl --duration-seconds 900)
  export AWS_ACCESS_KEY_ID="$(echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId')"
  export AWS_SECRET_ACCESS_KEY="$(echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey')"
  export AWS_SESSION_TOKEN="$(echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken')"
  export AWS_EXPIRATION=$(echo ${CREDENTIALS} | jq -r '.Credentials.Expiration')
  aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_CLUSTER_REGION
else
  echo ${DOCKER_PASSWORD} | docker login -u $DOCKER_USER --password-stdin # Log in to Docker Registry
  echo $KUBE_CONFIG | base64 -d > $HOME/.kube/config # Get Kubeconfig from AWS Parameter Store
  docker tag $DOCKER_IMAGE "$DOCKER_REPO:$VERSION" # Tag ECR Docker Image for your Docker Registry
  docker push "$DOCKER_REPO:$VERSION" # Push to your Docker Registry
  export DOCKER_IMAGE="$DOCKER_REPO:$VERSION"
fi

export KUBECONFIG=$HOME/.kube/config

#kubectl config view
kubectl get deploy,svc,ingress -n "${REPO_NAME}-${ENVIRONMENT}"

helm repo add accelerator-charts "${HELM_CHART}"
helm repo update
helm repo list
helm search repo accelerator-charts --versions
helm upgrade -i accelerator accelerator-charts/accelerator --version "${HELM_CHART_VERSION}" --wait \
  -n "${REPO_NAME}-${ENVIRONMENT}" \
  --debug --atomic \
  --set image="${DOCKER_IMAGE}" \
  --set repo_name="${REPO_NAME}" \
  --set environment="${ENVIRONMENT}" \
  --set app_fqdn="${APP_FQDN}"
