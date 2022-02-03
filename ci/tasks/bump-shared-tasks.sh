#!/bin/bash

set -eu

pushd repo
export ref=$(git rev-parse HEAD)
popd

pushd source-repo/ci

cat vendir.yml | grep -oEi 'ref: (.*)' | head -n 1 | cut -d' ' -f 2 > ../refs/prev
echo $ref > ../refs/new

sed -i "s/ref:.*/ref: ${ref}/g" vendir.yml

vendir sync

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
  git commit -m "chore(tasks): Bump shared tasks"
)
