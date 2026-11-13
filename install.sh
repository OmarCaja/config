#!/usr/bin/env bash

# Bootstrap: this script needs bash >= 4 (declare -A) and gum. Install them with brew and re-run.
if ((BASH_VERSINFO[0] < 4)) || ! command -v gum >/dev/null 2>&1; then
    command -v brew >/dev/null 2>&1 || {
        echo "Install Homebrew first: https://brew.sh"
        exit 1
    }
    brew install bash gum
    exec "$(brew --prefix)/bin/bash" "$0" "$@"
fi

PINK="13"
CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CASKS=" zed font-hack-nerd-font "

declare -A APPS_NAME=(
    [bat]=$(gum style --foreground "$PINK" "bat")
    [eza]=$(gum style --foreground "$PINK" "eza")
    [starship]=$(gum style --foreground "$PINK" "starship")
    [git]=$(gum style --foreground "$PINK" "git")
    [zed]=$(gum style --foreground "$PINK" "zed")
    [font-hack-nerd-font]=$(gum style --foreground "$PINK" "font-hack-nerd-font")
)
declare -a ALIASES=("bat" "eza" "git")

install_sh_aliases() {

    concatenate_lines_in_file "# sh aliases" "$HOME/.zshrc"
    concatenate_lines_in_file "[[ -s \"$CURRENT_DIR/aliases/sh/.aliases\" ]] && source \"$CURRENT_DIR/aliases/sh/.aliases\"" "$HOME/.zshrc"
    echo "Custom aliases installed:"
    cat "$CURRENT_DIR/aliases/sh/.aliases"
}

# link <source> <target>: symlink, keeping a .bak of any real file already there.
link() {

    mkdir -p "$(dirname "$2")"
    if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.bak"; fi
    ln -sf "$1" "$2"
}

install_starship() {

    concatenate_lines_in_file "eval \"\$(starship init zsh)\"" "$HOME/.zshrc"
    link "$CURRENT_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
}

install_gitconfig() {

    git_gitconfig="path = $CURRENT_DIR/git/.gitconfig"

    if [ "$app" = git ]; then
        if ! grep -qF "$git_gitconfig" "$HOME/.gitconfig"; then
            echo "[include]" >>"$HOME/.gitconfig"
            echo "$git_gitconfig" >>"$HOME/.gitconfig"
        fi
    fi
}

concatenate_lines_in_file() {

    grep -qF "$1" "$2" || echo "$1" >>"$2"
}

install_aliases() {

    for alias in "${ALIASES[@]}"; do
        if [ "$app" = "$alias" ]; then
            concatenate_lines_in_file "# $1 aliases" "$HOME/.zshrc"
            concatenate_lines_in_file "[[ -s \"$CURRENT_DIR/aliases/$1/.aliases\" ]] && source \"$CURRENT_DIR/aliases/$1/.aliases\"" "$HOME/.zshrc"
        fi
    done
}

brew_install_app() {

    cask=()
    [[ "$CASKS" == *" $1 "* ]] && cask=(--cask)

    if command -v "$1" >/dev/null 2>&1 || brew list --cask "$1" &>/dev/null; then

        echo "${APPS_NAME[$1]} is currently installed."
        echo

    else

        echo "${APPS_NAME[$1]} is not installed."
        echo
        gum spin -s dot --show-output --title "Installing ${APPS_NAME[$1]} " brew install "${cask[@]}" "$1"
        echo
        echo "${APPS_NAME[$1]} installed successfully."
        echo

    fi
}

copy_zed_config() {

    link "$CURRENT_DIR/zed/settings.json" "$HOME/.config/zed/settings.json"
}

install_vimrc_config() {

    concatenate_lines_in_file "source $CURRENT_DIR/vim/.vimrc" "$HOME/.vimrc"
}

install_apps() {

    echo "Choose apps you want to install."
    echo "Press space to select between options and press enter to confirm."
    echo

    apps=$(gum choose --no-limit "${APPS_NAME[@]}")

    # shellcheck disable=SC2068
    for app in ${apps[@]}; do
        brew_install_app "$app"
        install_aliases "$app"
        install_gitconfig "$app"
        if [ "$app" = starship ]; then
            install_starship
        elif [ "$app" = zed ]; then
            copy_zed_config
        fi
    done
}

# Ask for git name/email only if they are not set yet.
ensure_git_identity() {

    for key in name email; do
        git config --global --get "user.$key" >/dev/null && continue
        value=$(gum input --header "Git user.$key (not set yet)" --placeholder "user.$key")
        [ -n "$value" ] && git config --global "user.$key" "$value"
    done
}

touch "$HOME/.zshrc"
touch "$HOME/.gitconfig"
touch "$HOME/.vimrc"
mkdir -p "$HOME/.config"

install_apps
ensure_git_identity

gum confirm "Do you want to install vimrc config?" && install_vimrc_config || echo "vimrc config not installed."

gum pager <"$CURRENT_DIR/aliases/sh/.aliases"
gum confirm "Do you want to install the previous aliases?" && install_sh_aliases || echo "Custom aliases not installed."
