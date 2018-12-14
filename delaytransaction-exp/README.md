# Run 'delaytransaction' demo
```
//setup
//mac
npm install -g js4eos
//ubuntu
sudo npm install -g js4eos
js4eos wallet create
js4eos wallet import your_private_key
//build
cd delaytransaction
js4eos compile -o delaytransaction.wasm delaytransaction.cpp 
js4eos compile -g delaytransaction.abi delaytransaction.cpp
//test
cd ..
js4eos set contract youraccount delaytransaction/
js4eos push action youraccount hi '[1000, "testaccount"]' -p testaccount
js4eos push action youraccount hi '[1000, "testaccount"]' -p testaccount
js4eos push action youraccount hi '[1001, "testaccount"]' -p testaccount
```
如果使用cleos程序，只需将上面的js4eos替换为cleos即可
# details(详情)
<a href="https://blog.csdn.net/ITleaks/article/details/83378319">
https://blog.csdn.net/ITleaks/article/details/83378319
</a>
