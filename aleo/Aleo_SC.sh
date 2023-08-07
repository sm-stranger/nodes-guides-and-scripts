#!/bin/bash

red='\033[91m'
green='\033[92m'
default='\033[39m'
dark_red='\033[31m'
orange='\033[93m'


dash="============================================================="

while true
do

    ####################################################### MAIN MENU #######################################################

    clear
    echo ""
    echo -e $default $dash $orange "ALEO SMART CONTRACT MANAGEMENT" $default $dash
    echo ""

    PS3="Choose option and press Enter: "
    options=(
        "Install Software"
        "Data Management"
        "Projects Management"
        "Deploy"
        "Execute"
        "Scan"
        )
        
    select opt in "${options[@]}"
    do
        case $opt in

            ######################################## Install Software ########################################
            "Install Software")

                clear

                echo ""
                echo -e $default $dash $orange "INSTALL SOFTWARE" $default $dash
                echo ""

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


            break
            ;;



            ################################################# Data Management #################################################
            "Data Management")
                
                echo ""
                    
                    while true
                    do
                        
                        clear

                        if ! [ -f /root/Aleo_SC/.data ]
                        then
                            mkdir $HOME/Aleo_SC && cd Aleo_SC
                            echo "PK=None" >> .data && \
                            echo "VK=None" >> .data && \
                            echo "ADDRESS=None" >> .data && \
                            echo "FAUCET_TXID=None" >> .data
                        fi

                        echo ""
                        echo -e $default $dash $orange "KEYS MANAGEMENT" $default $dash
                        echo ""
                        echo ""
                        
                        source $HOME/Aleo_SC/.data

                        echo -e $green "Private Key " $default $PK
                        echo -e $green "View Key    " $default $VK
                        echo -e $green "Address     " $default $ADDRESS
                        echo -e $green "Faucet TXID " $default $TXID

                        echo ""
                        
                        PS3="Choose option and press Enter: "
                        options=(
                            "Edit Private Key"
                            "Edit View Key"
                            "Edit Address"
                            "Edit Faucet TXID"
                            "Main Menu"
                            )
                        select opt in "${options[@]}"
                        do
                            case $opt in
                                
                                "Edit Private Key")

                                    read -p "Enter Your Private Key: " NEW_PK
                                    sed -i '/^PK/s/'$PK'/'$NEW_PK'/g' $HOME/Aleo_SC/.data
                                
                                break
                                ;;

                                
                                "Edit View Key")

                                    read -p "Enter Your View Key: " NEW_VK
                                    sed -i '/^VK/s/'$VK'/'$NEW_VK'/g' $HOME/Aleo_SC/.data

                                break
                                ;;


                                "Edit Address")

                                    read -p "Enter Your Address: " NEW_ADDRESS
                                    sed -i '/^ADDRESS/s/'$ADDRESS'/'$NEW_ADDRESS'/g' $HOME/Aleo_SC/.data

                                break
                                ;;


                                "Edit Faucet TXID")

                                    read -p "Enter Your Faucet Hash From SMS Link: " NEW_FAUCET_TXID
                                    sed -i '/^FAUCET_TXID/s/'$FAUCET_TXID'/'$NEW_FAUCET_TXID'/g' $HOME/Aleo_SC/.data

                                break
                                ;;


                                "Main Menu")
                                    cd
                                    ./Aleo_SC.sh

                                break
                                ;;

                            esac
                        done
                    done
                
            break
            ;;



            ######################################## Projects Management ########################################
            "Projects Management")
                while true
                do

                    clear

                    echo ""
                    echo -e $default $dash $orange "PROJECTS MANAGEMENT" $default $dash
                    echo ""
                    echo ""

                    source $HOME/Aleo_SC/.data

                    if [ -z "$NAME" ]; then NAME="None"; fi

                    echo -e "*****************************" $green "Projects List" $default "*****************************"
                    echo ""

                    cd $HOME/leo_deploy
                    dir_list=$(ls -t)
                    #len=${#dir_list[*]}
                    for dir in $dir_list; do echo $dir ;done
                    echo ""

                    PS3="Choose option and press Enter: "
                    options=(
                        "Create New Project"
                        #"Choose Project"
                        "Main Menu"
                    )
                    select opt in "${options[@]}"
                    do
                        case $opt in

                            "Create New Project")

                                # contract name
                                read -p "  Enter Your Contract Name: " NAME

                                mkdir $HOME/leo_deploy
                                cd $HOME/leo_deploy
                                leo new $NAME

                            break
                            ;;

                            "Main Menu")
                                cd
                                ./Aleo_SC.sh
                            break
                            ;;

                        esac
                    done    

                    source $HOME/Aleo_SC/.data
                    source $HOME/.cargo/env

                    # Make Directory Leo Deploy And Create New Project
                    if ! [ -d /root/leo_deploy ]; then
                        mkdir $HOME/leo_deploy
                    fi
                    
                done

            break
            ;;

            

            #################################### Deploy ####################################
            "Deploy")

                while true
                do
                    clear

                    echo ""
                    echo -e $default $dash $orange "DEPLOY" $default $dash
                    echo ""
                    echo ""

                    QUOTE_LINK="https://vm.aleo.org/api/testnet3/transaction/"$TXID

                    source $HOME/Aleo_SC/.data
                    echo -e $green "Private Key    " $default$PK 
                    echo -e $green "Project Name   " $default$NAME
                    echo -e $green "Link           " $default$QUOTE_LINK
                    echo -e $green "Record         " $default$RECORD


                    echo ""
                    PS3="Choose option and press Enter: "
                    options=( "Get Record" "Make Deploy" "Main Menu" )
                    select opt in "${options[@]}"
                    do
                        case $opt in

                            "Get Record")
                                CIPHERTEXT=$(curl -s "$QUOTE_LINK" | jq -r '.execution.transitions[0].outputs[0].value')
                                RECORD=$(snarkos developer decrypt --ciphertext $CIPHERTEXT --view-key $VK)
                            
                            break
                            ;;

                            "Make Deploy")

                                source $HOME/Aleo_SC/.data

                                snarkos developer deploy "$NAME.aleo" \
                                --private-key "$PK" \
                                --query "https://vm.aleo.org/api" \
                                --path "$HOME/leo_deploy/$NAME/build/" \
                                --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
                                --fee 4000000 \
                                --record "$RECORD"

                                sleep 10

                            break
                            ;;

                            "Main Menu")
                                cd
                                ./Aleo_SC.sh
                                
                            break
                            ;;
                        
                        esac
                    done
                done


                
                #read -p "Enter Deployment TX Hash: " DH
                #QUOTE_LINK="https://vm.aleo.org/api/testnet3/transaction/"$DH
                #echo 'export QUOTE_LINK='$QUOTE_LINK >> $HOME/.bash_profile
                #source $HOME/.bash_profile


            break    
            ;;


            
            #################################### Execute ####################################
            "Execute")

                clear

                echo ""
                echo -e $default $dash $dark_red "EXECUTE" $default $dash
                echo ""
                echo ""


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

            break    
            ;;


            #################################### Scan ####################################
            "Scan")

                source $HOME/Aleo_SC/.data
                snarkos developer scan \
                    -v $VK \
                    --start 147989 \
                    --end 283246 \
                    --endpoint "https://vm.aleo.org/api"
            break
            ;;


        esac
    done
done

