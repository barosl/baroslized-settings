#!/bin/sh

set -- .vimrc .zshrc .zprofile .gitconfig .tmux.conf .colordiffrc

for file; do
    ln -s "$PWD/$file" "$HOME/$file"
done
