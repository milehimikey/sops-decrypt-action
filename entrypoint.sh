#!/bin/bash
set -euo pipefail

secrets_directory=${1}

if [ -z "${secrets_directory}" ]; then
    echo "Directory is not set or is empty"
    exit 1
fi

full_path=${GITHUB_WORKSPACE}/helm/environments/${secrets_directory}

if [ ! -d "${full_path}" ]; then
    echo "Directory ${secrets_directory} does not exist in ${GITHUB_WORKSPACE}"
    exit 1
fi

cd ${full_path}

echo "Decrypting ${full_path}/secrets.yaml"
AWS_PROFILE=${secrets_directory} sops -d "${full_path}/secrets.yaml" > $(basename "${full_path}/secrets.yaml.dec")
