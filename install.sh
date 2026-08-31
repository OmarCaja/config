#!/usr/bin/env bash

PINK="13"
CURRENT_DIR=$(pwd)

declare -A APPS_NAME=(
    [bat]=$(gum style --foreground "$PINK" "bat")
    [eza]=$(gum style --foreground "$PINK" "eza")
    [starship]=$(gum style --foreground "$PINK" "starship")
    [git]=$(gum style --foreground "$PINK" "git")
    [zed]=$(gum style --foreground "$PINK" "zed")
    [opencode-desktop]=$(gum style --foreground "$PINK" "opencode-desktop")
    [font-hack-nerd-font]=$(gum style --foreground "$PINK" "font-hack-nerd-font")
)
declare -a ALIASES=("bat" "eza" "git")

install_sh_aliases() {

    concatenate_lines_in_file "# sh aliases" "$HOME/.zshrc"
    concatenate_lines_in_file "[[ -s \"$CURRENT_DIR/aliases/sh/.aliases\" ]] && source \"$CURRENT_DIR/aliases/sh/.aliases\"" "$HOME/.zshrc"
    echo "Custom aliases installed:"
    cat aliases/sh/.aliases
}

install_starship() {

    concatenate_lines_in_file "eval \"$(starship init zsh)\"" "$HOME/.zshrc"
    mkdir -p "$HOME/.config" && ln -sf "$CURRENT_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
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

    if command -v "$1" >/dev/null 2>&1 || brew list --cask "$1" &>/dev/null; then

        echo "${APPS_NAME[$1]} is currently installed."
        echo

    else

        echo "${APPS_NAME[$1]} is not installed."
        echo
        gum spin -s dot --show-output --title "Installing ${APPS_NAME[$1]} " brew install "$1"
        echo
        echo "${APPS_NAME[$1]} installed successfully."
        echo

    fi
}

copy_zed_config() {

    mkdir -p "$HOME/.config/zed" && ln -sf "$CURRENT_DIR/zed/settings.json" "$HOME/.config/zed/settings.json"
}

install_opencode_config() {

    mkdir -p "$HOME/.config/opencode" && ln -sf "$CURRENT_DIR/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
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
        if [ "$app" != font-hack-nerd-font ]; then
            brew_install_app "$app"
        else
            brew list --cask font-hack-nerd-font &>/dev/null || brew install --cask font-hack-nerd-font
        fi
        install_aliases "$app"
        install_gitconfig "$app"
        if [ "$app" = starship ]; then
            install_starship
        elif [ "$app" = zed ]; then
            copy_zed_config
        elif [ "$app" = opencode-desktop ]; then
            install_opencode_config
        fi
    done
}

touch "$HOME/.zshrc"
touch "$HOME/.gitconfig"
touch "$HOME/.vimrc"
mkdir -p "$HOME/.config"

install_apps

grep -qF "source $CURRENT_DIR/vim/.vimrc" "$HOME/.vimrc" || gum confirm "Do you want to install vimrc config?" && install_vimrc_config || echo "vimrc config not installed."

gum pager <aliases/sh/.aliases
gum confirm "Do you want to install the previous aliases?" && install_sh_aliases || echo "Custom aliases not installed."
