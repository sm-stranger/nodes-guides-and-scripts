#!/bin/bash

while true
do

    PS3="Choose option and press Enter: "
    options=("Install Software" "Data Management" "Update" "Check Logs")
    select opt in "${options[@]}"
    do
        case $opt in

            ######################################## Install Software ########################################
            "Install Software")

                sudo apt update && sudo apt upgrade -y

                sudo apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw mc -y
                sudo curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh

                # install snarkOS
                if ! [ -d /root/snarkOS ]; then
                    cd && git clone https://github.com/AleoHQ/snarkOS.git --depth 1 && cd $HOME/snarkOS
                    git pull
                    #bash ./build_ubuntu.sh
                    cargo install --path .
                    
                fi
                source $HOME/.bashrc
                source $HOME/.cargo/env

                # install leo
                if ! [ -d /root/leo ]; then
                    cd && git clone https://github.com/AleoHQ/leo.git
                fi
                cd $HOME/leo
                cargo install --path .

            ;;


            ######################################## Data Management ########################################
            "Data Management")

                echo "You Don't Have Data. Create New?"
                echo -e '\033[92m'&&echo "Private Key:"

                # keys
                if [ -z "$PK" ]; then
                    read -p "Enter Your Private Key: " "PK"
                    echo 'export PK='$PK >> $HOME/.bashrc
                fi
                if [ -z "$VK" ]; then
                    read -p "Enter Your View Key: " VK
                    echo 'export VK='$VK >> $HOME/.bashrc
                fi
                if [ -z "$ADDRESS" ]; then
                    read -p "Enter Your Address: " ADDRESS
                    echo 'export ADDRESS='$ADDRESS >> $HOME/.bashrc
                fi
                source $HOME/.bashrc

                # contract name
                read -p "Enter Your Contract Name: " NAME

            ;;


        esac
    done
done
