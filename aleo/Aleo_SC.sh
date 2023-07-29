#!/bin/bash

red='\033[91m'
green='\033[92m'
default='\033[39m'
dark_red='\033[31m'

while true
do

    echo ""
    PS3="Choose option and press Enter: "
    echo ""
    options=(
        "Install Software" 
        "Data Management" 
        "Create Project" 
        "Deploy" 
        "Execute" 
        )
        
    select opt in "${options[@]}"
    do
        case $opt in

            ######################################## Install Software ########################################
            "Install Software")

                sudo apt update && sudo apt upgrade -y

                sudo apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw mc -y
                sudo curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
                source $HOME/.cargo/env

                # Install SnarkOS
                if ! [ -d /root/snarkOS ]; then
                    cd && git clone https://github.com/AleoHQ/snarkOS.git --depth 1 && cd $HOME/snarkOS
                    git pull
                    #bash ./build_ubuntu.sh
                    cargo install --path .
                    
                fi
                source $HOME/.bashrc
                source $HOME/.cargo/env

                # Install Leo
                if ! [ -d /root/leo ]; then
                    cd && git clone https://github.com/AleoHQ/leo.git
                fi
                cd $HOME/leo
                cargo install --path .

            ;;



            ################################################# Data Management #################################################
            "Data Management")

                clear

                echo ""
                echo -e $default "******************************************" $dark_red "Keys Management" $default "******************************************"
                echo ""


                if ! [ -f /root/Aleo_SC/.data ]
                then
                    mkdir $HOME/Aleo_SC && cd Aleo_SC
                    echo "PK=None" >> .data && \
                    echo "VK=None" >> .data && \
                    echo "ADDRESS=None" >> .data && \
                    echo "QUOTE_LINK=None" >> .data

                fi

                source $HOME/Aleo_SC/.data

                echo ""
                echo -e $green "Private Key:" $default $PK
                echo -e $green "   View Key:" $default $VK
                echo -e $green "    Address:" $default $ADDRESS
                echo -e $green "       Link:" $default $QUOTE_LINK
                                
                
                echo ""
                options=( "Edit Private Key" "Edit View Key" "Edit Address" "Edit Link" "Main Menu" )
                select opt in "${options[@]}"
                do
                    case $opt in
                        
                        "Edit Private Key")
                            read -p "Enter Your Private Key: " NEW_PK
                            sed -i '/^PK/s/'$PK'/'$NEW_PK'/g' $HOME/Aleo_SC/.data
                        ;;
                        
                        "Edit View Key")
                            read -p "Enter Your View Key: " NEW_VK
                            sed -i '/^VK/s/'$VK'/'$NEW_VK'/g' $HOME/Aleo_SC/.data
                        ;;

                        "Edit Address")
                            read -p "Enter Your Address: " NEW_ADDRESS
                            sed -i '/^ADDRESS/s/'$ADDRESS'/'$NEW_ADDRESS'/g' $HOME/Aleo_SC/.data
                        ;;

                        "Quit")
                            ./Aleo_SC.sh
                        ;;

                    esac
                done

                read -p "Enter Your Private Key: " "PK" && echo 'export PK='$PK >> $HOME/Aleo_SC/.data
                read -p "Enter Your View Key: " "VK" && echo 'export VK='$VK >> $HOME/Aleo_SC/.data
                read -p "Enter Your Address: " "Address" && echo 'export ADDRESS='$ADDRESS >> $HOME/Aleo_SC/.data

                    # Contract Name
                    read -p "Enter Your Contract Name: " NAME

                    # QUOTE_LINK
                    if [ -z "$QUOTE_LINK" ]; then read -p "Enter Your Hash: " QUOTE_LINK && echo 'export QUOTE_LINK='$QUOTE_LINK >> $HOME/.bashrc; fi


                echo ""


            ;;



            ######################################## Create Project ########################################
            "Create Project")
                # contract name
                read -p "Enter Your Contract Name: " NAME

                # Make Directory Leo Deploy And Create New Project
                if ! [ -d /root/leo_deploy ]; then
                    mkdir $HOME/leo_deploy
                fi
                cd $HOME/leo_deploy
                leo new $NAME
            ;;

            

            #################################### Deploy ####################################
            "Deploy")

                CIPHERTEXT=$(curl -s "$QUOTE_LINK" | jq -r '.execution.transitions[0].outputs[0].value')
                RECORD=$(snarkos developer decrypt --ciphertext $CIPHERTEXT --view-key $VK)

                snarkos developer deploy "$NAME.aleo" \
                --private-key "$PK" \
                --query "https://vm.aleo.org/api" \
                --path "$HOME/leo_deploy/$NAME/build/" \
                --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
                --fee 4000000 \
                --record "$RECORD"

                read -p "Enter Deployment TX Hash: " DH
                QUOTE_LINK="https://vm.aleo.org/api/testnet3/transaction/"$DH
                echo 'export QUOTE_LINK='$QUOTE_LINK >> $HOME/.bash_profile
                source $HOME/.bash_profile
            ;;


            
            #################################### Execute ####################################
            "Execute")
                CIPHERTEXT=$(curl -s $QUOTE_LINK | jq -r '.fee.transition.outputs[].value')
                RECORD=$(snarkos developer decrypt --ciphertext $CIPHERTEXT --view-key $VK)


                snarkos developer execute "$NAME.aleo" "hello" "1u32" "2u32" \
                --private-key "$PK" \
                --query "https://vm.aleo.org/api" \
                --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
                --fee 4000000 \
                --record "$RECORD"

                read -p "Enter Execution TX Hash Or Link: " EH
                QUOTE_LINK="https://vm.aleo.org/api/testnet3/transaction/"$EH
                echo 'export QUOTE_LINK='$QUOTE_LINK >> $HOME/.bash_profile
                source $HOME/.bash_profile
            ;;


        esac
    done
done


