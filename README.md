# :rocket: Custom config files for spedding up.

## :wrench: Installation.
Execute `./install.sh` for auto installing the given configuration files:

- `aliases`
  - `bat` -> Will add `bat` alias for `cat`. See https://github.com/sharkdp/bat.
  - `exa` -> Will add some `exa` aliases for `ls`. See https://the.exa.website.
  - `nvim` -> Will add `nvim` alias for `vim`, and will setup `nvim` as default text editor for git.
  - `zsh` -> Will add some usefull sh aliases.
- `git` -> Will add some `git` aliases.
- `starship` -> Will replace your current `starship.toml` config file located in: `$HOME/.config/starship.toml` if exists, otherwise it will create the file. See https://starship.rs/config
- `warp` -> Will add warp workflows to your warp workflows folder `$HOME/.war/workflows` if the folder exists, otherwise it will create the folder. See https://docs.warp.dev/features/entry/workflows

:grey_exclamation: Check `install.zsh -h` for help
