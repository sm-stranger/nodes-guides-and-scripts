#!/bin/bash

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

sudo apt update && sudo apt upgrade -y
sudo apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw -y

read -p "Enter Your Private Key: " aleo_pk
echo 'export aleo_pk='$aleo_pk >> $HOME/.bash_profile
read -p "Enter Your View Key: " aleo_vk
echo 'export aleo_vk='$aleo_vk >> $HOME/.bash_profile
read -p "Enter Your Address: " aleo_addr
echo 'export aleo_addr='$aleo_addr >> $HOME/.bash_profile


cd $HOME
git clone https://github.com/AleoHQ/snarkOS.git --depth 1
cd snarkOS
bash ./build_ubuntu.sh
source $HOME/.bashrc
source $HOME/.cargo/env

cd $HOME
git clone https://github.com/AleoHQ/leo.git
cd leo
cargo install --path .

# contract name
read -p "Enter the Name of your contract: " aleo_cn
echo 'export aleo_cn='$aleo_cn >> $HOME/.bash_profile

mkdir $HOME/leo_deploy && cd $HOME/leo_deploy
leo new $aleo_cn

# faucet link
read -p "Paste The Faucet Link: " aleo_fl
echo 'export aleo_fl='$aleo_fl >> $HOME/.bash_profile

ct=$(curl -s $aleo_fl | jq -r '.execution.transitions[0].outputs[0].value')

rec=$(snarkos developer decrypt --ciphertext $ct --view-key $aleo_vk)
