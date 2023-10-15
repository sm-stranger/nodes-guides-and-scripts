### В этом руководстве мы рассмотрим установку ноду Surce в mainnet. 

<p>Если у вас уже есть установленная нода Source - нужно удалить ее. Для этого выполним</p>

```
sudo systemctl stop sourced && \
cd $HOME && \
rm -rf .source && \
rm -rf source && \
rm -rf $(which sourced)
```

#### Подготовка сервера
```
sudo apt update && sudo apt upgrade -y && \
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```

#### Установка GO
```
ver="1.19" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```

#### Клонируем репозиторий Source
```
git clone https://github.com/Source-Protocol-Cosmos/source.git
```

#### Компилируем
```
cd ~/source && \
git fetch && \
git checkout v3.0.0 && \
make build && make install
```

#### Инициалируем Source и создаем генезис файл. <moniker-name> заменить свое имя валидатора.
```
MONIKER=<moniker-name>
sourced init $MONIKER --chain-id=source-1
```

#### Если у вас уже есть установленная нода то нужно восстановить существующие ключи. <walletname> также заменить на свое имя кошелька
```
WALLET=<walletName>
sourced keys add $WALLET --recover
```

#### Или создать новые
```
WALLET=<walletName>
sourced keys add $WALLET
```

#### Загружаем генезис-фвйл
```
curl -s  https://raw.githubusercontent.com/Source-Protocol-Cosmos/mainnet/master/source-1/genesis.json > ~/.source/config/genesis.json
```

#### Сверяем контрольную сумму. Должно получиться ba2261082818227073bd8b49717a9781bf5c440c8e34e21ec72fb15806f047cc
```
sha256sum ~/.source/config/genesis.json
# ba2261082818227073bd8b49717a9781bf5c440c8e34e21ec72fb15806f047cc
```

#### Скачиваем файлы config.toml и app.toml
```
wget -O $HOME/.source/config/config.toml https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/Source/.source/config/config.toml && \
wget -O $HOME/.source/config/app.toml https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/Source/.source/config/app.toml
```


#### Запускаем ноду
```
sourced start
```

#### Создаем валидатора.
```
sourced tx staking create-validator \
--amount 1000000000usource \
--commission-max-change-rate "0.1" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "validators write bios too" \
--pubkey=$(sourced tendermint show-validator) \
--moniker $MONIKER \
--chain-id source-1 \
--fees=50000usource \
--from $MONIKER
```

### Запуск производителя блоков

#### Создаем сервис
```
echo "Description=Source daemon
After=network-online.target

[Service]
User=<YOUR_USERNAME>
ExecStart=${HOME}/${USER}/go/bin/sourced start --home $HOME/${USER}/.source
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/sourced.service
```

#### Включаем и запускаем сервис
```
sudo systemctl enable sourced
```
```
sudo systemctl start sourced
```

#### Проверка статуса
```
sourced status
```

#### Проверка логов
```
journalctl -u sourced -f
```
