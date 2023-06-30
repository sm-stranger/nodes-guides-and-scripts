#!/bin/bash

# update && upgrade
sudo apt update && sudo apt upgrade -y

# Install Docker
sudo apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# install node
git clone https://github.com/taikoxyz/simple-taiko-node.git && cd simple-taiko-node

# copy the .env.sample to a new file .env
cp .env.sample .env

# set vars L1_ENDPOINT_HTTP, L1_ENDPOINT_WS, L1_PROVER_PRIVATE_KEY
read -p "Enter L1_ENDPOINT_HTTP:  " L1_ENDPOINT_HTTP
echo "L1_ENDPOINT_HTTP=${L1_ENDPOINT_HTTP}" >> $HOME/simple-taiko-node/.env

read -p "Enter L1_ENDPOINT_WS:  " L1_ENDPOINT_WS
echo "L1_ENDPOINT_WS=${L1_ENDPOINT_WS}" >> .env

read -p "Enter L1_PROVER_PRIVATE_KEY: " L1_PROVER_PRIVATE_KEY
echo "L1_PROVER_PRIVATE_KEY=${L1_PROVER_PRIVATE_KEY}" >> .env

# replace ENABLE_PROVER с false на true
sed -i 's/ENABLE_PROVER=false/ENABLE_PROVER=true/' .env

# start
docker compose up -d

# logs
docker compose logs -f
