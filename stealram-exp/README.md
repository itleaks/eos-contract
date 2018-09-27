# Introduction(简介)
偷窃RAM漏洞实践

# Operation(操作)
```
cleos set contract youraccount stealram
//下面的EOS转账会调用youraccount这个智能合约的transfer方法
cleos push action eosio.token transfer '["testaccount", "youraccount", "3.0000 EOS", "itleakstoken"]' -p testaccount
```
