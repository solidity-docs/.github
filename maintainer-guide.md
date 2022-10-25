## Maintainer Guide

This document lists the responsibilities and resources available to maintainers of the Solidity documentation translation forks.

### Maintainer Responsibilities

As maintainers of one of the Solidity doc translations we ask you to please:
- Track the process of the translation in the [translation progress checklist](progress-checklist.md).
- Review PRs made by contributors in a timely manner.
- Make sure that the translations follow the [translation style guide](https://docs.soliditylang.org/en/latest/contributing.html#documentation-style-guide) outlined in the Solidity docs.
- Regularly check if the translation is up-to-date.
- Inform the Solidity team once your translation has reached the state where it can be published by adding it to the Solidity docs.
- Act as point of contact for your language and answer questions from both contributors to your language and the core Solidity team.

The Solidity team holds it at their discretion to add/remove maintainers if the maintainer responsibilities are not adhered to.

### Starting a New Language

If you want to start a new language, please find at least one other contributor to join you in being the maintainer (main contributor and owner) of this language. Being the maintainer of the translation requires you to organize the translation efforts for this respective language, assure quality and accuracy and make sure translations are kept in sync and are on an up-to-date level. 

If you don’t know of any other translators that want to join your language, feel free to create a topic in the [documentation category](https://forum.soliditylang.org/c/documentation/8) of the Solidity forum to find more contributors.

Once you have your team of min. 2 contributors, create a PR to the langs folder consisting of file ``{lang-code}.json`` including the English name of the language, the [language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) and a list of maintainers.

For example:

```json
{
    "name": "German",
    "code": "de",
    "maintainers": [
        "franzihei",
        "chriseth"
    ]
}
```

Once the PR is accepted we will create an empty repository with the [language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) followed by the English name of the language, e.g. for a German translation the repository would be called: ``de-german``. You will then be added as a maintainer to this repository.

As a next step, clone the Solidity repository locally:
```
git clone https://github.com/ethereum/solidity.git
```
```
cd solidity
```

Remove all the tags. Only the tags with complete translation should exist in the language repo.
```
git tag | xargs git tag -d
```

Mirror push the temporary local repository to the new repository
```
git push --mirror git@github.com:solidity-docs/<language-code>.git
```

Check if the repository is populated at https://github.com/solidity-docs/<language-code>

Remove the temporary local repository:
```
cd ..
rm -rf solidity
```

Clone the new repository
```
git clone git@github.com:solidity-docs/<language-code>.git
```

Remove files irrelevant to the translation
```
cd <language-code>
find . -mindepth 1 -maxdepth 1 ! \( -name "docs" -o -name "CMakeLists.txt" -o -name ".git" \) -exec git rm -r {} \;
```

Add a README
```
echo "# <title>" >> README.md
git add README.md
git commit -m "Prepare the repository for translation"
```

Push changes
```
git push origin
```


That's it, now you can start translating! Make sure to create an issue with the [translations progress checklist](progress-checklist.md) in your repo to track the progress.

Once your translations is advanced and you have checked the first part of the [translations progress checklist](progress-checklist.md), please let us know and we will consider adding your translation to the [language flyout menu](https://docs.readthedocs.io/en/stable/localization.html#project-with-multiple-translations) of the official Solidity documentation!
 
### Automation

To help translators keep up with changes in the official documentation, which gets constantly expanded and updated, we run a translation bot.
The bot regularly checks the main Solidity repository for changes and notifies translators by creating pull requests that indicate which parts require new translation.

#### Bot Configuration

Some aspects of the bot can be controlled via a file called `translation-bot.json` that can be placed in the root directory of a translation repository.
If the file is not present, the bot uses the following default configuration:

```json
{
    "disabled": false,
    "randomly_assign_maintainers": false,
    "pr_labels": [
        "sync-pr"
    ]
}
```
- `disabled` can be set to `true` to tell the bot that the maintainers of the repository do not want to receive sync PRs.
    This is useful for example when the translators are targetting an older version of the documentation and would close these PRs anyway.
- `randomly_assign_maintainers` makes the bot automatically assign maintainers and add reviewers to the PR.
    Users are randomly chosen from the `maintainers` array in [the JSON file corresponding to their repository](langs/).
- `pr_labels` is a list of labels applied by the bot to sync PRs.
    These are useful as a way to easily select all sync PRs on Github's PR list.

When editing configuration please make sure it has no JSON syntax errors.
Errors in the configuration file will prevent the bot from submitting PRs in your repository.
In case of problems please check if there are any failures on [the list of bot runs](https://github.com/solidity-docs/.github/actions/workflows/create-daily-docs-sync-pr.yaml).
You can always ask for help in the [Solidity Docs Community Translations](https://app.element.io/#/room/#solidity-docs-translations:matrix.org) room on Matrix or, if you think it's a bug, please [report an issue](https://github.com/solidity-docs/.github/issues).

### Tips

#### File, Tags and Reference Names
Please do not change the names of the files and also keep the names of all tags and references. 

There are some special [Sphinx](https://docs.readthedocs.io/en/stable/intro/getting-started-with-sphinx.html) markup syntax to look for such as:
- [References](https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html#cross-referencing-arbitrary-locations): `.. _translations:` and `:ref:_translations`
- [Paragraph Level Markup](https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#paragraph-level-markup): `.. note::` , `.. warning::`

#### Glossary
Consider making a glossary of the translations of technical and Solidity-specific terms. Put this in a highly visible location (the README or a pinned issue).

#### Language-Specific Style Guide
If needed, you can create a language-specific style guide to define additional rules to follow when translating. See the general [Solidity docs style guide](https://docs.soliditylang.org/en/latest/contributing.html#documentation-style-guide) for rules that should apply to all translations.

#### Review Process

Decide how many reviewers you want to review each translated page before it can be merged. If your team is small and busy, you may only be able to have one reviewer so that translators don't get blocked. If your team is bigger, consider having two reviewers so you have a stronger guarantee that the page is correct.

#### Translatable Files

If you like, you can create translatable files following [this readthedocs translations guide](https://docs.readthedocs.io/en/stable/guides/manage-translations.html#create-translatable-files). While these can be helpful for some, they are not necessarily needed to translate the documentation.

#### Machine Translations

Machine translations (e.g. using [DeepL](https://www.deepl.com/translator)) can help get big texts translated more quickly. Please make sure to carefully proof-read all machine translations since especially technical terms might not be reflected correctly.
 
### Need Help or Have Questions?

If you have a question that isn't addressed here, you can visit the [Documentation category](https://forum.soliditylang.org/c/documentation/8) of the Solidity forum and ask for help!

You can also reach out to us in the [Solidity Docs Community Translations](https://app.element.io/#/room/#solidity-docs-translations:matrix.org) room on Matrix.
