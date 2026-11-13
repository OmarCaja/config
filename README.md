<h1 align="center">Dotfiles</h1>

<p align="center">
  My macOS setup in one command: CLI tools, fonts and configs, installed with Homebrew and linked from this repo.
</p>

<p align="center">
  <img alt="macOS" src="https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white">
  <img alt="Shell" src="https://img.shields.io/badge/shell-bash%20%7C%20zsh-4EAA25?logo=gnubash&logoColor=white">
  <img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-blue.svg">
</p>

## Quick start

```shell
git clone https://github.com/OmarCaja/config.git
cd config
./install.sh
```

The only prerequisite is [Homebrew](https://brew.sh/). If Bash 4+ or [Gum](https://github.com/charmbracelet/gum) are missing, the script installs them and re-runs itself.

> [!IMPORTANT]
> Keep the repo where you cloned it. Symlinks and the lines added to your dotfiles use its absolute path, so moving it breaks them.

## What the installer does

An interactive menu (powered by Gum) lets you pick what to set up. Only what you select is installed.

| App | Installed with | Config |
|-----|----------------|--------|
| [bat](https://github.com/sharkdp/bat) | brew | alias `cat` |
| [eza](https://github.com/eza-community/eza) | brew | aliases `ls`, `ll`, `la`, `t`, `ta`, `tg` |
| [git](https://git-scm.com/) | brew | `git/.gitconfig` included from `~/.gitconfig`, alias `g` |
| [starship](https://starship.rs/) | brew | `starship/starship.toml` → `~/.config/starship.toml` |
| [zed](https://zed.dev/) | brew cask | `zed/settings.json` → `~/.config/zed/settings.json` |
| [Hack Nerd Font](https://www.nerdfonts.com/) | brew cask | font used by Zed and the terminal |

After the menu it also offers to:

- **Link vim config**: `vim/.vimrc` is sourced from `~/.vimrc`.
- **Install shell aliases**: `aliases/sh/.aliases` (`..`, `to`, `md`) is sourced from `~/.zshrc`.
- **Set your git identity**: asks for `user.name` and `user.email`, only if they are not set yet.

## How it works

| Mechanism | Used for | Why |
|-----------|----------|-----|
| Symlink | starship, zed | The app reads the file in the repo, so edits show up in `git status`. |
| `[include]` / `source` | git, vim | Keeps your own local settings and adds mine on top. |
| `source` from `~/.zshrc` | aliases | One file per tool, loaded only if you installed that tool. |

The installer is safe to run more than once:

- Lines are only appended to `~/.zshrc`, `~/.gitconfig` and `~/.vimrc` if they are not there yet.
- A real config file already in place is moved to `<file>.bak` before linking.

## Structure

```text
.
├── install.sh      # interactive installer
├── aliases/        # shell aliases, one folder per tool
├── git/            # .gitconfig with aliases and defaults
├── starship/       # prompt (Catppuccin Mocha)
├── vim/            # .vimrc
└── zed/            # editor settings
```

## License

[MIT](LICENSE)
