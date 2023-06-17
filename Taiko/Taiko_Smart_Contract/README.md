<h1>Taiko Smart Contract</h1>

<p>В этом руководстве мы рассмотрим деплой и выполнение смарт контракта Taiko. Предполагается что у вас уже есть установленная нода по этому гайду https://teletype.in/@dk_rnm/4aZbaoEBBxb, если же нет - воспользуйтесь указанным руководством либо используйте  скрипт автоматической установки:
  <pre><code>wget -O Taiko_Node_Install.sh https://raw.githubusercontent.com/sm-stranger/nodes-guides-and-scripts/main/Taiko/Taiko_Node/Taiko_Node_Install.sh && chmod +x Taiko_Node_Install.sh && ./Taiko_Node_Install.sh </code></pre>
</p>


<div>

  <br>
  
  <hr/>
  
  <br>
  
  <p>
    <b>Сначала установим Foundry</b>
    <pre><code>curl -L https://foundry.paradigm.xyz | bash </code></pre>
  </p>

  <br>
  
  <p>
    <b>Создаем проект с Foundry</b>
    <pre><code>forge init hello_foundry && cd hello_foundry</code></pre>
  </p>

  <br>

  <p>
    <b>Разворачиваем (делаем деплой) контракта</b>
    <pre><code>forge create --rpc-url https://rpc.test.taiko.xyz --private-key YOUR_PRIVATE_KEY src/Counter.sol:Counter</code></pre>
  </p>
  
</div>
