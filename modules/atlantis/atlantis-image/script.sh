#!/usr/bin/env bash

echo $AWS_PROFILE

aws ecr get-login-password --region "${region}" | docker login --username AWS --password-stdin "${aws_account_id}.dkr.ecr.${region}.amazonaws.com"
export DOCKER_BUILDKIT=1
docker build -t atlantis ./atlantis-image/
docker tag atlantis:latest "${aws_account_id}.dkr.ecr.${region}.amazonaws.com/atlantis:latest"
docker push "${aws_account_id}.dkr.ecr.${region}.amazonaws.com/atlantis:latest"