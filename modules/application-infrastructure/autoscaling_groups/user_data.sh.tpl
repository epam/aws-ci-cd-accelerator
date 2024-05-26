#!/bin/bash

apt-get update -y
apt-get install jq ruby-full ruby-webrick curl wget -y

cd /home/ubuntu
curl -s -O "https://s3.${region}.amazonaws.com/amazoncloudwatch-agent-${region}/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb"
dpkg -i -E ./amazon-cloudwatch-agent.deb

wget "https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install"
chmod +x ./install
sudo ./install auto
