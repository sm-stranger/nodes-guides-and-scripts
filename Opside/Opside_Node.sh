#!/bin/bash

if ! [ -d /root/./testnet-auto-install-v2 ]; then
    wget -c https://pre-alpha-download.opside.network/testnet-auto-install-v2.tar.gz
    tar -C ./ -xzf testnet-auto-install-v2.tar.gz
    chmod +x -R ./testnet-auto-install-v2
    cd ./testnet-auto-install-v2
else
    cd ./testnet-auto-install-v2
    ./install-ubuntu-en-1.0.sh
fi;
