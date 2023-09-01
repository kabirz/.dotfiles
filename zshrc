#!/bin/zsh

if (( ${+commands[zellij]} )); then
    alias zsc='zellij -l code -s'
    alias zs='zellij -s'
    alias za='zellij a'
fi
