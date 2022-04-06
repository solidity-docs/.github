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
echo "::set-output name=branch_name::$sync_branch"

# check if sync branch exists
if git ls-remote --exit-code --heads origin "$sync_branch"
then
    branch_exists=true
    echo "sync_branch $sync_branch exists"
else
    branch_exists=false
    echo "sync_branch $sync_branch does not exist"
fi

echo "::set-output name=branch_exists::$branch_exists"

# pull from ethereum/solidity develop
git pull english develop --rebase=false --squash || true

# unstage everything
git rm -r --cached .

# stage only selected files / directories
git add docs/*

# remove untracked files
git clean -d --force --exclude=.gitignore --exclude=README.md
