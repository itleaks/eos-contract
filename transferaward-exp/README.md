# Introduction(简介)
分布式空投，转账空投代币TransferAward示例程序

# Operation(操作)
```
cleos.sh set contract contractaccount ./eosio.token
cleos set account permission contractaccount active '{"threshold": 1,"keys": [{"key":"EOS_PUB_KEY_xxxx","weight":1}],"accounts": [{"permission":{"actor":"contractaccount","permission":"eosio.code"},"weight":1}]}' owner -p contractaccount@owner
cleos push action contractaccount create '["useruseridx1", "10000000.0000 TOKEN"]' -p contractaccount
#useruseridx2获得5000 token奖励
cleos push action contractaccount signup '["useruseridx2", "0.0000 TOKEN"]' -p useruseridx2
#useruseridx3获得5000 + 5000 token奖励,useruseridx4获得5000 token
cleos push action contractaccount transfer '["useruseridx3", "useruseridx4", "5000.0000 token"]' -p useruseridx3
```
