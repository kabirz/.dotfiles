#!/bin/zsh

if (( ${+commands[zellij]} )); then
    alias zz='zellij -l code a -c zhp'
    alias za='zellij a -c'
    alias zac='zellij -l code a -c'
    alias zaw='zellij -l raw a -c'
    alias zl='zellij ls'
    alias zd='zellij d'
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup=`~/mambaforge/bin/conda shell.zsh hook 2> /dev/null`
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f ~/mambaforge/etc/profile.d/conda.sh ]; then
        . ~/mambaforge/etc/profile.d/conda.sh
    else
        export PATH=~/mambaforge/bin:$PATH
    fi
fi
unset __conda_setup

if [ -f ~/mambaforge/etc/profile.d/mamba.sh ]; then
    . ~/mambaforge/etc/profile.d/mamba.sh
    alias conda=mamba
fi
# <<< conda initialize <<<

export PATH=~/.dotfiles/bin:$PATH
