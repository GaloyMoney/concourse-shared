#!/bin/bash

set -eu

pushd repo
export ref=$(git rev-parse HEAD)
popd

pushd source-repo

mkdir -p ci
sed "s/ref:.*/ref: ${ref}/g" ../repo/vendir.tmpl.yml > ./ci/vendir.yml

echo $FEATURES | jq -c '.[]' | while read feat_str; do
  feat=$(echo $feat_str | tr -d '"')

  # removes the features we need from excludePaths in vendir yaml
  sed -i "/\b\($feat-*\)\b/d" ./ci/vendir.yml
done

pushd ci
vendir sync

pushd vendor/tasks
rename 's/^nodejs-//' *
rename 's/^rust-//' *
rename 's/^docker-//' *
rename 's/^chart-//' *
chmod +x *
popd

popd

pushd .github/workflows
cp -r vendor/* .

rename 's/^nodejs-//' *
rename 's/^rust-//' *
rename 's/^docker-//' *
rename 's/^chart-//' *

popd

mv ci/vendor/config/*-dependabot.yml .github/dependabot.yml || true

if [[ ! -f ./typos.toml ]]; then
  touch typos.toml
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
