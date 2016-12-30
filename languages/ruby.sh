#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

gem install bundler --no-document --user-install --conservative --minimal-deps --verbose

# Extract the Ruby version (e.g. `2.0.0`).
ruby_version="$(ruby -v | sed -E 's/^.+(([0-9]+\.?){3})p.+$/\1/')"
bundler_path="$HOME/.gem/ruby/$ruby_version/bin"

"$bundler_path/bundle" check || "$bundler_path/bundle" install --jobs 4

for file in ../importers/*.rb ; do
  [ -r "$file" ] && [ -f "$file" ] && "$bundler_path/bundle" exec ruby "$file"
done
unset file;
