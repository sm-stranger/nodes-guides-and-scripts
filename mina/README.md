# Mina. Установка и запуск

#### Первым делом вставляем флэшку и копируем папку keys

#### Далее обновляем систему
```
sudo apt update && sudo apt upgrade
```
<img width="600px" height="300px" src="img/img-1.png">
   
#### Далее устанавливаем Mina
```
sudo echo "deb [trusted=yes] http://packages.o1test.net $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/mina.list \
&& sudo apt update \
&& sudo apt install -y curl unzip mina-mainnet=3.0.0-93e0279
```
<img width="600px" height="300px" src="img/img-1.png">

#### 
