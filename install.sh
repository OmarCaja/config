#!/bin/sh

mkdir -p $HOME/.config
mkdir -p $HOME/.warp/workflows

cp -rf starship/starship.toml $HOME/.config/starship.toml
cp -rf warp/workflows/. $HOME/.warp/workflows
cat vim/.vimrc >> $HOME/.vimrc
cat zsh/.zshrc >> $HOME/.zshrc
cat zsh/.aliases >> $HOME/.aliases

