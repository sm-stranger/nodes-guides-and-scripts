#!/bin/bash

# load functions
if ! [ -f /root/fn.sh ]; then
    wget -O fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh
fi
#curl -S fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh | bash
source fn.sh

# update && upgrade
sudo apt update && sudo apt upgrade -y

# install dependencies
if ! [ exists mc ]; then 
    sudo apt install mc -y
fi

# install Protostar
if ! [ -d /root/protostar ]; then
    curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | sh
    source $HOME/.bashrc
fi

if ! [ exists scarb ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
fi


# enter project name
enter_val "Project Name" NAME

# initialize
cd $NAME && protostar init $NAME

# build
protostar build $NAME

# Enter Private Key
enter_val "Private Key" PK
echo 'export PK='$PK >> $HOME/.bashrc
source $HOME/.bashrc

# Enter Address
enter_val "Address" ADDRESS
echo 'export PK='$PK >> $HOME/.bashrc
source $HOME/.bashrc


# record private key in .env
echo $PK > .env


# declare contract
protostar declare ./build/main.json \
--account-address $ADDR \
--max-fee auto \
--private-key-path ./.env \
--network mainnet
