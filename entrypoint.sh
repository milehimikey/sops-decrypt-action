#!/bin/bash
set -euo pipefail

secrets_directory=${1}

if [ -z "${secrets_directory}" ]; then
    echo "Directory is not set or is empty"
    exit 1
fi

full_path=${GITHUB_WORKSPACE}/${secrets_directory}

if [ ! -d "${full_path}" ]; then
    echo "Directory ${secrets_directory} does not exist in ${GITHUB_WORKSPACE}"
    exit 1
fi

cd ${full_path}

echo "Decrypting ${encrypted_secret_file}"
sops -d "${encrypted_secret_file}" > $(basename "${encrypted_secret_file}.dec")
