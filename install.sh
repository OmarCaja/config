#!/bin/sh

cat starship/starship.toml > $HOME/.config/starship.toml
mkdir -p $HOME/.warp/workflows
cp -a warp/. $HOME/.warp/workflows
cat vim/.vimrc >> $HOME/.vimrc
cat zsh/.zshrc >> $HOME/.zshrc

