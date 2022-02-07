## Setting up the Bot 
- Create a new GitHub account and set up [Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
- Go to repository Settings -> Security -> Secrets -> Actions -> Repository secrets
- create new secret: `PAT` with Personal Access Token of a bot
- in `create-pull-request.yaml` update bot related fields:
  - `jobs.createPullRequest.env.bot_username`
  - `jobs.createPullRequest.env.bot_email`


## Adding new translation repository

PR Bot requires related histories between original and translated repositories. To achieve common history, we can either:
- clone [ethereum/solidity](https://github.com/ethereum/solidity/)
- remove everything but `docs/` directory
- remove all branches but `develop`
- create a new repository in the [solidity-docs](https://github.com/solidity-docs) organization
- grant bot write access to that repository
- push from your clone to the newly created repository

Another option would be maintaining an up-to-date `en-english` repository as a template - with only the `docs` directory. That repository would be ready to fork and create a translation repository. In that case, the procedure would look like this:
- `git clone --bare git@github.com:solidity-docs/en-english.git`
- create a new GitHub repository, e.g. `solidity-docs/pl-polish`
- grant bot write access to that repository
- `cd en-english && git push git@github.com:solidity-docs-test/pl-polish.git`

In either case, pull request workflow file has to be updated:
- edit `.github/workflow/create-pull-request.yaml` 
- add language code to `jobs.createPullRequest.strategy.matrix.repos`

## How to transform translation repository to compatible form
- check for the date of first translation commit, i.e [french](https://github.com/solidity-docs/fr-french/commits/main?after=2419c07e094306460d439da8c4db9ec15363b10c+34&branch=main), first commit is 04.02.2022
- clone solidity repository `git clone git@github.com:ethereum/solidity.git`
- rename solidity repository as translation repository, eg `mv solidity fr-french`
- change directory to just created repository, i.e.: `cd fr-french`
- check out to the date of first translation commit and overwrite develop branch: ``git checkout -B develop `git rev-list -n1 --before=2022-02-04 develop``
- remove everything but `docs/` directory
- commit your changes: `git add . && git commit -am "prepare translation repository"`
- clone old translation repository, add `-old` suffix, e.g. `cd .. && git clone git@github.com:solidity-docs/fr-french.git fr-french-old`
- if a translation repository has the wrong structure (root directory instead of `docs`), temporarily move all the files to the root directory and commit the change: `mv docs/* . && git add . && git commit -am "temporarly moving documentation outside docs/ dir"`
- go to translation repository and add a remote - old translation: `git remote add french-old ../fr-french-old/`
- fetch:   `git fetch french-old`
- go to old translation repository and pick first and last translation commits, i.e for [french](https://github.com/solidity-docs/fr-french/commits/main?after=2419c07e094306460d439da8c4db9ec15363b10c+34&branch=main) first commit is `42b7772a145aab0cdbf4fbc300051cbba6d721df` and last `2419c07e094306460d439da8c4db9ec15363b10c`
- create a range: `first_sha..last_sha`
- cherry pick commits using range: `git cherry-pick --strategy=recursive -X theirs 42b7772a145aab0cdbf4fbc300051cbba6d721df..2419c07e094306460d439da8c4db9ec15363b10c`
- for merge commit, you need to skip commit: `git cherry-pick --skip`
- if necessary, move back everything to the `docs` directory and create a commit
- create new GitHub repository
- edit `.git/config` and change origin URL, eg:
```
  6 [remote "origin"]
  7         url = git@github.com:solidity-docs-test/fr-french.git
```
- create branch main: `git checkout -b main`
- push branch main: `git push origin main`
