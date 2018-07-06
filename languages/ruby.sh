#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

set +e
gem list bundler --installed --silent
if [ "$?" -eq "1" ] ; then
  gem install bundler --conservative --minimal-deps --no-document --user-install --verbose
fi
set -e

# `ruby --version` outputs something like:
#
#   ruby 2.0.0p648 (2015-12-16 revision 53162) [universal.x86_64-darwin16]
#
# The `sed` expression outputs just the version number without the patch number:
#
#   2.0.0
#
# This is part of the path rubygems uses when gems are installed with
# `gem install --user-install`.
ruby_version="$(ruby -v | sed -E 's/^.+(([0-9]+\.?){3})p.+$/\1/')"
bundler_path="$HOME/.gem/ruby/$ruby_version/bin"

"$bundler_path/bundle" check || "$bundler_path/bundle" install --jobs 4 --path vendor/bundle

for file in ../importers/*.rb ; do
  [ -r "$file" ] && [ -f "$file" ] && "$bundler_path/bundle" exec ruby "$file"
done
unset file;
