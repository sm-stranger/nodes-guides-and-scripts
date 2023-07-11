#!/bin/bash


if ! [ -f ~/.bashrc ]; then sudo touch $HOME/.bashrc ;fi


# load functions
#if ! [ -f /root/fn.sh ]; then wget -O fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh ;fi
#curl https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh | bash
#source fn.sh



# update && upgrade
sudo apt update && sudo apt upgrade -y

# install dependencies
sudo apt install mc -y


# install Protostar
if ! [ -d /root/.protostar ]; then curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash && source $HOME/.bashrc ;fi

# install Scarb
if exists scarb; then echo ''
else curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh && source $HOME/.bashrc && scarb --version
fi

# Enter Private Key
if [ -z "$PK" ]; then read -p "Private Key: " PK && echo 'PK='$PK >> $HOME/.bashrc ;fi

# Enter Address
if [ -z "$ADDRESS" ]; then read -p "Address: " ADDRESS && echo 'ADDRESS='$ADDRESS >> $HOME/.bashrc ;fi

source $HOME/.bashrc

# enter project name
read -p "Project Name:" NAME

# initialize
protostar init $NAME

# Change Directory
cd $NAME


# build
protostar build --contract-name $NAME

# record private key in .env
echo $PK > .env


# declare contract
protostar declare $NAME \
--account-address $ADDRESS \
--max-fee auto \
--private-key-path ./.env \
--network testnet

