#!/bin/bash
set -euo pipefail

function title {
    echo "Sync with ethereum/solidity@$(git describe --tags --always english/develop) $(date -u +%Y-%m-%d)"
}

function pr_body {
    echo "This PR was automatically generated."
    echo
    git status --short |
        grep "docs" |
        awk '{print "- [ ] ["$2"](https://github.com/ethereum/solidity/tree/develop/"$2")"}'
    echo
    echo "Merge changes from [solidity](https://github.com/ethereum/solidity)@develop"
    echo "Please fix the conflicts by pushing new commits to this pull request, either by editing the files directly on GitHub or by checking out this branch."
    echo "## DO NOT SQUASH MERGE THIS PULL REQUEST!"
    echo "Doing so will erase the commits from main and cause them to show up as conflicts the next time we merge."
}

printf "pr_title=%s\n" "$(title)"             >> "$GITHUB_ENV"
printf "pr_body<<EOF\n%s\nEOF\n" "$(pr_body)" >> "$GITHUB_ENV"
