#!/bin/bash


PS3="Choose Action And Press Enter: "
options=(
    "Backup"
    "Delete Old Node"
    "Install"
    "Statesync"
    "Snapshot"
    "Commands"
)
select opt in "${options[@]}"
do
    case $opt in

        #################################################### BACKUP ####################################################

        "Backup")

            cp $HOME/.source/data/priv_validator_state.json $HOME/.source/priv_validator_state.json.backup
            rm -rf $HOME/.source/data

        ;;

        #################################################### DELETE OLD NODE ####################################################
        
        "Delete Old Node")

            sudo systemctl stop sourced && \
            cd $HOME && \
            rm -rf .source && \
            rm -rf source && \
            rm -rf $(which sourced)

        ;;

        
        #################################################### INSTALL ############################################################

        "Install")

            # Prepare Server
            sudo apt update && sudo apt upgrade -y && \
            sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop lz4 mc -y

            # Install GO
            ver="1.19" && \
            wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
            sudo rm -rf /usr/local/go && \
            sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
            rm "go$ver.linux-amd64.tar.gz" && \
            echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
            source $HOME/.bash_profile && \
            go version


            # Clone Source Chain Repo
            git clone https://github.com/Source-Protocol-Cosmos/source.git


            # Compile Sourced Binary
            cd ~/source && \
            git fetch && \
            git checkout v3.0.0 && \
            make build && make install


            # Initialization
            read -p "Enter Your Validator Name: " MONIKER
            sourced init $MONIKER --chain-id=source-1


            # Creating Keys
            read -p "Enter Your Wallet Name: " WALLET
            PS3="Create New Or Restore Existing Keys?"
            options=("Create New" "Restore Existing")
            select opt in "${options[@]}"
            do
                case $opt in
                    
                    "Create New")
                        sourced keys add $WALLET
                    ;;

                    "Restore Existing")
                        sourced keys add $WALLET --recover
                    ;;
                    
                esac
            done



            # Download Genesys
            curl -s  https://raw.githubusercontent.com/Source-Protocol-Cosmos/mainnet/master/source-1/genesis.json > ~/.source/config/genesis.json


            # Set Peers And Minimum Gas Price
            sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.25usource\"/;" ~/.source/config/app.toml && \
            external_address=$(wget -qO- eth0.me) &&  \
            sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.source/config/config.toml && \
            peers="96d63849a529a15f037a28c276ea6e3ac2449695@34.222.1.252:26656,0107ac60e43f3b3d395fea706cb54877a3241d21@35.87.85.162:26656" && \
            sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.source/config/config.toml && \
            seeds="" && \
            sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.source/config/config.toml && \
            sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.source/config/config.toml && \
            sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.source/config/config.toml


            # Download Addrbook
            wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Projects/Source/addrbook.json"


            # Creating Service File
            echo "
            [Unit]
            Description=source
            After=network-online.target

            [Service]
            User=$USER
            ExecStart=$(which sourced) start
            Restart=on-failure
            RestartSec=3
            LimitNOFILE=65535

            [Install]
            WantedBy=multi-user.target" >> /etc/systemd/system/sourced.service


            # StateSync
            SNAP_RPC=https://source.rpc.m.stavr.tech:443 && \
            peers="3c729ffe80393abd430a7c723fab2e8aa60ffa46@source.peers.stavr.tech:20056" && \
            sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.source/config/config.toml && \
            LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
            BLOCK_HEIGHT=$((LATEST_HEIGHT - 100)); \
            TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

            echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
            s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.source/config/config.toml
            sourced tendermint unsafe-reset-all
            systemctl restart sourced


            # Snapshot
            cd $HOME && \
            apt install lz4 && \
            sudo systemctl stop sourced && \
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" ~/.source/config/config.toml && \
            cp $HOME/.source/data/priv_validator_state.json $HOME/.source/priv_validator_state.json.backup && \
            rm -rf $HOME/.source/data &&  \
            curl -o - -L https://source-m.snapshot.stavr.tech/source/source-snap.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.source --strip-components 2 && \
            wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Projects/Source/addrbook.json" && \
            mv $HOME/.source/priv_validator_state.json.backup $HOME/.source/data/priv_validator_state.json && \
            sudo systemctl restart sourced


            # Start Node
            sudo systemctl daemon-reload &&
            sudo systemctl enable sourced &&
            sudo systemctl restart sourced && sudo journalctl -u sourced -f -o cat

        ;;


        #################################################### STATESYNC ############################################################

        "StateSync")

            SNAP_RPC=https://source.rpc.m.stavr.tech:443 && \
            peers="3c729ffe80393abd430a7c723fab2e8aa60ffa46@source.peers.stavr.tech:20056" && \
            sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.source/config/config.toml && \
            LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
            BLOCK_HEIGHT=$((LATEST_HEIGHT - 100)); \
            TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

            echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
            s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
            s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
            s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
            s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.source/config/config.toml
            sourced tendermint unsafe-reset-all
            systemctl restart sourced

        ;;


        #################################################### SNAPSHOT ############################################################

        "Snapshot")

            cd $HOME && \
            apt install lz4 && \
            sudo systemctl stop sourced && \
            sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" ~/.source/config/config.toml && \
            cp $HOME/.source/data/priv_validator_state.json $HOME/.source/priv_validator_state.json.backup && \
            rm -rf $HOME/.source/data &&  \
            curl -o - -L https://source-m.snapshot.stavr.tech/source/source-snap.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.source --strip-components 2 && \
            wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Projects/Source/addrbook.json" && \
            mv $HOME/.source/priv_validator_state.json.backup $HOME/.source/data/priv_validator_state.json && \
            sudo systemctl restart sourced
        
        ;;




        #################################################### COMMANDS ############################################################

        "Commands")
            PS3="Choose Command And Press Enter: "
            options=(
                "Source Node Start"
                "Source Node Stop"
                "Source Node Status"

                "Sourced Service Enable"
                "Sourced Service Start"
                "Sourced Service Stop"

                "Sourced Service Restart"
                "Sourced Service Status"

                "Show Logs"
                "Daemon Reload"
                ""
            )
            select opt in "${options[@]}"
            do
                case $opt in

                    "Source Node Start")
                        sourced start
                    ;;

                    "Source Node Stop")
                        sourced stop
                    ;;

                    "Source Node Status")
                        sourced status
                    ;;

                    "Sourced Service Enable")
                        sudo systemctl enable sourced
                    ;;
                
                    "Sourced Service Disable")
                        sudo systemctl disable sourced
                    ;;

                    "Sourced Service Start")
                        sudo systemctl start sourced
                    ;;

                    "Sourced Service Stop")
                        sudo systemctl stop sourced
                    ;;

                    "Sourced Service Restart")
                        sudo systemctl restart sourced
                    ;;


                    "Sourced Service Status")
                        sudo systemctl status sourced
                    ;;

                    "Show Logs")
                        sudo journalctl -u sourced -f -o cat
                    ;;
                
                    "Daemon Reload")
                        sudo systemctl daemon-reload
                    ;;

                esac
            done
        ;;

    esac
done

