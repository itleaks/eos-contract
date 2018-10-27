# Run 'eosio.token' demo
EOS一键发币
```
//mac
npm install -g js4eos
//ubuntu
sudo npm install -g js4eos
js4eos wallet create
//请一个一个导入下面用到的账号的私钥
js4eos wallet import your_private_key
js4eos compile -o eosio.token/eosio.token.wasm eosio.token/eosio.token.cpp
js4eos set contract contractaccount eosio.token
js4eos push action contractaccount create '["issueaccount", "10000000.0000 XXXX"]' -p contractaccount
js4eos push action contractaccount issue '["anotheraccount", "50000.0000 XXXX"]' -p issueaccount
js4eos push action contractaccount transfer '["anotheraccount", "issueaccount", "100.0000 XXXX", "transfer test"]' -p anotheraccount
js4eos get currency balance contractaccount anotheraccount
js4eos get currency balance contractaccount issueaccount
#上面的各种账号请更改为你的真实账号
```
如果使用cleos程序，只需将上面的js4eos替换为cleos即可<br>

如果你在linux/mac下且有本地nodeos可以使用run.sh脚本一键执行
```
#install js4eos if not
sudo npm install -g js4eos
#run
./run.sh
```