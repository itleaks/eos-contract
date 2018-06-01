#!/bin/bash
WORK_DIR="$( dirname "$0"  )"
cd $WORK_DIR
WORK_DIR=`pwd`
OS=`uname`

KEY_PRIVATE_1=5HzZMHGcYY1PEhf37uzECRBXeBHiRQ75LY5ya85kMMr36hCaLHW
KEY_PUB_1=EOS8jpkUrHmL65iYxTwDQCETuKHq1K5C4N6dTSQsccC5bWjtMQv5Y

KEY_PRIVATE_2=5KjjufiVnLcXULyyBeFzZRzHywtT1MbNfvsfWDEby3WQ9nhNzzg
KEY_PUB_2=EOS5i7zvW5oUdkyrwSN8VnxX38uwB7U3HvSHZMuUhNgQF6P8H3M4V

#build code
cd $WORK_DIR/hello
#eosiocpp -o hello.wast hello.cpp
#eosiocpp -g hello.abi hello.cpp
cd -


if [ ! -f $WORK_DIR"/../passwd.txt" ];then
	../setup.sh
fi
cat $WORK_DIR/../passwd.txt | cleos wallet unlock -n exp
cleos wallet import -n exp $KEY_PRIVATE_1
cleos wallet import -n exp $KEY_PRIVATE_2

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
cleos create account eosio hello.code $KEY_PUB_1 $KEY_PUB_1
cleos set contract hello.code ./hello -p hello.code
cleos create account eosio args.user $KEY_PUB_2 $KEY_PUB_2

echo ""
echo ""
echo "********run test case **********"
echo ""
echo 'cleos push action hello.code hi '[ "args.user" ]' -p hello.code'
cleos push action hello.code hi '[ "args.user" ]' -p hello.code
echo 'cleos push action hello.code hi '[ "args.user" ]' -p args.user'
cleos push action hello.code hi '[ "args.user" ]' -p args.user
