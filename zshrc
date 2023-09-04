#!/bin/zsh

if (( ${+commands[zellij]} )); then
    alias za='zellij a -c'
    alias zac='zellij -l code a -c'
    alias zl='zellij ls'
fi
