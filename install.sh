#!/bin/bash
# enter bash
# source thisfile
# install_xxx

# install nvim
install_nvim_nvchad() {
  pushd nvim/NvChad || exit
  rm -fr base/lua/custom
  rm -fr ~/.config/nvim
  ln -s "$(pwd)"/custom base/lua/custom
  ln -s "$(pwd)"/base ~/.config/nvim
  popd || exit
}
install_nvim_astro() {
  pushd nvim/AstroNvim || exit
  rm -fr base/lua/user
  rm -fr ~/.config/nvim
  ln -s "$(pwd)"/user base/lua/user
  ln -s "$(pwd)"/base ~/.config/nvim
  popd || exit
}

# install gitconfig
install_gitconfig() {
  ln -s "$(pwd)"/.gitconfig ~/.gitconfig
}

# install tmux
install_tmux() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ln -s "$(pwd)"/tmux.conf ~/.tmux.conf
}

# install cargo_config
install_cargo_config() {
  ln -s "$(pwd)"/cargo_config.toml ~/.cargo/config
}

# install alacritty
install_alacritty() {
  ln -s "$(pwd)"/alacritty ~/.config/alacritty
}

# install starship
install_starship() {
  ln -s "$(pwd)"/starship.toml ~/.config/starship.toml
}

# install anaconda
install_anaconda() {
  ln -s "$(pwd)"/anaconda.yml ~/.condarc
}

# install joshuto
install_joshuto() {
  ln -s "$(pwd)"/joshuto ~/.config/joshuto
}

# install gitui
install_gitui() {
  ln -s "$(pwd)"/gitui ~/.config/gitui
}

# install zimfw
install_zim() {
  pushd zimfw || exit
  ./install.sh
  popd || exit
}

for element in "$@"; do
  if [ "$element" == "nv" ]; then
    install_nvim_nvchad
  elif [ "$element" == "as" ]; then
    install_nvim_astro
  elif [ "$element" == "git" ]; then
    install_gitconfig
  elif [ "$element" == "tmux" ]; then
    install_tmux
  elif [ "$element" == "cargo" ]; then
    install_cargo_config
  elif [ "$element" == "ala" ]; then
    install_alacritty
  elif [ "$element" == "star" ]; then
    install_starship
  elif [ "$element" == "conda" ]; then
    install_anaconda
  elif [ "$element" == "jo" ]; then
    install_joshuto
  elif [ "$element" == "gitui" ]; then
    install_gitui
  elif [ "$element" == "zim" ]; then
    install_zim
  fi
done
