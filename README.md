# dotfiles

## get source

```shell
    cd ~
    git clone --recursive https://github.com/kabirz/.dotfiles
    cd .dotfiles
```

## install

|  context  |  option  |
|  -------  |  ------  |
| nvchad    |   nv     |
| astro     |   as     |
| gitconfig |   git    |
| tmux      |   tmux   |
| cargo     |   cargo  |
| alacrity  |   ala    |
| starship  |   star   |
| anaconda  |   conda  |
| joshuto   |   jo     |
| gitui     |   gitui  |
| zimfw     |   zim    |

```shell
    ./install.sh [as]...
```

then open tmux and input key prefix + I for install tmux plugin
apply network plugin for tmux

```shell
    cd ~/.tmux/plugins/tmux
    git am ~/.dotfiles/pathches/network-show-ip-address.patch
```
