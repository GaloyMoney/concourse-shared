#!/bin/bash

set -eu

pushd repo
export ref=$(git rev-parse HEAD)
popd

pushd source-repo

mkdir -p ci
sed "s/ref:.*/ref: ${ref}/g" ../repo/vendir.tmpl.yml > ./ci/vendir.yml

echo $FEATURES | jq -c '.[]' | while read feat; do
  sed -i "/\b\($feat-\*\)\b/d" ./ci/vendir.yml
done

cat vendir.yml
exit 0

pushd ci
vendir sync
popd

mkdir -p ./.github/workflows
if [[ -f ./yarn.lock ]]; then
  cp ./ci/vendor/actions/nodejs-*.yml ./.github/workflows/
  # exclude audit from main backend
  if [[ -f ./.github/workflows/audit.yml ]]; then
    rm ./.github/workflows/nodejs-audit.yml
  fi
  cp ./ci/vendor/nodejs-dependabot.yml ./.github/dependabot.yml
fi

if [[ -f ./Cargo.toml ]]; then
  cp ./ci/vendor/rust-dependabot.yml ./.github/dependabot.yml
fi

cp ./ci/vendor/actions/spelling.yml ./.github/workflows
if [[ ! -f ./typos.toml ]]; then
  touch typos.toml
fi

if [[ -f ./docker-compose.yml ]]; then
  # exclude galoy repo
  if [[ ! -f .github/workflows/integration-test.yml ]]; then
    cp ./ci/vendor/actions/test-integration.yml ./.github/workflows
  fi
fi

if [[ -z $(git config --global user.email) ]]; then
  git config --global user.email "bot@galoy.io"
fi
if [[ -z $(git config --global user.name) ]]; then
  git config --global user.name "CI Bot"
fi

(
  cd $(git rev-parse --show-toplevel)
  git add -A
  git status
  git commit -m "ci(shared): bump vendored ci files"
)
