#!/bin/bash

set -exo pipefail

CURDIR=$(pwd)

ln -sf $CURDIR/.zshrc ~/.zshrc
ln -sf $CURDIR/.zimrc ~/.zimrc
ln -sf $CURDIR/.gitconfig ~/.gitconfig
ln -sf $CURDIR/.p10k.zsh ~/.p10k.zsh

[ ! -d $HOME/.ssh ] && mkdir -p $HOME/.ssh
cp $CURDIR/git_sign.pub $HOME/.ssh/

