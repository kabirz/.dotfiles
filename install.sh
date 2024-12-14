#!/bin/zsh

# install nvim for AstroNvim
install_nvim_astro() {
  rm -fr ~/.config/nvim
  ln -s "$(pwd)"/nvim_user ~/.config/nvim
}

for element in "$@"; do
  if [[ "$element" == "nv" ]]; then
    install_nvim_nvchad
  elif [[ "$element" == "as" ]]; then
    install_nvim_astro
  elif [[ "$element" == "git" ]]; then
    rm -fr ~/.gitconfig
    ln -s "$(pwd)"/.gitconfig ~
  elif [[ "$element" == "tmux" ]]; then
    if [[ ! -d ~/.tmux/plugins/tpm ]]; then
      git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
    rm -fr ~/.tmux.conf
    ln -s "$(pwd)"/.tmux.conf ~
  elif [[ "$element" == "cargo" ]]; then
    ln -s "$(pwd)"/.cargo_config.toml ~/.cargo/config
  elif [[ "$element" == "ala" ]]; then
    ln -s "$(pwd)"/alacritty ~/.config
  elif [[ "$element" == "star" ]]; then
    ln -s "$(pwd)"/starship.toml ~/.config
  elif [[ "$element" == "conda" ]]; then
    wget -q -O - micro.mamba.pm/install.sh | bash
  elif [[ "$element" == "jo" ]]; then
    ln -s "$(pwd)"/joshuto ~/.config
  elif [[ "$element" == "gitui" ]]; then
    ln -s "$(pwd)"/gitui ~/.config
  elif [[ "$element" == "neofetch" ]]; then
    ln -s "$(pwd)"/neofetch ~/.config
  elif [[ "$element" == "zellij" ]]; then
    ln -s "$(pwd)"/zellij ~/.config
    if [[ ! -f zellij/zjstatus.wasm ]]; then
      wget https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm -O zellij/zjstatus.wasm
    fi
  elif [[ "$element" == "ssh" ]]; then
    if [[ ! -d ids ]]; then
      git clone https://github.com/kabirz/myid ids
    fi
    chmod 0400 ids/ssh/id_rsa
    ln -s "$(pwd)"/ids/ssh/config ~/.ssh
  elif [[ "$element" == "netrc" ]]; then
    if [[ ! -d ids ]]; then
      git clone https://github.com/kabirz/myid ids
    fi
    ln -s "$(pwd)"/ids/.netrc ~
  elif [[ "$element" == "zim" ]]; then
    pushd zimfw || exit
    ./install.sh
    popd || exit
  fi
done
