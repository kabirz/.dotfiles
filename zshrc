#!/bin/zsh

if (( ${+commands[zellij]} )); then
    alias zz='zellij -l code a -c zhp'
    alias za='zellij a -c'
    alias zac='zellij -l code a -c'
    alias zaw='zellij -l raw a -c'
    alias zl='zellij ls'
    alias zd='zellij d'
fi

if [ -d ~/micromamba ]; then
    alias conda=micromamba
elif [ -d ~/mambaforge ]; then
    alias conda=mamba
fi

export PATH=~/.dotfiles/bin:$PATH
