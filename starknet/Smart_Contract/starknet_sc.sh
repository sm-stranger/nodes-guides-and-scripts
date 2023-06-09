#!/bin/bash

if [ -f ~/.bashrc ]; then profile=".bashrc"
else profile=".bash_profile"
fi

# load functions
if ! [ -f /root/fn.sh ]; then
    wget -O fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh
fi
#curl -S fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh
source fn.sh

# update && upgrade
sudo apt update && sudo apt upgrade -y

# install dependencies
sudo apt install mc -y

# install Protostar
curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash

# update profile
source $HOME/$profile

# enter project name
read -p "Project Name:" NAME

# initialize
protostar init $NAME

# Change Directory
cd $NAME

# build
protostar build $NAME

# Enter Private Key
read -p "Private Key: " PK
echo 'export PK='$PK >> $HOME/$profile
source $HOME/$profile

# record private key in .env
echo $PK > .env

# Enter Address
read -p "Address: " ADDRESS
echo 'export ADDRESS='$ADDRESS >> $HOME/$profile
source $HOME/$profile



# declare contract
protostar declare ./build/main.json \
--account-address $ADDRESS \
--max-fee auto \
--private-key-path ./.env \
--network mainnet

