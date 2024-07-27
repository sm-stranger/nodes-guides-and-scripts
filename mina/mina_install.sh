#!/bin/bash

# update && upgrade
sudo apt update && sudo apt upgrade && sudo apt install mc -y

# install Docker
sudo apt install docker.io curl -y
sudo systemctl start docker
sudo systemctl enable docker

# install Mina
sudo rm /etc/apt/sources.list.d/mina*.list
sudo echo "deb [trusted=yes] http://packages.o1test.net $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/mina.list
sudo apt update
sudo apt install -y curl unzip mina-mainnet=3.0.0-93e0279

# set permission
chmod 700 $HOME/keys
chmod 600 $HOME/keys/my-wallet

# open ports 8302 and 8303
sudo iptables -A INPUT -p tcp --dport 8302:8303 -j ACCEPT

# set var
KEYPATH=$HOME/keys/my-wallet
MINA_PUBLIC_KEY=$(cat $HOME/keys/my-wallet.pub)

# run
sudo docker run --name mina -d \
--restart always \
-p 8302:8302 \
-p 127.0.0.1:3085:3085 \
-v $(pwd)/keys:/root/keys:ro \
-v $(pwd)/.mina-config:/root/.mina-config \
minaprotocol/mina-daemon:3.0.0-93e0279-focal-mainnet daemon \
--peer-list-url https://storage.googleapis.com/mina-seed-lists/mainnet_seeds.txt \
--snark-worker-fee 0.025 \
--run-snark-worker $MINA_PUBLIC_KEY \
--insecure-rest-server \
--file-log-level Debug \
-log-level Info
