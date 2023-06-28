menu(){
    cd $HOME
    ./Opside_Node.sh
}

#echo "To Call Main Menu - Enter 'menu'"

# update && upgrade
sudo apt update && sudo apt upgrade -y

echo "================================="
PS3="Choose Option:"
echo "================================="
options=("Install" "Check Logs")
echo "================================="
select opt in "${options[@]}"
do
    case $opt in

        ###################################### INSTALL ######################################

        "Install")
            # download software, extract files and change directory
            if ! [ -d /root/./testnet-auto-install-v2 ]; then

                wget -c https://pre-alpha-download.opside.network/testnet-auto-install-v2.tar.gz
                tar -C ./ -xzf testnet-auto-install-v2.tar.gz
                chmod +x -R ./testnet-auto-install-v2
                cd ./testnet-auto-install-v2

                # Get_Key_Parameters
                read -p "The 20-byte (Eth1) execution address that will be used in withdrawal: " withdrawal
                read -p "Create a password that secures your validator keystore(s)(The password length should be at least 8): " password
                echo "export WITHDRAWAL=\""$withdrawal"\"" > ./opside-chain/config/values.env
                echo "export PASSWORD=\""$password"\"" >> ./opside-chain/config/values.env

                # Deposit Data (Wallet)
                PS3="Generate New Wallet Or Restore Existing?"
                options=("Generate New" "Restore")
                select opt in "${options[@]}"
                do
                    case $opt in
                        
                        "Generate New")
                            ./opside-chain/tools/deposit --language 3 new-mnemonic \
                            --mnemonic_language 4 \
                            --num_validators 1 \
                            --chain testnet \
                            --eth1_withdrawal_address $withdrawal \
                            --keystore_password $password

                        break
                        ;;

                        "Restore")
                            ./opside-chain/tools/deposit --language 3 existing-mnemonic --mnemonic_language 4 --num_validators 1 --chain testnet --eth1_withdrawal_address $withdrawal --keystore_password $password
                        break
                        ;;

                    esac

                done

                
                # Init_Jwt_Key
                echo -n 0x$(openssl rand -hex 32 | tr -d "\n") > ./opside-chain/geth/config/jwtsecret
	            cp ./opside-chain/geth/config/jwtsecret ./opside-chain/prysm/beaconChain/config/jwtsecret

                # Start_Geth
                cp ./opside-chain/config/values.env ./opside-chain/geth
	            ./opside-chain/start-geth.sh

                # Start_BeaconChain
                cp ./opside-chain/config/values.env ./opside-chain/prysm/beaconChain
	            ./opside-chain/start-beaconChain.sh
                
                # Start_Validator
                mkdir -p ./opside-chain/prysm/validator/config/wallet/
                cp ./opside-chain/config/values.env ./opside-chain/prysm/validator/
                cp -r ./validator_keys/keystore-* ./opside-chain/prysm/validator/config/wallet/
                ./opside-chain/start-validator.sh


            else
                echo "Your Node Already Installed"
            fi
        break
        ;;

        
        ###################################### LOGS ######################################

        "Check Logs")
            options=("Client Logs" "Consensys Logs" "Validator Logs")
            select opt in "${options[@]}"
            do    
                case $opt in

                    "Client Logs")
                        $HOME/testnet-auto-install-v2/opside-chain/show-geth-log.sh
                    break
                    ;;

                    "Consensys Logs")
                        $HOME/testnet-auto-install-v2/opside-chain/show-beaconChain-log.sh
                    break
                    ;;

                    "Validator Logs")
                        $HOME/testnet-auto-install-v2/opside-chain/show-validator-log.sh
                    break
                    ;;

                esac

            done
        break
        ;;



    esac
done
