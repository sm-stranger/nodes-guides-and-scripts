# Деплой Смарт Контракта Taiko


#### 1. Получение тестовых токенов
Перым делом нам надо получить Sepolia ETH для оплаты комиссии на газ за деплой. Если у вас уже есть тестовые токены - пропускайте этот шаг и переходите к следующему.
На выбор у нас несколько кранов:
https://taiko.xyz/docs/guides/build-on-taiko/receive-tokens#receive-sepolia-eth. Воспользуемся https://sepoliafaucet.com. Логинимся через свой Google Аккаунт
<img src="img/Taiko_SC_Login_Alchemy.png" width="auto" height="400px">
<img src="img/Taiko_SC_Login_Alchemy_Google.png" width="auto" height="400px">

Вставляем свой адерс и нажимаем Send Me ETH
<img src="img/Taiko_SC_Enter_Address.png" width="auto" height="400px">


#### 2. Деплой
Переходим на сайт https://remix.ethereum.org
Выбираем смарт контракт storage.sol
<img src="img/Taiko_SC_Select_SC.png" width="auto" height="400px">
<br>
Компилируем контракт
<img src="img/Taiko_SC_Compile_SC.png" width="auto" height="400px">

И последний шаг - деплой. 
В списке Environment выбираем Injected Provider - Metamask и нажимаем Deploy
<img src="img/Taiko_SC_Compile_Deploy.png" width="auto" height="400px">

Подтверждаем транзакцию
<img src="img/Taiko_SC_Compile_Deploy_Approove.png" width="auto" height="400px">

Деплой успешно выполнен. Можно посмотреть транзакцию в Etherscan. Еще раз подтверждаем транзакцию
<img src="img/Taiko_SC_Compile_Deploy_Succ.png" width="auto" height="400px">



#### 
