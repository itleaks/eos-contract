#!/bin/bash
echoCmd() {
	echo -e "\033[31;46m"$1"\033[0m"
}
WORK_DIR="$( dirname "$0"  )"
cd $WORK_DIR
WORK_DIR=`pwd`
OS=`uname`

KEY_PRIVATE_1=5HzZMHGcYY1PEhf37uzECRBXeBaddRQ75LY5ya85kMMr36hCaLHW
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
cleos create account eosio table.code $KEY_PUB_1 $KEY_PUB_1
cleos set contract table.code ./table -p table.code
cleos create account eosio itleaks $KEY_PUB_2 $KEY_PUB_2

echo ""
echo ""
echo "********run test case **********"
echo ""
echoCmd "cleos push action table.code add '[ "itleaks", "jackma", "13456" ]' -p table.code"
cleos push action table.code add '[ "itleaks", "jackma", "13456" ]' -p itleaks
cleos get table table.code itleaks contact
echoCmd "cleos push action table.code add '[ "itleaks", "qqma", "13455" ]' -p table.code"
cleos push action table.code add '[ "itleaks", "qqma", "13455" ]' -p itleaks
cleos get table table.code itleaks contact
echoCmd "cleos push action table.code findbyname '[ "itleaks", "qqma" ]' -p itleaks"
cleos push action table.code findbyname '[ "itleaks", "qqma" ]' -p itleaks
echoCmd "cleos push action table.code findbyphone '[ "itleaks", "13456" ]' -p itleaks"
cleos push action table.code findbyphone '[ "itleaks", "13456" ]' -p itleaks

echoCmd "cleos push action table.code modify '[ "itleaks", "jackma", "654321" ]' -p itleaks"
cleos push action table.code modify '[ "itleaks", "jackma", "654321" ]' -p itleaks
cleos get table table.code itleaks contact

echoCmd "cleos push action table.code remove '[ "itleaks", "jackma"]' -p itleaks"
cleos push action table.code remove '[ "itleaks", "jackma"]' -p itleaks
cleos get table table.code itleaks contact
