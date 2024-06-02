#!/bin/bash

set -eu

CI_ROOT=$(pwd)

cat <<EOF > ${CI_ROOT}/gcloud-creds.json
${GOOGLE_CREDENTIALS}
EOF

gcloud auth activate-service-account --key-file ${CI_ROOT}/gcloud-creds.json

# compress the repo in a tarball
timestamp=$(date +%Y%m%d%H%M%S)
backup_name="${BACKUP_REPO_NAME}-${timestamp}.tar.gz"
tar -czf "${backup_name}" ${BACKUP_REPO_NAME}

gcloud storage cp "${backup_name}" gs://${GOOGLE_BUCKET_NAME}

# cleanup step
rm "${backup_name}"