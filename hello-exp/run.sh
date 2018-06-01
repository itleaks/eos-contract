#!/bin/bash
WORK_DIR="$( dirname "$0"  )"
cd $WORK_DIR
WORK_DIR=`pwd`
OS=`uname`

#build code
cd $WORK_DIR/hello
#eosiocpp -o hello.wast hello.cpp
#eosiocpp -g hello.abi hello.cpp
cd -


if [ ! -f $WORK_DIR"/../passwd.txt" ];then
	echo "wallet exp not exist, please run ../setup.sh"
	exit
else
	cat $WORK_DIR/../passwd.txt | cleos wallet unlock -n exp
fi

#kill old nodeos
if [ $OS"x" == "Darwinx" ];then
	ps a > ./tmp.txt
	grep "nodeos" ./tmp.txt|awk '{print $1}'|xargs kill -9
	rm ./tmp.txt
else
	ps auxf|grep "nodeos -e"|awk '{print $2}'|xargs kill -9
fi
#launch nodeos
echo "launch nodeos ......"
nohup nodeos -e -p eosio --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --data-dir ./.tmpdata/eosio --resync 2>&1 1>nodeos.log &
sleep 2
#使用默认的私钥，公钥，这个你们也都有
cleos create account eosio hello.code EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos set contract hello.code ./hello -p hello.code
cleos create account eosio args.user EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo ""
echo ""
echo "********run test case **********"
echo ""
echo 'cleos push action hello.code hi '[ "args.user" ]' -p hello.code'
cleos push action hello.code hi '[ "args.user" ]' -p hello.code
echo 'cleos push action hello.code hi '[ "args.user" ]' -p args.user'
cleos push action hello.code hi '[ "args.user" ]' -p args.user
