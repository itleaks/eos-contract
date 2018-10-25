#!/bin/bash
WORK_DIR="$( dirname "$0"  )"
cd $WORK_DIR
WORK_DIR=`pwd`
OS=`uname`

COMPILER='js4eos compile'
#COMPILER='eosiocpp'
CLEOS='js4eos'
#CLEOS='$CLEOS'

LOCAL=true
if [ $LOCAL = true ];then
ROOT_ACCOUNT_PRI_KEY='5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3'
ROOT_ACCOUNT_PUB_KEY='EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV'
ROOT_ACCOUNT='eosio'
else
ROOT_ACCOUNT_PRI_KEY='private key of youraccount'
ROOT_ACCOUNT_PUB_KEY='public key of youraccount'
ROOT_ACCOUNT='youraccount'
fi

#set network
if [ $LOCAL = true ];then
js4eos config set -n localnet
js4eos localnet reset
# launch nodeos command
else
#set jungle testnet
js4eos config -n jungle
#CLEOS='cleos -u junglenodeurl'
fi

KEY_PRI_1=5HzZMHGcYY1PEhf37uzECRBXeBHiRQ75LY5ya85kMMr36hCaLHW
KEY_PUB_1=EOS8jpkUrHmL65iYxTwDQCETuKHq1K5C4N6dTSQsccC5bWjtMQv5Y
KEY_PRI_2=5KjjufiVnLcXULyyBeFzZRzHywtT1MbNfvsfWDEby3WQ9nhNzzg
KEY_PUB_2=EOS5i7zvW5oUdkyrwSN8VnxX38uwB7U3HvSHZMuUhNgQF6P8H3M4V

#build code
cd $WORK_DIR/hello
echo "compiling"
$COMPILER -o hello.wasm hello.cpp
$COMPILER -g hello.abi hello.cpp
cd -

# delete and create wallet to avoid input password
# only js4eos has delete command, formal cleos has no this command
# you need to remove 'test' wallet file manually located in $HOME/eosio-wallet
$CLEOS wallet delete -n test
$CLEOS wallet create -n test

#import private key
echo "creating account"
$CLEOS wallet import -n test $ROOT_ACCOUNT_PRI_KEY
$CLEOS wallet import -n test $KEY_PRI_1
$CLEOS wallet import -n test $KEY_PRI_2

$CLEOS create account eosio hello.code $KEY_PUB_1 $KEY_PUB_1
$CLEOS set contract hello.code ./hello -p hello.code
$CLEOS create account eosio args.user $KEY_PUB_2 $KEY_PUB_2

echo ""
echo ""
echo "********run test case **********"
echo ""
echo '$CLEOS push action hello.code hi '[ "args.user" ]' -p hello.code'
$CLEOS push action hello.code hi '[ "args.user" ]' -p hello.code
echo '$CLEOS push action hello.code hi '[ "args.user" ]' -p args.user'
$CLEOS push action hello.code hi '[ "args.user" ]' -p args.user
if [ $LOCAL = true ];then
echo "stop nodeos"
js4eos localnet stop
fi
