#!/bin/bash

# update && upgrade
sudo apt update && sudo apt upgrade -y

### install Docker ###

# install package
sudo apt install ca-certificates curl gnupg

# add GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# set up repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install node
git clone https://github.com/taikoxyz/simple-taiko-node.git
cd simple-taiko-node

# copy the .env.sample to a new file .env
cp .env.sample .env

# enter your variables

read -p "Enter Your L1_ENDPOINT_HTTP: " L1_ENDPOINT_HTTP
echo "L1_ENDPOINT_HTTP=${L1_ENDPOINT_HTTP}" >> .env
read -p "Enter Your L1_ENDPOINT_WS: " L1_ENDPOINT_WS
echo "L1_ENDPOINT_WS=${L1_ENDPOINT_WS}" >> .env

