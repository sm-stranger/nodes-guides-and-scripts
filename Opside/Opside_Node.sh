#!/bin/bash

if ! [ -d /root/testnet-auto-install-v3 ]; then
    wget -c https://pre-alpha-download.opside.network/testnet-auto-install-v3.tar.gz
    tar -C ./ -xzf testnet-auto-install-v3.tar.gz
    chmod +x -R ./testnet-auto-install-v3
fi;

cd testnet-auto-install-v3
./install-ubuntu-1.0.sh
