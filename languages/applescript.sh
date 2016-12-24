#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

which osascript
if [ "$?" -eq "0" ] ; then
  for file in ../importers/*.sh ; do
    [ -r "$file" ] && [ -f "$file" ] && osascript -l JavaScript -s o "$file"
  done
  unset file
fi
