#!/bin/bash

while true
do

    PS3="Choose option and press Enter: "
    options=("Install" "Delete")
    select opt in "${options[@]}"
    do

        case $opt in

            ######################################## Install ########################################

            "Install")

                # install dependencies
                sudo apt update
                sudo apt install -y curl git jq lz4 build-essential
                sudo rm -rf /usr/local/go
                sudo curl -Ls https://go.dev/dl/go1.19.linux-amd64.tar.gz | sudo tar -C /usr/local -xz
                echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile
                source $HOME/.profile

                ############ Download/compile and install seid ############

                cd $HOME
                rm -rf sei-chain
                git clone https://github.com/sei-protocol/sei-chain.git
                cd sei-chain

                # compile version 2.0.34beta-atlantic-2
                git checkout 2.0.34beta-atlantic-2
                make build
                mkdir -p $HOME/.sei/cosmovisor/genesis/bin
                mv build/seid $HOME/.sei/cosmovisor/genesis/bin/

                # compile version 2.0.37beta
                git checkout 2.0.37beta
                make build
                mkdir -p $HOME/.sei/cosmovisor/upgrades/2.0.37beta/bin
                mv build/seid $HOME/.sei/cosmovisor/upgrades/2.0.37beta/bin/

                # Compile version 2.0.40beta
                git checkout 2.0.40beta
                make build
                mkdir -p $HOME/.sei/cosmovisor/upgrades/2.0.40beta/bin
                mv build/seid $HOME/.sei/cosmovisor/upgrades/2.0.40beta/bin/

                # Install cosmovisor and service
                curl -Ls https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2Fv1.3.0/cosmovisor-v1.3.0-linux-amd64.tar.gz | tar xz
                chmod 755 cosmovisor
                sudo mv cosmovisor /usr/bin/cosmovisor

                echo '[Unit]
                Description=Sei Atlantic 2 Node Service
                After=network-online.target
                [Service]
                User=$USER
                ExecStart=/usr/bin/cosmovisor run start
                Restart=on-failure
                RestartSec=10
                LimitNOFILE=8192
                Environment="DAEMON_HOME=$HOME/.sei"
                Environment="DAEMON_NAME=seid"
                Environment="UNSAFE_SKIP_BACKUP=true"
                [Install]
                WantedBy=multi-user.target' > $HOME/seid.service
                
                sudo systemctl daemon-reload
                sudo systemctl enable seid

                # Initialize the node
                read -p "Enter Node Name: " MONIKER
                echo 'export MONIKER='${MONIKER} >> $HOME/.profile
                source $HOME/.profile


                ln -s $HOME/.sei/cosmovisor/upgrades/2.0.40beta $HOME/.sei/cosmovisor/current
                sudo ln -s $HOME/.sei/cosmovisor/current/bin/seid /usr/local/bin/seid
                seid config chain-id atlantic-2
                seid init $MONIKER --chain-id atlantic-2
                curl -Ls https://raw.githubusercontent.com/sei-protocol/testnet/main/atlantic-2/genesis.json > $HOME/.sei/config/genesis.json
                sed -i -e "s|^bootstrap-peers *=.*|bootstrap-peers = \"f97a75fb69d3a5fe893dca7c8d238ccc0bd66a8f@sei-testnet-2.seed.brocha.in:30587\"|" $HOME/.sei/config/config.toml
                echo '
                {
                "height": "0",
                "round": 0,
                "step": 0
                }' > $HOME/.sei/data/priv_validator_state.json
                
                sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001usei\"|" $HOME/.sei/config/app.toml
                sed -i -e "s|^pruning *=.*|pruning = \"custom\"|" $HOME/.sei/config/app.toml
                sed -i -e "s|^pruning-keep-recent *=.*|pruning-keep-recent = \"3000\"|" $HOME/.sei/config/app.toml
                sed -i -e "s|^pruning-keep-every *=.*|pruning-keep-every = \"0\"|" $HOME/.sei/config/app.toml
                sed -i -e "s|^pruning-interval *=.*|pruning-interval = \"10\"|" $HOME/.sei/config/app.toml
                sed -i -e "s|^snapshot-interval *=.*|snapshot-interval = \"1000\"|" $HOME/.sei/config/app.toml
                sed -i -e "s|^snapshot-keep-recent *=.*|snapshot-keep-recent = \"2\"|" $HOME/.sei/config/app.toml


            break
            ;;

        esac


    done

done
