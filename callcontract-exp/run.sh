#!/bin/bash
echoCmd() {
	echo -e "\033[36;41m"$1"\033[0m"
}
WORK_DIR="$( dirname "$0"  )"
cd $WORK_DIR
WORK_DIR=`pwd`
OS=`uname`

#build code
cd $WORK_DIR/hello
#eosiocpp -o hello.wast hello.cpp
#eosiocpp -g hello.abi hello.cpp
cd -

KEY_PRIVATE_1=5HzZMHGcYY1PEhf37uzECRBXeBHiRQ75LY5ya85kMMr36hCaLHW
KEY_PUB_1=EOS8jpkUrHmL65iYxTwDQCETuKHq1K5C4N6dTSQsccC5bWjtMQv5Y

KEY_PRIVATE_2=5KjjufiVnLcXULyyBeFzZRzHywtT1MbNfvsfWDEby3WQ9nhNzzg
KEY_PUB_2=EOS5i7zvW5oUdkyrwSN8VnxX38uwB7U3HvSHZMuUhNgQF6P8H3M4V

KEY_PRIVATE_3=5KZG619Fht23AYGuh3Py8ZapQkrEWrRy3A7bax5eegoCWYfnvTv
KEY_PUB_3=EOS8F9J5oceGUHzJRU63jTxaJ7j4chPEcBLjpAaFpMfqpbLUKKeMM

KEY_PRIVATE_4=5JnX3aENCraodCwALemQR488XnvtYKF3Yjr8UPPuSdqVnJ7Y4j6
KEY_PUB_4=EOS6B3YWEnEk2cNJekvr2cCC8C572F9ZUBkQCU1uK4x6sBmzo95KN


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
cleos wallet import -n exp $KEY_PRIVATE_3
cleos wallet import -n exp $KEY_PRIVATE_4

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
#deploy hello contract
cleos create account eosio hello.code $KEY_PUB_1 $KEY_PUB_1
cleos set contract hello.code ./hello -p hello.code
cleos create account eosio args.user $KEY_PUB_2 $KEY_PUB_2

#deploy hello target contract
cleos create account eosio hello.target $KEY_PUB_3 $KEY_PUB_3
cleos create account eosio args.user1 $KEY_PUB_4 $KEY_PUB_4
cleos set contract hello.target ./hello.target -p hello.target
cleos set account permission args.user1 active '{"threshold": 1,"keys": [],"accounts": [{"permission":{"actor":"hello.code","permission":"eosio.code"},"weight":1}]}' owner -p args.user1@owner

echo ""
echo ""
echo "********run test case **********"
echo ""
echoCmd "cleos push action hello.code hi '["args.user"]' -p args.user"
cleos push action hello.code hi '["args.user", "args.user1"]' -p args.user
sleep 1

echo ""
echo ""
echo "********run test more case **********"
echoCmd "cleos push action hello.code hi '["args.user", "args.user"]' -p args.user"
cleos push action hello.code hi '["args.user", "args.user"]' -p args.user
cleos set account permission args.user active '{"threshold": 1,"keys": [{"key":"'$KEY_PUB_3'", "weight":1}],"accounts": [{"permission":{"actor":"hello.code","permission":"eosio.code"},"weight":1}]}' owner -p args.user@owner
echoCmd "after set permission eosio.code"
echoCmd "cleos push action hello.code hi '["args.user", "args.user"]' -p args.user"
cleos push action hello.code hi '["args.user", "args.user"]' -p args.user
#cleos push action hello.target callme '["hello.code"]' -p hello.code
