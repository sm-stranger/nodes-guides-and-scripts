#!/bin/bash

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

sudo apt update && sudo apt upgrade -y
sudo apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw mc -y

wget -O functions.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/functions.sh
source functions.sh

enter_val "Private Key" PK
enter_val "View Key" VK
enter_val "Address" ADDRESS


cd && git clone https://github.com/AleoHQ/snarkOS.git --depth 1
cd $HOME/snarkOS
bash ./build_ubuntu.sh
source $HOME/.bashrc
source $HOME/.cargo/env

cd && git clone https://github.com/AleoHQ/leo.git
cd $HOME/leo
cargo install --path .

# contract name
enter_val "Contract Name" NAME

mkdir $HOME/leo_deploy && cd $HOME/leo_deploy
leo new $NAME

# faucet link
enter_val "Faucet Link" QUOTE_LINK

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
