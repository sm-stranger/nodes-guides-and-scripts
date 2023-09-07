# Деплой Смарт Контракта Taiko


#### 1. Получение тестовых токенов
<p>
    Перым делом нам надо получить Sepolia ETH для оплаты комиссии на газ за деплой. Если у вас уже есть тестовые токены - пропускайте этот шаг и переходите к следующему.
</p>
<p>
<p>
На выбор у нас несколько кранов:
https://taiko.xyz/docs/guides/build-on-taiko/receive-tokens#receive-sepolia-eth. Воспользуемся https://sepoliafaucet.com. Логинимся через свой Google Аккаунт
</p>
<img src="img/Taiko_SC_Login_Alchemy.png" width="auto" height="400px">
<img src="img/Taiko_SC_Login_Alchemy_Google.png" width="auto" height="400px">

<p>Вставляем свой адерс и нажимаем Send Me ETH</p>
<img src="img/Taiko_SC_Enter_Address.png" width="auto" height="400px">


#### 2. Деплой
<p>Переходим на сайт https://remix.ethereum.org и выбираем смарт контракт storage.sol</p>
<img src="img/Taiko_SC_Select_SC.png" width="auto" height="400px">
<br>
<p>Компилируем контракт</p>
<img src="img/Taiko_SC_Compile_SC.png" width="auto" height="400px">

<p>
И последний шаг - деплой. 
В списке Environment выбираем Injected Provider - Metamask и нажимаем Deploy
</p>
<img src="img/Taiko_SC_Compile_Deploy.png" width="auto" height="400px">

<p>Подтверждаем транзакцию</p>
<img src="img/Taiko_SC_Compile_Deploy_Approove.png" width="auto" height="400px">

<p>Деплой успешно выполнен. Можно посмотреть транзакцию в Etherscan. Еще раз подтверждаем транзакцию</p>
<img src="img/Taiko_SC_Compile_Deploy_Succ.png" width="auto" height="400px">
