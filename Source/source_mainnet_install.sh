#!/bin/bash

# delete old node
sudo systemctl stop sourced && \
cd $HOME && \
rm -rf .source && \
rm -rf source && \
rm -rf $(which sourced)



# prepare server
sudo apt update && sudo apt upgrade -y && \
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y

