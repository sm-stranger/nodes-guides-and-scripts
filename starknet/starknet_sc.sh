#!/bin/bash

######################## FUNCTIONS ########################

enter_val(){
    v=''
    until [ ${#v} -gt 0 ]
    do
        read -p "Enter Your $1: " v
    done
    ${2}=$v

}

exists()
{
  command -v "$1" >/dev/null 2>&1
}

if ! [ -f ~/.bashrc ]; then sudo touch $HOME/.bashrc ;fi


# load functions
if ! [ -f /root/fn.sh ]; then wget -O fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh ;fi
#curl https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh | bash
source fn.sh

# update && upgrade
echo '============= UPGRADE ===========' && sleep 1
sudo apt update && sudo apt upgrade -y

# install dependencies
sudo apt install mc -y

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
if ! [ -d /root/.protostar ]; then
    curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash
fi
source $HOME/.bashrc

# install Scarb
if exists scarb; then echo ''
else curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
fi

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
protostar declare ./build/main.json \
--account-address $ADDRESS \
--max-fee auto \
--private-key-path ./.env \
--network mainnet

