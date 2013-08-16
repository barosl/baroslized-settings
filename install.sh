#!/bin/sh

set -- .vimrc .zshrc .zprofile .gitconfig .tmux.conf .colordiffrc .baroslized-profile

for file; do
    ln -s "$PWD/$file" "$HOME/$file"
done

if ! grep -Fxq '### baroslized settings ###' ~/.profile; then
    { echo; echo; echo '### baroslized settings ###'; echo '. ~/.baroslized-profile'; } >> ~/.profile
fi
