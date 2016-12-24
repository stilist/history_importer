#!/usr/bin/env bash

# @see http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

if [ -z "$HISTORY_DATA_PATH" ] ; then
  exit 1
fi
mkdir -p "$HISTORY_DATA_PATH"

pushd ./languages
for file in ./*.sh ; do
  [ -r "$file" ] && [ -f "$file" ] && . "$file"
done
unset file
popd

. ./support/git.sh
