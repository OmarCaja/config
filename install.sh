#!/bin/sh

currentDir=$(pwd)
goconfAlias="alias goconf='cd $currentDir'"

mkdir -p $HOME/.config
mkdir -p $HOME/.warp/workflows

cp -rf starship/starship.toml $HOME/.config/starship.toml
cp -rf warp/workflows/. $HOME/.warp/workflows

concat_file_lines () 
{
	IFS=''
	while read line; do
		grep -qF "$line" $2 || echo $line >> $2
	done < $1
}

concat_file_lines "vim/.vimrc" "$HOME/.vimrc"
concat_file_lines "zsh/.zshrc" "$HOME/.zshrc"
concat_file_lines "zsh/.aliases" "$HOME/.aliases"
concat_file_lines "git/.gitconfig" "$HOME/.gitconfig"

grep -qF $goconfAlias "$HOME/.aliases" || echo $goconfAlias >> "$HOME/.aliases"

