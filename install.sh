#!/usr/local/Cellar/bash/5.2.15/bin/bash

declare -A APPS_NAME_URL=(
	[brew]=$(gum style --foreground "$PINK" "brew")
	[bat]=$(gum style --foreground "$PINK" "bat")
	[exa]=$(gum style --foreground "$PINK" "exa")
	[nvim]=$(gum style --foreground "$PINK" "nvim")
	[starship]=$(gum style --foreground "$PINK" "starship")
)

install_app() {

	if ! command -v "$1" >/dev/null 2>&1; then

		echo "${APPS_NAME_URL[$1]} is not installed"
		echo
		gum spin -s dot --title "Installing ${APPS_NAME_URL[$1]}" sleep 2
		echo
		echo "${APPS_NAME_URL[$1]} installed successfully"
		echo
		
	else

		echo "${APPS_NAME_URL[$1]} is currently installed"
		echo
	fi
}

install_extra_apps() {

	echo Choose other apps you want to install:
	echo
	echo Press space to select one or more options and enter to confirm
	echo

	apps=$(gum choose --no-limit ${APPS_NAME_URL[@]:2})

	for app in ${apps[@]}; do
		install_app $app
	done
}

install_app brew
install_extra_apps
 
