
Skip to content

Search or jump to...
Pull requests
Issues
Codespaces
Marketplace
Explore
 
@sm-stranger 
sm-stranger
/
nodes-guides-and-scripts
Public
Cannot fork because you own this repository and are not a member of any organizations.
Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights
Settings
Pane width
Use a value between 18% and 33%

18
Change width
Code
Go to file
t
Massa
Shardeum
Taiko
Taiko_Node
README.md
README.md
aleo
muon
nibiru
sei
starknet
README.md
fn.sh
Documentation • Share feedback
Breadcrumbsnodes-guides-and-scripts/Taiko/Taiko_Node/README.md <h1>Install Taiko Node</h1> <p> В этом руководстве мы рассмотрим установку ноды Taiko. Предполагается что вы уже арендовали сервер или уже есть существующий и подключились к нему с помощью терминала или другого консольного клиента. </p> <br/> <ul> <li><a href="#automatic_install">Автоматическая установка</a></li> <li><a href="#manual_install">Ручная установка</a></li> </ul> <p name="automatic_install"> </p> <br/> <div name="manual_install"> <h2>РУЧНАЯ УСТАНОВКА</h2> <br> <p> <b>Обновляем систему</b> <pre><code>sudo apt update && sudo apt upgrade -y</code></pre> </p> <p> <h3>Устанавливаем Docker</h3> <b>Установка пакетов</b> <pre><code>sudo apt install ca-certificates curl gnupg</code></pre> <b>Добавляем ключ GPG</b> <pre><code>sudo install -m 0755 -d/etc/apt/keyrings curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o/etc/apt/keyrings/docker.gpg sudo chmod a+r/etc/apt/keyrings/docker.gpg</code></pre> </p> <
/
div>
in
main

Edit

Preview
Indent mode

Spaces
Indent size

2
Line wrap mode

Soft wrap
1
​
2
​
Editing nodes-guides-and-scripts/Taiko/Taiko_Node/README.md at main · sm-stranger/nodes-guides-and-scripts · GitHub
