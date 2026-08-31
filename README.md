# Dotfiles

Personal config files for macOS. Installs CLI tools via Homebrew and symlinks configs to `~/.config`.

## Prerequisites

- [Homebrew](https://brew.sh/)
- [Bash](https://formulae.brew.sh/formula/bash) — `brew install bash`
- [Gum](https://github.com/charmbracelet/gum) — `brew install gum`

## Installation

```shell
./install.sh
```

Interactive TUI lets you choose which apps to install and config to link.

## What's Included

| App | Config |
|-----|--------|
| starship | `starship/starship.toml` → `~/.config/starship.toml` |
| zed | `zed/settings.json` → `~/.config/zed/settings.json` |
| opencode | `opencode/opencode.json` → `~/.config/opencode/opencode.json` |
| git | `git/.gitconfig` included in `~/.gitconfig` |
| vim | `vim/.vimrc` sourced in `~/.vimrc` |

Aliases in `aliases/` are sourced directly from `~/.zshrc`.
