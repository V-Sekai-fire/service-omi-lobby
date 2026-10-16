# Contributors

This repository started from a copy of [V-Sekai/uro](https://github.com/V-Sekai/uro) without its git history, so `git log` here shows only later work. The people below wrote Uro and its web front end before the copy.

## Previous contributors (V-Sekai/uro)

- [SaracenOne](https://github.com/SaracenOne): 134 commits
- [fire](https://github.com/fire): 42 commits
- [lyuma](https://github.com/lyuma): 39 commits
- [ariesclark](https://github.com/ariesclark): 14 commits
- [benbot](https://github.com/benbot): 9 commits
- [dragonhunt02](https://github.com/dragonhunt02): 7 commits

Dependabot made 11 further commits upstream.

## This repository

- [fire](https://github.com/fire)

## Updating this list

Counts come from the GitHub contributors API, which also counts commits from unlinked e-mail addresses (`anon=1`):

```sh
gh api 'repos/V-Sekai/uro/contributors?per_page=100&anon=1' \
  --jq '.[] | "\(.login // .name) \(.contributions)"'
```
