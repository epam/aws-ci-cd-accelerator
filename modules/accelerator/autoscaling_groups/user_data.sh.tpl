#!/bin/bash

apt-get update -y

apt-get install jq ruby-full ruby-webrick curl -y

cd /home/ubuntu
curl -sO "https://s3.${region}.amazonaws.com/amazoncloudwatch-agent-${region}/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb"

dpkg -i -E ./amazon-cloudwatch-agent.deb

curl -sO "https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install"

chmod +x ./install

sudo ./install auto