## Solidity Translation Bot

### Setting up the Bot
- Create a new GitHub account and set up [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
- Go to repository Settings -> Security -> Secrets -> Actions -> Repository secrets
- Create a new secret: `PAT` with Personal Access Token of a bot
- In `create-pull-request.yaml` update bot related fields:
    - `jobs.createPullRequest.env.bot_username`
    - `jobs.createPullRequest.env.bot_email`

### Adding new translation repository
The Bot requires related histories between original and translated repositories.

One way to achieve common history is to:
- clone [ethereum/solidity](https://github.com/ethereum/solidity/)
- remove everything but `docs/` directory
- remove all branches but `develop`
- create a new repository in the [solidity-docs](https://github.com/solidity-docs) organization
- grant bot write access to that repository
- push from your clone to the newly created repository

Another option would be maintaining an up-to-date `en-english` repository as a template - with only the `docs` directory.
That repository would be ready to fork and create a translation repository.
In that case, the procedure would look like this:
- `git clone --bare git@github.com:solidity-docs/en-english.git`
- create a new GitHub repository, e.g. `solidity-docs/pl-polish`
- grant bot write access to that repository
- `cd en-english && git push git@github.com:solidity-docs-test/pl-polish.git`

In either case, pull request workflow file has to be updated:
- edit `.github/workflow/create-pull-request.yaml`
- add language code to `jobs.createPullRequest.strategy.matrix.repos`

### How to transform translation repository to compatible form
Originally many or our translation repositories were created by simply copying a snapshot of
the documentation from the Solidity repository rather than by cloning it with full history.
To make them compatible with the bot, the history needs to be restored.
The following instruction shows how to do it, taking the [French translation](https://github.com/solidity-docs/fr-french/) as an example.

1. Clone the translation repository:
    ```bash
    git clone git@github.com:solidity-docs/fr-french.git
    cd fr-french/
    ```
2. Create the `develop` branch.
    This will now be the main branch of the translation repository.
    ```bash
    git checkout -b develop
    ```
    If there is already a branch under that name, rename it to something else.
2. Add the Solidity repository as a git remote and pull its `develop` branch with the whole history:
    ```bash
    git remote add english git@github.com:ethereum/solidity.git
    git fetch english develop
    ```
3. Note down the date of the commit that added the documentation snapshot to the repository.
    This will usually be one of the very first commits in it.
    For French this is the second commit ([`42b7772a`](https://github.com/solidity-docs/fr-french/commit/42b7772a145aab0cdbf4fbc300051cbba6d721df)),
    created on 2022-02-04.
4. Check out the state of the `develop` branch in the Solidity repository on that date.
    ```bash
    git checkout -B clean-state-with-history $(git rev-list -n1 --before=2022-02-04 english/develop)
    ```
5. Remove everything except for the documentation:
    ```bash
    find . -mindepth 1 -maxdepth 1 ! \( -name "docs" -o -name ".git" \) -exec git rm -r {} \;
    git commit -m "Prepare the repository for translation"
    ```
6. If the structure of the translation repository does not exactly match the Solidity repository
    (e.g. it has documentation in the root directory instead of inside `docs/`),
    the files in the main repo need to be moved around to match the translation repository:
    ```bash
    git mv docs/* .
    git commit -m "Temporarily moving documentation out of docs/"
    ```
    This is necessary to ensure a correct rebase in the next step.
    - **NOTE**: What matters here is the structure in the initial commit that added the snapshot.
      This needs to be done even if the files were moved to `docs/` in a later commit.
7. Rebase the main branch of the translation repository on `clean-state-with-history`.
    In this case the branch is called `main` but it could be different in different translation repositories.
    ```bash
    git checkout develop
    git rebase clean-state-with-history --rebase-merges=rebase-cousins --strategy-option theirs
    ```
8. If you added the temporary commit to adjust repository structure, now it can be removed using interactive rebase:
    ```bash
    git rebase clean-state-with-history^ --rebase-merges=rebase-cousins --interactive
    ```
    The command will open a text editor, showing all the commits from the translation repository, with the temporary commit somewhere near the top:
    ```
    pick 9d238c692 Temporarily moving documentation out of docs/
    ```
    You need to either remove this line or replace `pick` with `drop`:
    ```
    drop 9d238c692 Temporarily moving documentation out of docs/
    ```
    Then save the file and exit the editor, which will execute the operation.
9. Compare the content of the original main branch of the translation repository with the result of the conversion present now on `develop`.
    The diff command should show no differences other than possibly renamed due to steps 6 and 8 and files that were not copied over as a part of the original snapshot.
    ```bash
    git diff origin/main develop
    ```
    It's also a good idea to visually inspect the commit tree in a tool that can show the full graph with all branches (e.g. gitk).
10. You can now push the `develop` branch to the translation repository:
   ```bash
   git push origin develop

Note that this only converts the main branch of the repository.
All the other branches and tags remain in the old positions but optionally they can also be converted
by simply redoing steps 6-10, substituting the branch/tag in question for `develop`.
