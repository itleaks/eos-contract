# Run 'newhello' demo
newhello的hello合约是eosio.cdt规范的合约
```
//mac
npm install -g js4eos
//ubuntu
sudo npm install -g js4eos
js4eos wallet create
js4eos wallet import your_private_key
js4eos compile -o hello/hello.wasm hello/hello.cpp
js4eos compile -g hello/hello.abi hello/hello.cpp
js4eos set contract youraccount hello
js4eos push action youraccount hi '["youraccount"]' -p youraccount
```
如果使用cleos程序，只需将上面的js4eos替换为cleos即可<br>

如果你在linux/mac下且有本地nodeos可以使用run.sh脚本一键执行
```
#install js4eos if not
sudo npm install -g js4eos
#run
./run.sh
```