# Install Taiko Node
Для установки ноды Taiko воспользуйтесь скриптом ниже. Вам понадобятся конечные точки (Endpoint-ы)<b> L1_ENDPOINT_HTTP</b> и <b>L1_ENDPOINT_WS</b> .
Получить вы их можете на сайте https://app.infura.io/ в своем личном кабинете

<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_1.png" target="_blank">
<br>
<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_2.png" target="_blank">
<br>
<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_3.png" target="_blank">
Записываем скопированное значение в переменную L1_ENDPOINT_HTTP

```
L1_ENDPOINT_HTTP=https://sepolia.infura.io/v3/********
```
<br>
<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_4.png" target="_blank">
Записываем скопированное значение в переменную L1_ENDPOINT_WS

```
L1_ENDPOINT_WS=wss://sepolia.infura.io/ws/v3/********
```
<br>
Также вам нужен приватный ключ <b>L1_PROVER_PRIVATE_KEY</b>. Брать мы его будем из метамаска.
<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_5.png" target="_blank">
<br>
<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_6.png" target="_blank">


  
```
wget -O Taiko_Node_Install.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/Taiko/Taiko_Node/Taiko_Node_Install.sh && chmod +x Taiko_Node_Install.sh && ./Taiko_Node_Install.sh
```
