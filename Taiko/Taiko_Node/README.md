
<h1>Install Taiko Node</h1>

<p>
  В этом руководстве мы рассмотрим установку ноды Taiko. Предполагается что вы уже арендовали сервер или уже есть существующий и подключились к нему с помощью терминала или другого консольного клиента.
</p>

<br/>

<ul>
  <li><a href="#automatic_install">Автоматическая установка</a></li>
  <li><a href="#manual_install">Ручная установка</a></li>
</ul>

<p name="automatic_install">
  
</p>

<br/>

<div name="manual_install">
  
  <h2>РУЧНАЯ УСТАНОВКА</h2>
  
  <br>
  
  <p>
    <b>Обновляем систему</b>
    <pre><code>sudo apt update && sudo apt upgrade -y</code></pre>
  </p>
  
  <p>
    <h3>Устанавливаем Docker</h3>
    <b>Установка пакетов</b>
    <pre><code>sudo apt install ca-certificates curl gnupg</code></pre>
    <b>Добавляем ключ GPG</b>
    <pre><code>sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg</code></pre>
    </p>
  
</div>
