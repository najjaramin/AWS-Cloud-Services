#!/bin/bash
yum update -y
yum install -y aws-cli
mkdir -p /opt/lecafe
echo "APP_NAME=lecafe" > /opt/lecafe/config.env
