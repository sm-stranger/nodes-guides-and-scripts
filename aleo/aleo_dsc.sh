#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw mc -y

#if ! [ -f /root/fn.sh ]; then
#    wget -O fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh
#fi
#source fn.sh

#curl -s https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh



if [ -z "$PK" ]; then read -p "Private Key: " PK
fi
if [ -z "$VK" ]; then read -p "View Key: " VK
fi
if [ -z "$ADDRESS" ]; then read -p "Address: " ADDRESS
fi


if ! [ -d /root/snarkOS ]; then
    cd && git clone https://github.com/AleoHQ/snarkOS.git --depth 1
    cd $HOME/snarkOS
    bash ./build_ubuntu.sh
fi
source $HOME/.bashrc
source $HOME/.cargo/env

if ! [ -d /root/leo ]; then
    cd && git clone https://github.com/AleoHQ/leo.git
fi
cd $HOME/leo
cargo install --path .

# contract name
read -p "Enter Your Contract Name: " NAME

if ! [ -d /root/leo_deploy ]; then
    mkdir $HOME/leo_deploy
fi
cd $HOME/leo_deploy
leo new $NAME

# tx link
read -p "Link" QUOTE_LINK

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

read -p "Enter Deployment TX Hash: " DH
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
