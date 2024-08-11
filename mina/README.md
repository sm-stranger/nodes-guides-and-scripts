#### Первым делом копируем папку keys с флэшки на сервер ( файл rrr.txt копировать не надо )

<br>

#### Далее устанавливаем мину скриптом
```
wget -O mina_install.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/mina/mina_install.sh && chmod +x mina_install.sh && ./mina_install.sh
```

#### Проверяем статус. Ждем когда появится synced
```
sudo docker exec -it mina mina client status
```

#### Импорт аккаунта
```
mina accounts import -privkey-path $KEYPATH
```

#### Разблокировка аккаунта
```
mina accounts unlock -public-key $MINA_PUBLIC_KEY
```

#### Далее указываем количество монет для вывода ( "amount" заменить на количество)
```
amount= <amount>
```

#### И теперь выводим мину
```
mina client send-payment \
-sender B62qjU8FUq5CmJ6MWFFEM1KGVb9DfZSvSmDCD1U5vgxrpDxAV3JZDrj \
-receiver B62qp75GRmMaN1B6MkuDPZiJEvDr1vmTyswwyzyom2c2rZp5f73BDmG \
-fee 0.01 \
-amount $amount
```
