# Install Taiko Node
Для установки ноды Taiko воспользуйтесь скриптом ниже. Вам понадобятся Endpoint-ы<b> L1_ENDPOINT_HTTP</b> и <b>L1_ENDPOINT_WS</b> и приватный ключ L1_PROVER_PRIVATE_KEY
Endpoint-ы вы можете получить на сайте https://app.infura.io/

<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_1.png" target="_blank">
<br>
<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_2.png" target="_blank">

<br>

#### Получаем L1_ENDPOINT_HTTP
<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_3.png" target="_blank">
Записываем куда-нибудь скопированное значение

<br><br>

#### Получаем L1_ENDPOINT_WS
<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_4.png" target="_blank">
Также записываем куда-нибудь скопированное значение

<br><br>

#### Далее нам нужно получить приватный ключ <b>L1_PROVER_PRIVATE_KEY</b>
<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_5.png" target="_blank">
<br>
<img width="800px" src="https://github.com/sm-stranger/nodes-guides-and-scripts/blob/main/Taiko/Taiko_Node/src/Taiko_Node_Install_6.png" target="_blank">

Опять же записываем куда-нибудь.

Далее устанавливаем ноду скриптом
  
```
wget -O Taiko_Node_Install.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/Taiko/Taiko_Node/Taiko_Node_Install.sh && chmod +x Taiko_Node_Install.sh && ./Taiko_Node_Install.sh
```
