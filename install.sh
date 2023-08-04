#!/bin/bash

# install nvim for NvChad
install_nvim_nvchad() {
  pushd nvim/NvChad || exit
  rm -fr base/lua/custom
  rm -fr ~/.config/nvim
  ln -s "$(pwd)"/custom base/lua
  ln -s "$(pwd)"/base ~/.config/nvim
  popd || exit
}

# install nvim for AstroNvim
install_nvim_astro() {
  pushd nvim/AstroNvim || exit
  rm -fr base/lua/user
  rm -fr ~/.config/nvim
  ln -s "$(pwd)"/user base/lua
  ln -s "$(pwd)"/base ~/.config/nvim
  popd || exit
}

for element in "$@"; do
  if [ "$element" == "nv" ]; then
    install_nvim_nvchad
  elif [ "$element" == "as" ]; then
    install_nvim_astro
  elif [ "$element" == "git" ]; then
    ln -s "$(pwd)"/.gitconfig ~
  elif [ "$element" == "tmux" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ln -s "$(pwd)"/.tmux.conf ~
  elif [ "$element" == "cargo" ]; then
    ln -s "$(pwd)"/.cargo_config.toml ~/.cargo/config
  elif [ "$element" == "ala" ]; then
    ln -s "$(pwd)"/alacritty ~/.config
  elif [ "$element" == "star" ]; then
    ln -s "$(pwd)"/starship.toml ~/.config
  elif [ "$element" == "conda" ]; then
    ln -s "$(pwd)"/.condarc ~/.condarc
  elif [ "$element" == "jo" ]; then
    ln -s "$(pwd)"/joshuto ~/.config
  elif [ "$element" == "gitui" ]; then
    ln -s "$(pwd)"/gitui ~/.config
  elif [ "$element" == "zim" ]; then
    pushd zimfw || exit
    ./install.sh
    popd || exit
  fi
done
