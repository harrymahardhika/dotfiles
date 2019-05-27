#!/bin/bash

cp ~/.gitconfig .
cp ~/.tmux.conf .
cp ~/.vimrc .
cp ~/.zshrc .
git add .
git commit -m 'Update'
git push origin master
