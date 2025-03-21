#!/bin/zsh

# functions
function setproxy() {
    ip='127.0.0.1'
    port=10887
    if [[ "$#" == "1" ]] then
        ip=$1
    elif [[ "$#" == "2" ]] then
        ip=$1
        port=$2
    fi
    export http_proxy="http://${ip}:${port}"
    export https_proxy="http://${ip}:${port}"
    export no_proxy='127.0.0.1,localhost,192.168.*.*,10.*.*.*'
    echo "already open proxy with ${ip}:${port}"
}

function closeproxy() {
    unset http_proxy
    unset https_proxy

    echo "already close proxy"
}

# uv
if (( ${+commands[uv]} )); then
    type -p _uv > /dev/null
    if (( $? != 0 )); then
        eval "$(uv generate-shell-completion zsh)"
    fi
    type -p _uvx > /dev/null
    if (( $? != 0 )); then
        eval "$(uvx --generate-shell-completion zsh)"
    fi
    function setuv() {
        if [[ "$#" == "1" ]] then
            export UV_DEFAULT_INDEX=$1
        else
            export UV_DEFAULT_INDEX=https://pypi.tuna.tsinghua.edu.cn/simple
        fi
    }

    function unsetuv() {
        unset UV_DEFAULT_INDEX
    }
fi
# zellij
if (( ${+commands[zellij]} )); then
    alias zz='zellij -l code a -c zhp'
    alias za='zellij a -c'
    alias zac='zellij -l code a -c'
    alias zaw='zellij -l raw a -c'
    alias zl='zellij ls'
    alias zd='zellij d'
fi
# tmux
if (( ${+commands[tmux]} )); then
    alias ta='tmux attach -t'
    alias tz='tmux attach -t zhp'
    alias tac='tmux new-session -s zhp'
    alias tad='tmux attach -d -t'
    alias ts='tmux new-session -s'
    alias tl='tmux list-sessions'
    alias tksv='tmux kill-server'
    alias tkss='tmux kill-session -t'
fi

if [ -d ~/micromamba ]; then
    alias conda=micromamba
elif [ -d ~/mambaforge ]; then
    alias conda=mamba
fi

# rg
if (( ${+commands[rg]} )); then
    alias rga='rg --no-ignore'
fi

# enviroment
# cmake for lsp
export CMAKE_EXPORT_COMPILE_COMMANDS=ON

export PATH=~/.dotfiles/bin:$PATH
