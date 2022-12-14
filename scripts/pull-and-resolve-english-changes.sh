#!/bin/bash
set -euo pipefail

USERNAME="$1"
EMAIL="$2"

original_url="https://github.com/ethereum/solidity.git"
git remote add english "$original_url"

git config user.name "$USERNAME"
git config user.email "$EMAIL"

## Fetch from translated origin
git fetch english --quiet
sync_branch="sync-$(git describe --tags --always english/develop)"

# pass the hash and the branch name to action "create PR"
echo "branch_name=$sync_branch" >> "$GITHUB_OUTPUT"

# check if sync branch exists
if git ls-remote --exit-code --heads origin "$sync_branch"
then
    branch_exists=true
    echo "sync_branch $sync_branch exists"
else
    branch_exists=false
    echo "sync_branch $sync_branch does not exist"
fi

echo "branch_exists=$branch_exists" >> "$GITHUB_OUTPUT"

# Try to pull changes from the main repository. Anything changed at the same time in the translation
# and in the main repo will result in a conflict and will make the command fail. This is fine.
# We want include the conflict markers as a part of the merge commit so that they're easy to spot in the PR.
# The command will also fail if in the main repo there were modifications to files outside
# of docs/ (these files are deleted in translation repos). These are the conflicts we want to ignore.
git pull english develop --rebase=false || true

# Unstage everything without aborting the merge.
# This also "resolves" conflicts by keeping conflicted files as is including the conflict markers.
git reset .

# The only changes from the main repo that we're interested in are those in docs/ and
# CMakeLists.txt, which is parsed by our Sphinx config to determine version. Stage them.
git add docs/ CMakeLists.txt

# Reset any files seen by git as modified/deleted to the state from before the merge.
# We need this for files outside of docs/ that happen to match the path of some file that exists
# in the main repo, for example README.md or .gitignore. We do not copy these when setting up a
# translation repo but to git they look like files from the main repo that need to be synced.
files_to_reset=$(git ls-files --modified --deleted)
if [[ $files_to_reset != "" ]]; then
    # NOTE: If the file list passed to `git checkout` is empty, git aborts the merge. We don't want that.
    git ls-files --modified --deleted | xargs git checkout --
fi

# All the other files from the original merge commit are now untracked. We don't want them in the PR.
git clean -d --force
