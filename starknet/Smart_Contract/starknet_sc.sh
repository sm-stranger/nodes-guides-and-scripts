#!/bin/bash

if ! [ -f ~/.bashrc ]; then sudo touch $HOME/.bashrc ;fi


# load functions
#if ! [ -f /root/fn.sh ]; then wget -O fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh ;fi
#curl -S fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh
#source fn.sh

# update && upgrade
sudo apt update && sudo apt upgrade -y

# install dependencies
sudo apt install mc -y

# enter project name
read -p "Project Name:" NAME
echo 'export NAME='$NAME >> $HOME/.bashrc
source $HOME/.bashrc

# Enter Private Key
if [ -z "$PK" ]; then
    read -p "Private Key: " PK
    echo 'export PK='$PK >> $HOME/.bashrc
    source $HOME/.bashrc
fi

# Enter Address
if [ -z "$ADDRESS" ]; then
    read -p "Address: " ADDRESS
    echo 'export ADDRESS='$ADDRESS >> $HOME/.bashrc
    source $HOME/.bashrc
fi

# install Protostar
curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash

# update profile
source $HOME/.bashrc

# initialize
protostar init $NAME

# Change Directory
cd $NAME

# build
protostar build $NAME

# record private key in .env
echo $PK > .env


# declare contract
protostar declare ./build/main.json \
--account-address $ADDRESS \
--max-fee auto \
--private-key-path ./.env \
--network mainnet

