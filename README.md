# :rocket: Custom config files for spedding up.

## :wrench: Installation.
Execute `./install.sh` for auto installing the given configuration files:

- `aliases`
  - `.zshrc` -> Will sourced `$HOME/.aliases` to your `$HOME/.zshrc` file.
  - `bat` -> Will add `bat` alias for `cat`. See https://github.com/sharkdp/bat.
  -  `exa` -> Will add some `exa` aliases for `ls`. See https://the.exa.website.
  -  `nvim` -> Will add `nvim` alias for `vim`.
- `git` -> Will add some `git` aliases to you `$HOME/.gitconfig` file if exists, otherwise it will create the file.
- `starship` -> Will replace your current `starship.toml` config file located in: `$HOME/.config/starship.toml` if exists, otherwise it will create the file.
- `warp` -> Will add warp workflows to your warp workflows folder `$HOME/.war/workflows` if the folder exists, otherwise it will create the folder.

:grey_exclamation: Check `install.zsh -h` for help
