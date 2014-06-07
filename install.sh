#!/bin/sh

set -- .vimrc .zshrc .zprofile .gitconfig .tmux.conf .colordiffrc .baroslized-profile .ssh/config

[ ! -e $HOME/.ssh ] && mkdir $HOME/.ssh && chmod 700 $HOME/.ssh

for file; do
    ln -s "$PWD/$file" "$HOME/$file"
done

if ! grep -Fxq '### baroslized settings ###' ~/.profile; then
    cp -ai ~/.profile ~/.profile.ori
    { echo; echo; echo '### baroslized settings ###'; echo '. ~/.baroslized-profile'; } >> ~/.profile
fi
