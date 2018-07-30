# Introduction(简介)
Key point is set "eosio.code" permission，view details in run.sh<br>
智能合约调用智能合约示例，核心是配置eosio.code权限,可以在run.sh里查看更多详情
```
cleos set account permission args.user1 active '{"threshold": 1,"keys": [],"accounts": [{"permission":{"actor":"hello.code","permission":"eosio.code"},"weight":1}]}' owner -p args.user1@owner
```

# Run 'callcontract' demo
>cd eos-contract<br>
>./setup.sh<br>
>cd callcontract-exp<br>
>./run.sh
