#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'
pushd "$HISTORY_DATA_PATH"

git rev-parse --is-inside-work-tree &>/dev/null || exit 1

current_branch="$(git symbolic-ref --quiet --short HEAD)"
git pull --rebase origin "$current_branch"

oldest_ref="$(git rev-list --max-parents=0 HEAD)"
# Find files larger than ten megabytes.
large_files="$(find ./data -type f -size +10M)"
for file in $large_files ; do
  # 15th-most-recent commit to `$file`.
  nth_recent_commit="$(git log --max-count=10 --pretty=%H -- "$file" | tail -n1)"
  revision_count="$(git log $oldest_ref..$nth_recent_commit -- "$file" --pretty=%h | wc -l | xargs)"

  echo "$file"
  echo "$oldest_ref..$nth_recent_commit"
  echo "   * Removing $revision_count revisions of $file ($oldest_ref..$nth_recent_commit)"

  # Create a temporary branch to filter
  # @see http://stackoverflow.com/a/15256575/672403
  git branch filtered "$nth_recent_commit"

  # @see https://help.github.com/articles/remove-sensitive-data/
  git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch $file" \
  --prune-empty --tag-name-filter cat "$oldest_ref..filtered"

  git rebase filtered
  git branch --delete filtered
done

git lfs prune --verify-remote --verbose
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now

echo "If you're satisfied with the result, run 'git push origin --force --all'"

cleanup () {
  git branch --delete filtered --force
}
trap cleanup EXIT
