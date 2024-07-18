### Обновление и установка доп. пакетов
```
sudo apt update && sudo apt upgrade && sudo apt install mc -y
```

# установка Mina
sudo echo "deb [trusted=yes] http://packages.o1test.net $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/mina.list
sudo apt-get update
sudo apt-get install --allow-downgrades -y mina-mainnet=3.0.0-93e0279


Втыкаем флешку. Запускаем файлзилу. 

# копирование ключей
# установка прав
chmod 700 $HOME/keys
chmod 600 $HOME/keys/my-wallet

# экспорт ключей
echo 'export KEYPATH=$HOME/keys/my-wallet' >> $HOME/.bashrc
echo 'export MINA_PUBLIC_KEY=$(cat $HOME/keys/my-wallet.pub)' >> $HOME/.bashrc
echo 'export MINA_PASS=$(cat $HOME/rrr.txt)' >>$HOME/.bashrc
source ~/.bashrc


# установка Docker (одна команда. Все строки)
sudo apt install docker.io curl -y \
&& sudo systemctl start docker \
&& sudo systemctl enable docker

# открыть порты 8302 и 8303
sudo iptables -A INPUT -p tcp --dport 8302:8303 -j ACCEPT


# 2.1 Запуск только Производителя блоков (Block Producer):(одна команда. Все строки)



################

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


# импорт аккаунта(пароли с флеши)
mina accounts import -privkey-path $KEYPATH


# разблокировка аккаунта (пароли с флеши)
mina accounts unlock -public-key $MINA_PUBLIC_KEY


# отправить платеж (одна команда. Все строки)
mina client send-payment \
-sender B62qjU8FUq5CmJ6MWFFEM1KGVb9DfZSvSmDCD1U5vgxrpDxAV3JZDrj \
-receiver B62qp75GRmMaN1B6MkuDPZiJEvDr1vmTyswwyzyom2c2rZp5f73BDmG \
-fee 0.01 \
-amount 1931



######################## Просмотр логов ########################

# Посмотреть запущенные контейнеры:
sudo docker ps -a

# Логи контейнера с нодой:
sudo docker logs --follow mina -f --tail 1000

# Статус ноды:
sudo docker exec -it mina mina client status



######################## Команды Докера ########################

# Остановка контейнера:
sudo docker stop mina

# Рестарт контейнера
sudo docker restart mina

# Удаление контейнера:
sudo docker rm mina

# Удаление запущенного контейнера:
sudo docker rm -f mina
