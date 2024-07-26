#!/bin/bash

red='\033[91m'
green='\033[92m'
default='\033[39m'
dark_red='\033[31m'
orange='\033[93m'

dash="============================================================="


###################################### Prepare ######################################

# update && upgrade
sudo apt update && sudo apt upgrade && sudo apt install mc -y

# install Docker
sudo apt install docker.io curl -y && sudo systemctl start docker && sudo systemctl enable docker

while true do


   ####################################################### MAIN MENU #######################################################

    #clear
    echo ""
    echo -e $default $dash $orange "MINA NODE MANAGEMENT" $default $dash
    echo ""

    PS3="Choose option and press Enter: "
    options=(
        "Install"
        "Run"
        "Check Status"
        "Import Account"
        "Unlock Account"
        "Send Payment"
        )
        
   select opt in "${options[@]}"
   do
      case $opt in


         ######################################## Install ########################################
         "Install")

            if ! [ -d /root/.mina-config ]; then

               # install Mina
               sudo rm /etc/apt/sources.list.d/mina*.list
               sudo echo "deb [trusted=yes] http://packages.o1test.net $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/mina.list
               sudo apt update
               sudo apt install -y curl unzip mina-mainnet=3.0.0-93e0279

               if [ -d /keys ]
                  # set permission
                  chmod 700 $HOME/keys && chmod 600 $HOME/keys/my-wallet

                  # export keys
                  echo 'export KEYPATH=$HOME/keys/my-wallet' >> $HOME/.bashrc
                  echo 'export MINA_PUBLIC_KEY=$(cat $HOME/keys/my-wallet.pub)' >> $HOME/.bashrc
                  source ~/.bashrc
               fi

               # open ports 8302 and 8303
               sudo iptables -A INPUT -p tcp --dport 8302:8303 -j ACCEPT

            fi

         break
         ;;

         
         
         ######################################## Run ########################################
         "Run")

            sudo docker run --name mina -d \
            --restart always \
            -p 8302:8302 \
            -p 127.0.0.1:3085:3085 \
            -v $(pwd)/keys:/root/keys:ro \
            -v $(pwd)/.mina-config:/root/.mina-config \
            minaprotocol/mina-daemon:3.0.0-93e0279-focal-mainnet daemon \
            --peer-list-url https://storage.googleapis.com/mina-seed-lists/mainnet_seeds.txt \
            --snark-worker-fee 0.025 \
            --run-snark-worker $MINA_PUBLIC_KEY \
            --insecure-rest-server \
            --file-log-level Debug \
            -log-level Info

         break
         ;;


         ######################################## Check Status ########################################
         "Check Status")

            sudo docker exec -it mina mina client status

         break
         ;;


         ######################################## Import Account ########################################
         "Import Account")
            mina accounts import -privkey-path $KEYPATH
         break
         ;;


         ######################################## Unlock Account ########################################
         "Unlock Account")
            mina accounts unlock -public-key $MINA_PUBLIC_KEY
         break
         ;;


         ######################################## Send Payment ########################################
         "Send Payment")
            
            read -p "Enter Receiver Of Payment: " receiver
            read -p "Enter Amount To Send: " amount

            mina client send-payment \
            -sender B62qjU8FUq5CmJ6MWFFEM1KGVb9DfZSvSmDCD1U5vgxrpDxAV3JZDrj \
            -receiver $receiver \
            -fee 0.01 \
            -amount $amount

         break
         ;;


      esac
   done

done





######################## Просмотр логов ########################

# Посмотреть запущенные контейнеры:
#sudo docker ps -a

# Логи контейнера с нодой:
#sudo docker logs --follow mina -f --tail 1000

# Статус ноды:
#sudo docker exec -it mina mina client status



######################## Команды Докера ########################

# Остановка контейнера:
#sudo docker stop mina

# Рестарт контейнера
sudo docker restart mina

# Удаление контейнера:
#sudo docker rm mina

# Удаление запущенного контейнера:
#sudo docker rm -f mina
