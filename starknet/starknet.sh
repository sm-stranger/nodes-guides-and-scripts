#!/bin/bash

while true
do

PS3="Choose option and press Enter: "
options=("Install Starknet" "Create Backup" "Check Node Status" "Show Logs" "Exit")
select opt in "${options[@]}"
do
    case $opt in
    
        ######################################## Install Starknet ########################################
        "Install Starknet")
            
            # update && upgrade
            sudo apt update && sudo apt upgrade -y

            # install dependencies
            sudo apt update && sudo apt install software-properties-common -y
            sudo add-apt-repository ppa:deadsnakes/ppa -y
            sudo apt install curl git tmux python3 python3-venv python3-dev build-essential libgmp-dev pkg-config libssl-dev mc -y
            
            # install Rust
            sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
            source $HOME/.cargo/env
            rustup update stable --force

            
            cd $HOME
            git clone https://github.com/eqlabs/pathfinder.git
            cd $HOME/pathfinder/py
            python3 -m venv .venv
            source .venv/bin/activate
            PIP_REQUIRE_VIRTUALENV=true pip install --upgrade pip
            PIP_REQUIRE_VIRTUALENV=true pip install -r requirements-dev.txt
            pytest
            cd $HOME/pathfinder
            cargo +stable build --release --bin pathfinder
            cd $home

            source $HOME/.bash_profile
            mv ~/pathfinder/target/release/pathfinder /usr/local/bin/

            echo "
                [Unit]
                    Description=StarkNet
                    After=network.target
                [Service]
                    User=$USER
                    Type=simple
                    WorkingDirectory=$HOME/pathfinder/py
                    ExecStart=/bin/bash -c \"source $HOME/pathfinder/py/.venv/bin/activate && /usr/local/bin/pathfinder --http-rpc=\"0.0.0.0:9545\" --ethereum.url $ALCHEMY\"
                    Restart=on-failure
                    LimitNOFILE=65535
                [Install]
                    WantedBy=multi-user.target" > $HOME/starknetd.service
                    mv $HOME/starknetd.service /etc/systemd/system/


            sudo systemctl restart systemd-journald
            sudo systemctl daemon-reload
            sudo systemctl enable starknetd
            sudo systemctl restart starknetd


            
        
        break
        ;;
    
    esac

done
done
