#!/bin/bash

set -eu

export prev_ref=$(cat refs/prev)
export new_ref=$(cat refs/new)

pushd source-repo

cat <<EOF >> ../body.md
# Bump Shared Tasks

Code diff being added is for the following change in `concourse-shared`:

https://github.com/GaloyMoney/concourse-shared/compare/${prev_ref}...${new_ref}

EOF

gh pr close ${PR_BRANCH} || true
gh pr create \
  --title "chore(tasks): bump shared tasks" \
  --body-file ../body.md \
  --base ${BRANCH} \
  --head ${PR_BRANCH} \
  --label galoybot \
  --label shared-tasks
