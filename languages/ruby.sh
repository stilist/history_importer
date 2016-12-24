#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

gem list -i bundler &>/dev/null
if [ "$?" -ne "0" ] ; then
  gem install bundler --no-document --user-install
fi

bundle check || bundle install

# Extract the Ruby version (e.g. `2.0.0`).
ruby_version="$(ruby -v | sed -E 's/^.+(([0-9]+\.?){3})p.+$/\1/')"
bundler_path="$HOME/.gem/ruby/$ruby_version/bin"

for file in ../importers/*.rb ; do
  [ -r "$file" ] && [ -f "$file" ] && "$bundler_path/bundle" exec ruby "$file"
done
unset file;
