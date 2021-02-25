#!/bin/bash
set -euo pipefail

deployment_environment=${1}

if [ -z "${deployment_environment}" ]; then
    echo "Directory is not set or is empty"
    exit 1
fi

full_path=${GITHUB_WORKSPACE}/helm/environments/${deployment_environment}

if [ ! -d "${full_path}" ]; then
    echo "Deployment environment ${deployment_environment} does not exist in ${GITHUB_WORKSPACE}"
    exit 1
fi

cd ${full_path}

echo "Decrypting ${full_path}/secrets.yaml"
echo "[${deployment_environment}]" >> ~/.aws/credentials
echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >> ~/.aws/credentials
echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" >> ~/.aws/credentials
echo "region = ${AWS_DEFAULT_REGION}" >> ~/.aws/credentials
echo "role_arn = ${AWS_ROLE_NAME}" >> ~/.aws/credentials
sops --aws-profile ${deployment_environment} -d "${full_path}/secrets.yaml" > $(basename "${full_path}/secrets.yaml.dec")
