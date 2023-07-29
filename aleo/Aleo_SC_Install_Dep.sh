#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw mc -y
sudo curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env

cd && git clone https://github.com/AleoHQ/snarkOS.git --depth 1 && cd $HOME/snarkOS
git pull

#bash ./build_ubuntu.sh
cargo install --path .

source $HOME/.bashrc
source $HOME/.cargo/env

# Install Leo
cd && git clone https://github.com/AleoHQ/leo.git

cd $HOME/leo
cargo install --path .

