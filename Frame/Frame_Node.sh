#!/bin/bash

function colors {
  GREEN="\e[32m"
  YELLOW="\e[33m"
  RED="\e[39m"
  NORMAL="\e[0m"
}


function line {
  echo -e "${GREEN}-----------------------------------------------------------------------------${NORMAL}"
}

 function install_docker {
    if ! type "docker" > /dev/null; then
        echo -e "${YELLOW}Install Docker${NORMAL}"
        bash <(curl -s https://raw.githubusercontent.com/F1rstCap1tal/doker/main/doker.sh)
    fi
}

 function prepare_files {
    echo -e "${YELLOW}Prepare Config Files${NORMAL}"
    if [ ! -d "$HOME/frame-validator" ]; then
        mkdir -p $HOME/frame-validator/node-data
        cd $HOME/frame-validator
        if [ ! -d "$HOME/frame-validator/node-config" ]; then
            git clone https://github.com/frame-network/node-config.git
            sed -i 's|"url":.*|"url": "https://ethereum-sepolia.publicnode.com"|' node-config/testnet.json
        fi
    else
        echo -e "${YELLOW}Node Already Installed${NORMAL}"
        cd $HOME/frame-validator
        docker rm -f frame
        rm -rf $HOME/frame-validator/node-config
        git clone https://github.com/frame-network/node-config.git
        sed -i 's|"url":.*|"url": "https://ethereum-sepolia.publicnode.com"|' node-config/testnet.json
    fi

}

function run_docker {
    echo -e "${YELLOW}Запускаем докер контейнер для валидатора${NORMAL}"
    if [ ! "$(docker ps -q -f name=^frame$)" ]; then
        if [ "$(docker ps -aq -f status=exited -f name=^frame$)" ]; then
            echo -e "${YELLOW}Докер контейнер уже существует в статусе exited. Удаляем его и запускаем заново${NORMAL}"
            docker rm -f frame
        fi
        docker run -d --name frame --restart always -it -v $(pwd)/node-data:/home/user/.frame -v $(pwd)/node-config/testnet.json:/home/user/testnet.json public.ecr.aws/o8e2k8j7/nitro-node:frame --conf.file testnet.json
    fi

}


 function output {
    echo -e "${YELLOW}Для проверки логов выполняем команду:${NORMAL}"
    echo -e "docker logs -f frame --tail=100"
    echo -e "${YELLOW}Для перезапуска выполняем команду:${NORMAL}"
    echo -e "docker restart frame"
}

 function main {
    colors
    line
    prepare_files
    line
    install_docker
    line
    run_docker
    line
    output
    line
}

#main

line
PS3="Choose Option And Press Enter: "
options=(
    "Install"
    "Commands"
)
select opt in "${options[@]}"
do
    case $opt in

        "Install")
            main
        ;;

        "Commands")
            PS3="Choose Command And Press Enter: "
            options=(
                "Logs"
                "Restart"
            )
            select opt in "${options[@]}"
            do
                case $opt in

                    "Logs")
                        docker logs -f frame --tail=100
                    ;;

                    "Restart")
                        docker restart frame
                    ;;

                esac
            done
        ;;

    esac
done
