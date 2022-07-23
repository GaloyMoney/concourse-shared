#!/bin/bash

set -eu

pushd repo
export ref=$(git rev-parse HEAD)
popd

pushd source-repo

cp ../../repo/vendir.tmpl.yml ./ci/vendir.yml
sed -i "s/ref:.*/ref: ${ref}/g" vendir.yml

pushd ci
vendir sync
popd

if [[ -f ./yarn.lock ]]; then
  mkdir -p ./.github/workflows
  cp ./ci/vendor/actions/nodejs-*.yml ./.github/workflows/
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
