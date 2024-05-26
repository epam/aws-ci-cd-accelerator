#!/usr/bin/env bash

apt-get install /opt/install/*.deb -y --allow-downgrades
rm -rf ./install
