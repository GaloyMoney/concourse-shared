#!/bin/bash

set -eu

pushd source-repo

cat <<EOF >> ../body.md
# Bump Shared Tasks

This PR syncs in this repository, shared CI tasks from [concourse-shared](https://github.com/GaloyMoney/concourse-shared).
EOF

gh pr close ${PR_BRANCH} || true
gh pr create \
  --title "ci(shared): bump vendored ci files" \
  --body-file ../body.md \
  --base ${BRANCH} \
  --head ${PR_BRANCH} \
  --label galoybot
