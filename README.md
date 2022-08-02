# Solidity Documentation Translation Guide

Hello and welcome to the [Solidity documentation](http://docs.soliditylang.org/) translations GitHub organization! Great to have you here. 😊

In this org, we coordinate all community-driven translation efforts.

Please note that the Solidity team can give no guarantees on the quality and accuracy of the translations provided. The translations are meant to lower the entry barriers for non-English speaking developers and hence will allow a broader set of developers from all over the world to get to know Solidity. However, the English reference version is and will remain the only officially supported version by the Solidity team and will always be the most accurate and most up-to-date one. When in doubt, always refer to the English (original) documentation.

### Contributing to the Translations

Before we get started, please make sure to read this guide carefully.

By uniting all translation efforts in this repository we aim to…
- Get a broader set of eyes and contributors involved in the translation process.
- Establish quality standards and best practices.
- Help each other and better leverage synergies across the different language translation teams.

### Translation Process

After carefully [evaluating](https://github.com/ethereum/solidity/issues/10119) different options, we decided in favor of keeping the technicalities of the translation process up to the individual contributors and decided against using a translation tool.

However, in order to make things easier for the contributors and assure some sort of standard, we are proposing to follow the rough process which is outlined below, respecting the translation checklist and working in a translation team of min. 2 people.

### Starting a New Language

To start with a new language, adhere to the following process:

Find at least one other contributor to join you in being the maintainer (main contributor and owner) of this language. Being the maintainer of the translation requires you to organize the translation efforts for this respective language, assure quality and accuracy and make sure translations are kept in sync and are on an up-to-date level. You find an overview and tips in the [maintainer guide](https://github.com/solidity-docs/translation-guide/blob/main/maintainer-guide.md).

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

Remove all files except the `docs/` folder
```
cd <language-code>
rm -vr !("docs")
```

Remove all hidden files except `.git/`
```
mv .git git
rm -r ./.*
mv git .git
```

Add a README
```
echo "# <title>" >> README.md
```

Push changes
```
git add .
git commit -m "<commit message>"
git push
```


That's it, now you can start translating! Make sure to create an issue with the [translations progress checklist](https://github.com/solidity-docs/translation-guide/blob/main/progress-checklist.md) in your repo to track the progress and please follow the recommendations outlined in the [maintainer guide](https://github.com/solidity-docs/translation-guide/blob/main/maintainer-guide.md).

Once your translations is advanced and you have checked the first part of the [translations progress checklist](https://github.com/solidity-docs/translation-guide/blob/main/progress-checklist.md), please let us know and we will consider adding your translation to the [language flyout menu](https://docs.readthedocs.io/en/stable/localization.html#project-with-multiple-translations) of the official Solidity documentation!

### Automation

To help translators keep up with changes in the official documentation, which gets constantly expanded and updated, we run a translation bot.
The bot regularly checks the main Solidity repository for changes and notifies translators by creating pull requests that indicate which parts require new translation.

### Acknowledgements

Big kudos go out to the [ReactJS translations team repository](https://github.com/reactjs/reactjs.org-translation) and the [ethereum.org translation team](https://ethereum.org/en/contributing/translation-program/), which both inspired us with their resources and advised on setting up this process.
