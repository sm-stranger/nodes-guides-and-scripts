# Install Taiko Node
В этом руководстве мы рассмотрим установку ноды Taiko. Предполагается что вы уже арендовали сервер или уже есть существующий и подключились к нему с помощью терминала или другого консольного клиента.

<br/> 

<ul> 
 <li><a href="#automatic_install">Автоматическая установка</a></li> 
 <li><a href="#manual_install">Ручная установка</a></li> 
</ul>

<p name="automatic_install">
  
  ```
  wget -O Taiko_Node_Install.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/Taiko/Taiko_Node/Taiko_Node_Install.sh && chmod +x Taiko_Node_Install.sh && ./Taiko_Node_Install.sh
  ```
</p>

<br/>

<div name="manual_install">
 
 ## Ручная установка
 
 <br>
   
  #### Обновляем систему
  ```
  sudo apt update && sudo apt upgrade -y
  ```
  
  <br>
  
  #### Устанавливаем Docker
  
  ```
  sudo apt install ca-certificates curl gnupg && \
  sudo install -m 0755 -d/etc/apt/keyrings curl -fsSL https://download.docker.com/linux/ubuntu/gpg && \
  sudo gpg --dearmor -o/etc/apt/keyrings/docker.gpg/code> && \
  sudo chmod a+r/etc/apt/keyrings/docker.gpg && \
  echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  ```
  
  <br>
  
  #### Устанавливаем ноду и переходим в созданный каталог
   
  ```
  git clone https://github.com/taikoxyz/simple-taiko-node.git && \
  cd simple-taiko-node
  ```

  <br>
  
  #### Запускаем ноду
  
  ```
  docker compose up -d
  ```
  
  </div>
