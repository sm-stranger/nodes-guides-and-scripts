### В этом руководстве мы рассмотрим установку ноду Source в mainnet. 

<br>

#### Если у вас уже есть установленная нода Source - нужно удалить ее. Для этого выполним

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

#### Загружаем генезис-файл
```
curl -s  https://raw.githubusercontent.com/Source-Protocol-Cosmos/mainnet/master/source-1/genesis.json > ~/.source/config/genesis.json
```

#### Сверяем контрольную сумму. Должно получиться ba2261082818227073bd8b49717a9781bf5c440c8e34e21ec72fb15806f047cc
```
sha256sum ~/.source/config/genesis.json
# ba2261082818227073bd8b49717a9781bf5c440c8e34e21ec72fb15806f047cc
```

#### Устанавливаем минимальную цену газа, сиды, пиры и фильтры пиров
```
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.25usource\"/;" ~/.source/config/app.toml && \
external_address=$(wget -qO- eth0.me) &&  \
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.source/config/config.toml && \
peers="96d63849a529a15f037a28c276ea6e3ac2449695@34.222.1.252:26656,0107ac60e43f3b3d395fea706cb54877a3241d21@35.87.85.162:26656" && \
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.source/config/config.toml && \
seeds="" && \
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.source/config/config.toml && \
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.source/config/config.toml && \
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.source/config/config.toml
```


#### Загружаем  addrbook
```
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Projects/Source/addrbook.json"
```

#### Создаем сервис
```
echo "Description=Source daemon
After=network-online.target

[Service]
User=${USER}
ExecStart=${HOME}/${USER}/go/bin/sourced start --home $HOME/${USER}/.source
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/sourced.service
```

#### Синхронизация состояния цепочки
```
SNAP_RPC=https://source.rpc.m.stavr.tech:443
peers="3c729ffe80393abd430a7c723fab2e8aa60ffa46@source.peers.stavr.tech:20056"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.source/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 100)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.source/config/config.toml
sourced tendermint unsafe-reset-all
systemctl restart sourced && journalctl -u sourced -f -o cat
```

#### Снэпшот (размер: ~200мб). Обновляется каждые 5 часов
```
cd $HOME
apt install lz4
sudo systemctl stop sourced
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" ~/.source/config/config.toml
cp $HOME/.source/data/priv_validator_state.json $HOME/.source/priv_validator_state.json.backup
rm -rf $HOME/.source/data
curl -o - -L https://source-m.snapshot.stavr.tech/source/source-snap.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.source --strip-components 2
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Projects/Source/addrbook.json"
mv $HOME/.source/priv_validator_state.json.backup $HOME/.source/data/priv_validator_state.json
sudo systemctl restart sourced && journalctl -u sourced -f -o cat
```

#### Включаем и запускаем сервис
```
sudo systemctl daemon-reload &&
sudo systemctl enable sourced &&
sudo systemctl restart sourced && sudo journalctl -u sourced -f -o cat
```

#### После того как нода набрала нужную высоту - переходим к следующему шагу - создание валидатора

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

#### Проверка статуса
```
sourced status
```

#### Проверка логов
```
journalctl -u sourced -f
```
