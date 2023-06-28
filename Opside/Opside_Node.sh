

# update && upgrade
sudo apt update && sudo apt upgrade -y

# download software, extract files and change directory
wget -c https://pre-alpha-download.opside.network/testnet-auto-install-v2.tar.gz
tar -C ./ -xzf testnet-auto-install-v2.tar.gz
chmod +x -R ./testnet-auto-install-v2
cd ./testnet-auto-install-v2


Get_Key_Parameters


###################################### WALLET ######################################

PS3="Generate New Wallet Or Restore Existing?"
options=("Generate New" "Restore")
select opt in "${options[@]}"
do
	case $opt in
		
		"Generate New")
			./opside-chain/tools/deposit --language 3 new-mnemonic --mnemonic_language 4 --num_validators 1 --chain testnet --eth1_withdrawal_address $withdrawal --keystore_password $password

		break
		;;

		"Restore")
			./opside-chain/tools/deposit --language 3 existing-mnemonic --mnemonic_language 4 --num_validators 1 --chain testnet --eth1_withdrawal_address $withdrawal --keystore_password $password			
		break
		;;

	esac

done


Init_Jwt_Key
Start_Geth
Start_BeaconChain
Start_Validator






###################################### LOGS ######################################

# Логи клиента
opside-chain/show-geth-log.sh

# Логи консенсуса
opside-chain/show-beaconChain-log.sh

# Логи валидатора
opside-chain/show-validator-log.sh


