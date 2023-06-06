#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw mc -y
sudo curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

#curl -s https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh
if ! [ -f /root/fn.sh ]; then
    wget -O fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh
fi
source fn.sh


# install snarkOS
if ! [ -d /root/snarkOS ]; then
    cd && git clone https://github.com/AleoHQ/snarkOS.git --depth 1 && cd $HOME/snarkOS
    git pull
    #bash ./build_ubuntu.sh
    cargo install --path .
    
fi
source $HOME/.bashrc
source $HOME/.cargo/env


# install leo
if ! [ -d /root/leo ]; then
    cd && git clone https://github.com/AleoHQ/leo.git
fi
cd $HOME/leo
cargo install --path .

# keys
if [ -z "$PK" ]; then
    read -p "Enter Your Private Key: " "PK"
    echo 'export PK='$PK >> $HOME/.bashrc
fi
if [ -z "$VK" ]; then
    read -p "Enter Your View Key: " VK
    echo 'export VK='$VK >> $HOME/.bashrc
fi
if [ -z "$ADDRESS" ]; then
    read -p "Enter Your Address: " ADDRESS
    echo 'export ADDRESS='$ADDRESS >> $HOME/.bashrc
fi
source $HOME/.bashrc

# contract name
read -p "Enter Your Contract Name: " NAME

# Make Directory Leo Deploy And Create New Project
if ! [ -d /root/leo_deploy ]; then
    mkdir $HOME/leo_deploy
fi
cd $HOME/leo_deploy
leo new $NAME


# Link
if [ -z "$QUOTE_LINK" ]; then
    read -p "Enter Your Hash: " QUOTE_LINK
    echo 'export QUOTE_LINK='$QUOTE_LINK >> $HOME/.bashrc
fi


#################################### Deploy ####################################


CIPHERTEXT=$(curl -s "$QUOTE_LINK" | jq -r '.execution.transitions[0].outputs[0].value')
RECORD=$(snarkos developer decrypt --ciphertext $CIPHERTEXT --view-key $VK)

snarkos developer deploy "$NAME.aleo" \
--private-key "$PK" \
--query "https://vm.aleo.org/api" \
--path "$HOME/leo_deploy/$NAME/build/" \
--broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
--fee 4000000 \
--record "$RECORD"

read -p "Enter Deployment TX Hash: " DH
QUOTE_LINK="https://vm.aleo.org/api/testnet3/transaction/"$DH
echo 'export QUOTE_LINK='$QUOTE_LINK >> $HOME/.bash_profile
source $HOME/.bash_profile



#################################### Execute ####################################

CIPHERTEXT=$(curl -s $QUOTE_LINK | jq -r '.fee.transition.outputs[].value')
RECORD=$(snarkos developer decrypt --ciphertext $CIPHERTEXT --view-key $VK)


snarkos developer execute "$NAME.aleo" "hello" "1u32" "2u32" \
--private-key "$PK" \
--query "https://vm.aleo.org/api" \
--broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
--fee 4000000 \
--record "$RECORD"

read -p "Enter Execution TX Hash Or Link: " EH
QUOTE_LINK="https://vm.aleo.org/api/testnet3/transaction/"$EH
echo 'export QUOTE_LINK='$QUOTE_LINK >> $HOME/.bash_profile
source $HOME/.bash_profile




# Scan
snarkos developer scan --endpoint https://vm.aleo.org/api --start 100000 --end 104550 --view-key $VK

# Create Account
snarkos account new
