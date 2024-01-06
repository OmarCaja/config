#!/usr/local/Cellar/bash/5.2.21/bin/bash

PINK="13"
CURRENT_DIR=$(pwd)

declare -A APPS_NAME=(
	[bat]=$(gum style --foreground "$PINK" "bat")
	[exa]=$(gum style --foreground "$PINK" "exa")
	[nvim]=$(gum style --foreground "$PINK" "nvim")
	[starship]=$(gum style --foreground "$PINK" "starship")
	[git]=$(gum style --foreground "$PINK" "git")
)
declare -a ALIASES=("bat" "exa" "nvim" "git")
declare -a GIT_CONFIG=("nvim" "git")

install_sh_aliases() {

	concatenate_lines_in_file "# sh aliases" "$HOME/.zshrc"
	concatenate_lines_in_file "[[ -s \"$CURRENT_DIR/aliases/sh/.aliases\" ]] && source \"$CURRENT_DIR/aliases/sh/.aliases\"" "$HOME/.zshrc"
	echo "Custom aliases installed:"
	cat aliases/sh/.aliases
}

install_starship() {

	concatenate_lines_in_file "eval \"$(starship init zsh)\"" "$HOME/.zshrc"
	cp -rf "starship/starship.toml" "$HOME/.config/starship.toml"
}

install_gitconfig() {

	if ! grep -qF "$1" "$HOME/.gitconfig"; then
		echo "[include]" >>"$HOME/.gitconfig"
		echo "$1" >>"$HOME/.gitconfig"
	fi
}

concatenate_lines_in_file() {

	grep -qF "$1" "$2" || echo "$1" >>"$2"
}

install_aliases() {

	concatenate_lines_in_file "# $1 aliases" "$HOME/.zshrc"
	concatenate_lines_in_file "[[ -s \"$CURRENT_DIR/aliases/$1/.aliases\" ]] && source \"$CURRENT_DIR/aliases/$1/.aliases\"" "$HOME/.zshrc"

	if [[ $1 = nvim ]]; then
		install_gitconfig "path = $CURRENT_DIR/git/nvim/.gitconfig"
	fi
}

brew_install_app() {

	if ! command -v "$1" >/dev/null 2>&1; then

		echo "${APPS_NAME[$1]} is not installed."
		echo
		gum spin -s dot --show-output --title "Installing ${APPS_NAME[$1]} " brew install "$1"
		echo
		echo "${APPS_NAME[$1]} installed successfully"
		echo

	else

		echo "${APPS_NAME[$1]} is currently installed"
		echo
	fi
}

install_apps() {

	echo Choose apps you want to install.
	echo Press space to select between options and press enter to confirm.
	echo

	apps=$(gum choose --no-limit "${APPS_NAME[@]}")

	# shellcheck disable=SC2068
	for app in ${apps[@]}; do
		brew_install_app "$app"
		if [ "$app" = starship ]; then
			install_starship
		else
			for alias in "${ALIASES[@]}"; do
				if [ "$app" = "$alias" ]; then
					install_aliases "$app"
				fi
			done
			for gitConfig in "${GIT_CONFIG[@]}"; do
				if [ "$app" = "$gitConfig" ]; then
					if [ "$app" = nvim ]; then
						install_gitconfig "path = $CURRENT_DIR/git/nvim/.gitconfig"

					else
						install_gitconfig "path = $CURRENT_DIR/git/.gitconfig"
					fi
				fi
			done
		fi
	done
}

touch "$HOME/.zshrc"
touch "$HOME/.gitconfig"
mkdir -p "$HOME/.config"

install_apps

gum pager <aliases/sh/.aliases
gum confirm "Do you want to install the previous aliases?" && install_sh_aliases || echo "Custom aliases not installed."
