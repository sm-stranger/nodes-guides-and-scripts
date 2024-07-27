#### Первым делом копируем папку keys с флэшки на сервер ( файл rrr.txt копировать не надо )

<br>

#### Далее устанавливаем мину скриптом
```
wget -O mina_install.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/mina/mina_install.sh && chmod +x mina_install.sh && ./mina_install.sh

```

#### Проверяем статус
```
sudo docker exec -it mina mina client status
```
