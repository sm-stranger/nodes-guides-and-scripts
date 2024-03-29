#!/bin/bash

while true
do

    PS3="Choose option and press Enter: "
    options=("Install" "Delete" "Update" "Check Logs")
    select opt in "${options[@]}"
    do
        case $opt in
        
            ######################################## Install ########################################
            
            "Install")
                
                # update && upgrade
                sudo apt update && sudo apt upgrade -y

                # install dependencies
                sudo apt update && sudo apt install software-properties-common -y
                sudo add-apt-repository ppa:deadsnakes/ppa -y
                sudo apt update && sudo apt install curl git tmux python3.10 python3.10-venv python3.10-dev python3-pip build-essential libgmp-dev pkg-config libssl-dev mc -y
                
                # install Rust
                sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
                source $HOME/.cargo/env
                rustup update stable --force


                # install Python
                cd $HOME
                rm -rf pathfinder
                git clone https://github.com/eqlabs/pathfinder.git
                cd pathfinder
                git fetch
                git checkout v0.10.0
                cd $HOME/pathfinder/py
                python3.10 -m venv .venv
                source .venv/bin/activate
                PIP_REQUIRE_VIRTUALENV=true pip install --upgrade pip
                PIP_REQUIRE_VIRTUALENV=true pip install -e .[dev]
                pytest
                cd $HOME/pathfinder/
                cargo build --release --bin pathfinder
                cd

                source $HOME/.bashrc
                mv ~/pathfinder/target/release/pathfinder /usr/local/bin/


                read -p "Enter Your Alchemy HTTP : " ALCHEMY
                echo 'export ALCHEMY='${ALCHEMY} >> $HOME/.bashrc
                source $HOME/.bashrc

                echo "[Unit]
                Description=StarkNet
                After=network.target

                [Service]
                User=$USER
                Type=simple
                ExecStart=/usr/local/bin/pathfinder --http-rpc=\"0.0.0.0:9545\" --ethereum.url \"$ALCHEMY\"
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


            
            ######################################## Delete ########################################

            "Delete")
            
            systemctl stop starknetd
            systemctl disable starknetd
            rm -rf ~/pathfinder/
            rm -rf /etc/systemd/system/starknetd.service
            rm -rf /usr/local/bin/pathfinder
            
            break
            ;;


            
            ######################################## Update ########################################
            
            "Update")

                #sudo apt update && sudo apt-get install software-properties-common -y
                #sudo add-apt-repository ppa:deadsnakes/ppa -y
                #sudo apt update && sudo apt install curl git tmux python3.10 python3.10-venv python3.10-dev build-essential libgmp-dev pkg-config libssl-dev -y
                sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
                source $HOME/.cargo/env
                rustup update stable --force
                
                cd ~/pathfinder
                git pull
                git fetch --all
                git checkout v0.10.0
                source $HOME/.cargo/env
                cargo build --release --bin pathfinder
                mv ~/pathfinder/target/release/pathfinder /usr/local/bin/
                
                echo "[Unit]
                Description=StarkNet
                After=network.target

                [Service]
                User=$USER
                Type=simple
                ExecStart=/usr/local/bin/pathfinder --http-rpc=\"0.0.0.0:9545\" --ethereum.url \"$ALCHEMY\"
                Restart=on-failure
                LimitNOFILE=65535

                [Install]
                WantedBy=multi-user.target" > $HOME/starknetd.service
                sudo mv $HOME/starknetd.service /etc/systemd/system/
                
                systemctl daemon-reload
                systemctl restart starknetd

            break
            ;;



            ######################################## Check Logs ########################################

            "Check Logs")
                journalctl -u starknetd -f
            break
            ;;
            


            ######################################## Restart ########################################

            "Restart")
                systemctl restart starknetd
            break
            ;;

        
        esac

    done

done

