#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

pushd "$HISTORY_DATA_PATH"

git rev-parse --is-inside-work-tree
if [ "$?" -ne "0" ] ; then
  git init .

  # @TODO install hub
  git create history -p -d "Collected personal data"
fi

HOSTNAME="$(hostname)"
# Change e.g. `test.local` to `test`.
HOSTNAME_SHORT="${HOSTNAME%%.*}"

git add -A
git status
git commit -m "Update data (from $HOSTNAME_SHORT)"
git fetch origin master
git pull --rebase origin master
git push origin master

popd
