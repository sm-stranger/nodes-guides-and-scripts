#!/bin/bash

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

sudo apt update && sudo apt upgrade -y
sudo apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw -y

read -p "Enter Your Private Key: " PK
echo 'export PK='$PK >> $HOME/.bash_profile
read -p "Enter Your View Key: " VK
echo 'export VK='$VK >> $HOME/.bash_profile
read -p "Enter Your Address: " ADDRESS
echo 'export ADDRESS='$ADDRESS >> $HOME/.bash_profile


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
read -p "Enter the Name of your contract: " NAME
echo 'export NAME='$NAME >> $HOME/.bash_profile

mkdir $HOME/leo_deploy && cd $HOME/leo_deploy
leo new $NAME

# faucet link
read -p "Paste The Faucet Link: " QUOTE_LINK
echo 'export QUOTE_LINK='$QUOTE_LINK >> $HOME/.bash_profile

CIPHERTEXT=$(curl -s $QUOTE_LINK | jq -r '.execution.transitions[0].outputs[0].value')

RECORD=$(snarkos developer decrypt --ciphertext $CIPHERTEXT --view-key $VK)


#################################### Deploy ####################################

snarkos developer deploy "$NAME.aleo" \
--private-key "$PK" \
--query "https://vm.aleo.org/api" \
--path "$HOME/leo_deploy/$NAME/build/" \
--broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
--fee 4000000 \
--record "$RECORD"



#################################### Execute ####################################

read -p "Enter Deployment TX Hash: " aleo_dtxh
DL="https://vm.aleo.org/api/testnet3/transaction/"$DH
echo 'export DH='$DH >> $HOME/.bash_profile

CIPHERTEXT=$(curl -s $DL | jq -r '.fee.transition.outputs[].value')
RECORD=$(snarkos developer decrypt --ciphertext $CIPHERTEXT --view-key $VK)


snarkos developer execute "$NAME.aleo" "hello" "1u32" "2u32" \
--private-key "$PK" \
--query "https://vm.aleo.org/api" \
--broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
--fee 4000000 \
--record "$RECORD"


