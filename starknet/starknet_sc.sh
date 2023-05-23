#!/bin/bash

# load functions
wget -O fn.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/fn.sh
source fn.sh

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

# update && upgrade
sudo apt update && sudo apt upgrade -y

# install dependencies
check_install curl
sudo apt install curl mc -y

# install Protostar
curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash

# update profile
source $HOME/.bash_profile

# enter project name
enter_val "Project Name" NAME

# initialize
protostar init $NAME

# Change Directory
cd $NAME

# build
protostar build

# Enter Private Key
enter_val "Private Key" PK

# record private key in .env
echo $PK .env


# declare contract
protostar declare ./build/main.json \
--account-address $ADDRESS \
--max-fee auto \
--private-key-path ./.env \
--network mainnet

