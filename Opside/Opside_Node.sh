###################################### INSTALL ######################################

# update && upgrade
sudo apt update && sudo apt upgrade -y

# install node
wget -c https://pre-alpha-download.opside.network/testnet-auto-install-v2.tar.gz
tar -C ./ -xzf testnet-auto-install-v2.tar.gz
chmod +x -R ./testnet-auto-install-v2
cd ./testnet-auto-install-v2

# install validator
./install-ubuntu-en-1.0.sh



###################################### LOGS ######################################

# Логи клиента
opside-chain/show-geth-log.sh

# Логи консенсуса
opside-chain/show-beaconChain-log.sh

# Логи валидатора
opside-chain/show-validator-log.sh



Restore_Deposit_Data(){
	./opside-chain/tools/deposit --language 3 existing-mnemonic --mnemonic_language 4 --num_validators 1 --chain testnet --eth1_withdrawal_address $withdrawal --keystore_password $password
}
