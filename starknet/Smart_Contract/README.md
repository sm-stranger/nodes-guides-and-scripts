В этом гайде мы рассмотрим деплой смарт контракта Starknet с помощью Protostar, набора инструментов для разработки смарт контарктов Starknet на языке Cairo. Предполагается что у вас уже есть сервер и вы подключились к нему с помощью какого-либо SSH-клиента.

<br>

#### Обновляем систему
```
sudo apt update && sudo apt upgrade -y
```
<img width="600px" height="300px" src="img/img-1.png">
<br>

#### Устанавливаем Protostar, набор инструментов для разработки смарт-контарктов для Starknet на языке Cairo
```
curl -L https://raw.githubusercontent.com/software-mansion/protostar/master/install.sh | bash && source $HOME/.bashrc
```
<img width="600px" height="300px" src="img/img-2.png">

<br>

#### Устанавливаем Scarb, менеджер пакетов Cairo
```
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh && source $HOME/.bashrc && scarb --version
```
<img width="600px" height="300px" src="img/img-3.png">

<br>

#### Далее устанавливаем переменные PK (Private Key).
```
PK="Your_Private_Key"
```
<img width="600px" height="300px" src="img/img-4.png">

<br>

#### Записываем ее в .bashrc
```
echo 'export PK='$PK >> $HOME/.bashrc && source $HOME/.bashrc
```
<img width="600px" height="300px" src="img/img-5.png">

<br>

#### По такому же принципу записываем адрес кошелька и имя контракта в переменные ADDRESS и NAME
```
ADDRESS="Your_Address"
```
<img width="600px" height="300px" src="img/img-6.png">

```
NAME="contract_name"
```
<img width="600px" height="300px" src="img/img-7.png">

<br>

#### Также записываем эти переменные в файл профиля .bashrc
```
echo 'export ADDRESS='$ADDRESS >> $HOME/.bashrc && echo 'export NAME='$NAME >> $HOME/.bashrc source $HOME/.bashrc
```
<img width="600px" height="300px" src="img/img-8.png">

<br>

#### Инициализируем контракт
```
protostar init $NAME
```
<img width="600px" height="300px" src="img/img-9.png">

#### Переходим в директорию созданного проекта
```
cd $NAME
```

<br>

#### Записываем свое имя смарт контракта
```
sed -i 's/hello_starknet/'$NAME'/' Scarb.toml && \
sed -i 's/hello_starknet/'$NAME'/' protostar.toml && \
sed -i 's/hello_starknet/'$NAME'/' src/contract.cairo && \
sudo cat 'src/contract/hello_starknet.cairo' >> src/contract/$NAME.cairo && \
sudo rm -rf src/contract/hello_starknet.cairo && \
sed -i 's/hello_starknet/'$NAME'/' src/contract/$NAME.cairo && \
sed -i 's/Hello_Starknet/'$NAME'/' src/contract/$NAME.cairo
```
<img width="600px" height="300px" src="img/img-10.png">

<br>

#### Билдим проект
```
protostar build --contract-name $NAME
```
<img width="600px" height="300px" src="img/img-11.png">


#### Записываем полученный хэш
```
HASH="0x......"
```
<img width="900px" height="300px" src="img/img-12.png">


#### Записываем переменную $PK в файл .env
```
echo $PK > .env
```

#### Объявляем контракт
```
protostar declare $NAME \
    --account-address $ADDRESS \
    --max-fee auto \
    --private-key-path ./.env \
    --network mainnet
```

#### Деплой
```
protostar deploy $HASH \
    --account-address $ADDRESS \
    --max-fee auto \
    --private-key-path ./.env \
    --network mainnet
```

<img width="900px" height="600px" src="img/img-13.png">
