PS3="Choose option and press Enter: "
options=("Install Muon" "Create Backup" "Check Node Status" "Show Logs")
select opt in "${options[@]}"
do
    case $opt in

        ######################## Install Muon ########################
        "Install Muon")
            echo -e '\n\e[42mInstalling Muon...\e[0m\n' && sleep 1

            # update && upgrade system
            sudo apt update && sudo apt upgrade -y

            # install dependencies
            sudo apt install ca-certificates curl gnupg lsb-release -y

            # install Docker
            sudo apt update
            sudo mkdir -m 0755 -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
            $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt update
            sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

            # download Muon docker-compose.yml
            curl -o docker-compose.yml https://raw.githubusercontent.com/muon-protocol/muon-node-js/testnet/docker-compose-pull.yml

            # run container
            docker compose up -d

            break

        ;;


        ######################## Create Backup ########################
        "Create Backup")
            echo -e '\n\e[42mCreating a backup...\e[0m\n' && sleep 1

            docker exec -it muon-node ./node_modules/.bin/ts-node ./src/cmd keys backup > backup.json

            break

        ;;


        ######################## Check Node Status ########################
        "Check Node Status")
            echo -e '\n\e[42mChecking node status...\e[0m\n' && sleep 1

            curl http://localhost:8000/status | jq

            # ip=$(curl ifconfig.me)
            # echo "To Check Node Status - Copy And Paste This link In Your Browser:"
            # echo "http://"$ip":8000/status"
        
            break

        ;;


        ######################## Show Logs ########################
        "Show Logs")
            echo -e '\n\e[42mChecking node status...\e[0m\n' && sleep 1

            docker exec -it muon-node pm2 logs

            break

        ;;

      esac  

done

# logs
# docker logs -f --tail 50 muon-node

