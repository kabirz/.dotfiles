#!/bin/zsh

################################ common start ################################################
# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g 3.='../../..'
alias -g 4.='../../../..'
alias -g 5.='../../../../..'
alias -- -='cd -'
for index in {1..9}; do
  alias "$index"="cd +${index}"
done
unset index

alias md='mkdir -p'
alias rd=rmdir

# List directory contents
alias -g P="2>&1| pygmentize -l pytb"

#read documents
alias -s pdf=acroread
alias -s ps=gv
alias -s dvi=xdvi
alias -s chm=xchm
alias -s djvu=djview

#list whats inside packed file
alias -s zip="unzip -l"
alias -s rar="unrar l"
alias -s tar="tar tf"
alias -s tar.gz="echo "
alias -s ace="unace l"

function ipa() {
    if [[ "$(uname)" == "Darwin" ]]; then
        ifconfig | grep inet -w | grep -v 127.0.0.1 | awk '{print $2}'
    elif [[ "$(uname)" == "Linux" ]]; then
        ip a | grep inet -w | awk '{print $2}' | awk -F/ '{print $1}' | grep -v 127.0.0.1
    fi

}

function ipas() {
    if [[ "$(uname)" == "Darwin" ]]; then
        ifconfig | grep inet -w | awk '{print $2}'
    elif [[ "$(uname)" == "Linux" ]]; then
        ip a | grep inet -w | awk '{print $2}' | awk -F/ '{print $1}'
    fi
}

if (( ${+commands[eza]} )); then
    alias ls='eza --color auto --icons -s type'
fi
alias ll='ls -l'
alias l='ll -h'
alias la='l -a'

if (( ${+commands[bat]} )); then
    alias cat='bat -pp --theme Dracula'
fi
if (( ${+commands[starship]} )); then
  eval "$(starship init zsh)"
fi
if (( ${+commands[zoxide]} )); then
  eval "$(zoxide init zsh)"
fi

if (( ${+commands[gitui]} )); then
    alias g=gitui
fi

if (( ${+commands[joshuto]} )); then
    alias ra=joshuto
    alias jo=joshuto
elif (( ${+commands[ranger]} )); then
    alias ra=ranger
fi

if (( ${+commands[neofetch]} )); then
    alias s=neofetch
fi

if (( ${+commands[lazygit]} )); then
    alias lg=lazygit
fi

# for fzf
if (( ${+commands[fzf]} )); then
    eval "$(fzf --zsh)"
fi

if (( ${+commands[nvim]} )); then
    alias vi=nvim
    alias vim=nvim
    export EDITOR=nvim
elif (( ${+commands[vim]} )); then
    alias vi=vim
    export EDITOR=vim
else
    export EDITOR=vi
fi

################################ common end ##################################################
#mirros for rust
export RUSTUP_DIST_SERVER=https://rsproxy.cn
export RUSTUP_UPDATE_ROOT=https://rsporxy.cn/rustup
# curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh | sh
# enable true color
export COLORTERM=truecolor
export TERM=screen-256color

# cmake for lsp
export CMAKE_EXPORT_COMPILE_COMMANDS=ON

export PATH=~/.dotfiles/bin:$PATH
setopt clobber
# proxy for golang
# export GOPROXY=https://mirrors.aliyun.com/goproxy
# replace by command: go env -w GOPROXY=https://goproxy.cn

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
    unset all_proxy

    echo "already close proxy"
}

function allproxy() {
    ip='127.0.0.1'
    port=7890
    if [[ "$#" == "1" ]] then
        ip=$1
    elif [[ "$#" == "2" ]] then
        ip=$1
        port=$2
    fi
    export all_proxy="http://${ip}:${port}"
    export no_proxy='127.0.0.1,localhost,192.168.*.*,10.*.*.*'
    echo "already open proxy with ${ip}:${port}"
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

# for tabby sftp
function precmd () {
    echo -n "\x1b]1337;CurrentDir=$(pwd)\x07"
}
