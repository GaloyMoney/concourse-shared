#!/bin/bash

set -eu

# compress the repo in a tarball
timestamp=$(date +%Y%m%d%H%M%S)

tar -czf "blink-git-repo-${timestamp}.tar.gz" blink-git-repo 

# initilised the gcloud sdk

# gcloud_init
# gcloud storage cp "blink-git-repo-${timestamp}.tar.gz" gs://${bucket-name}

# cleanup step
rm "blink-git-repo-${timestamp}.tar.gz"