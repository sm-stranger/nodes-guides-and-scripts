#!/bin/bash

sudo apt update & sudo apt upgrade -y
sudo apt install ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev curl git wget make jq build-essential pkg-config lsb-release libssl-dev libreadline-dev libffi-dev gcc screen unzip lz4 -y

wget https://github.com/fractal-bitcoin/fractald-release/releases/download/v0.1.8/fractald-0.1.8-x86_64-linux-gnu.tar.gz
tar -zxvf fractald-0.1.8-x86_64-linux-gnu.tar.gz 

cd fractald-0.1.8-x86_64-linux-gnu/
mkdir data
cp ./bitcoin.conf ./data

sudo tee /etc/systemd/system/fractald.service > /dev/null << EOF
[Unit]
Description=Fractal Node
After=network-online.target
[Service]
User=$USER
ExecStart=/root/fractald-0.1.8-x86_64-linux-gnu/bin/bitcoind -datadir=/root/fractald-0.1.8-x86_64-linux-gnu/data/ -maxtipage=504576000
Restart=always
RestartSec=5
LimitNOFILE=infinity
[Install]
WantedBy=multi-user.target
EOF

cd bin

./bitcoin-wallet -wallet=wallet -legacy create

cd /root/fractald-0.1.8-x86_64-linux-gnu/bin

./bitcoin-wallet -wallet=/root/.bitcoin/wallets/wallet/wallet.dat -dumpfile=/root/.bitcoin/wallets/wallet/MyPK.dat dump

cd && awk -F 'checksum,' '/checksum/ {print "Wallet Private Key:" $2}' .bitcoin/wallets/wallet/MyPK.dat

sudo systemctl daemon-reload
sudo systemctl enable fractald
sudo systemctl start fractald

sudo journalctl -u fractald -f --no-hostname -o cat
