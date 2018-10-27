#!/bin/bash
WORK_DIR="$( dirname "$0"  )"
cd $WORK_DIR
WORK_DIR=`pwd`
OS=`uname`

COMPILER="js4eos compile"
#COMPILER='eosiocpp'
CLEOS="js4eos"
#CLEOS='cleos'

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
$CLEOS config set -n localnet
$CLEOS localnet reset
# launch nodeos command
else
#set jungle testnet
$CLEOS config -n jungle
#CLEOS='cleos -u junglenodeurl'
fi

CONTRACT_NAME='eosio.token'

if [ $LOCAL = true ];then
CONTRACT_ACCOUNT='contract1111'
TEST_ACCOUNT1=testaccount1
TEST_ACCOUNT2=testaccount2

CONTRACT_ACCOUNT_PRI='5JpRW33MdJQWoVUcLrLrkki8M8c8eaZDevTrHJLtPkUX7Su6DPU'
CONTRACT_ACCOUNT_PUB='EOS6z1ZU2qVeDBmneBMfHACFdMwxfjsRMHTZARRF6uR3hYyD6nuw6'
TEST_ACCOUNT_PRI_1='5HzZMHGcYY1PEhf37uzECRBXeBHiRQ75LY5ya85kMMr36hCaLHW'
TEST_ACCOUNT_PUB_1='EOS8jpkUrHmL65iYxTwDQCETuKHq1K5C4N6dTSQsccC5bWjtMQv5Y'
TEST_ACCOUNT_PRI_2='5KjjufiVnLcXULyyBeFzZRzHywtT1MbNfvsfWDEby3WQ9nhNzzg'
TEST_ACCOUNT_PUB_2='EOS5i7zvW5oUdkyrwSN8VnxX38uwB7U3HvSHZMuUhNgQF6P8H3M4V'
else
#please modify below account to a real 12 characters account
CONTRACT_ACCOUNT=xxx
TEST_ACCOUNT1=xxxx
TEST_ACCOUNT2=xxx

#please modify below key to a real key for corresponding account
CONTRACT_ACCOUNT_PRI='xx'
CONTRACT_ACCOUNT_PUB='xx'
TEST_ACCOUNT_PRI_1='xx'
TEST_ACCOUNT_PUB_1='xx'
TEST_ACCOUNT_PRI_2='xx'
TEST_ACCOUNT_PUB_2='xxx'
fi

# delete and create wallet to avoid input password
# only js4eos has delete command, formal cleos has no this command
# you need to remove 'test' wallet file manually located in $HOME/eosio-wallet
$CLEOS wallet delete -n test
$CLEOS wallet create -n test

#import private key
$CLEOS wallet import -n test $ROOT_ACCOUNT_PRI_KEY
$CLEOS wallet import -n test $CONTRACT_ACCOUNT_PRI
$CLEOS wallet import -n test $TEST_ACCOUNT_PRI_1
$CLEOS wallet import -n test $TEST_ACCOUNT_PRI_2

if [ $LOCAL = true ];then
echo "creating account"
$CLEOS create account eosio $CONTRACT_ACCOUNT $CONTRACT_ACCOUNT_PUB $CONTRACT_ACCOUNT_PUB
$CLEOS create account eosio $TEST_ACCOUNT1 $TEST_ACCOUNT_PUB_1 $TEST_ACCOUNT_PUB_1
$CLEOS create account eosio $TEST_ACCOUNT2 $TEST_ACCOUNT_PUB_2 $TEST_ACCOUNT_PUB_2
else
#accounts would already be created in other networks, do nothing here
echo ""
fi

#build code
cd $WORK_DIR/$CONTRACT_NAME
echo "compiling"
$COMPILER -o $CONTRACT_NAME.wasm $CONTRACT_NAME.cpp
#$COMPILER -g $CONTRACT_NAME.abi $CONTRACT_NAME.cpp
cd -

$CLEOS set contract $CONTRACT_ACCOUNT $CONTRACT_NAME -p $CONTRACT_ACCOUNT


echo ""
echo ""
echo "********run test case **********"
echo ""

ISSUER=$TEST_ACCOUNT1
$CLEOS push action $CONTRACT_ACCOUNT create '["'$ISSUER'", "10000000.0000 XXXX"]' -p $CONTRACT_ACCOUNT
$CLEOS push action $CONTRACT_ACCOUNT issue '["'$TEST_ACCOUNT2'", "50000.0000 XXXX"]' -p $ISSUER
$CLEOS push action $CONTRACT_ACCOUNT transfer '["'$TEST_ACCOUNT2'", "'$TEST_ACCOUNT1'", "100.0000 XXXX", "transfer test"]' -p $TEST_ACCOUNT2
$CLEOS get currency balance $CONTRACT_ACCOUNT $TEST_ACCOUNT1
$CLEOS get currency balance $CONTRACT_ACCOUNT $TEST_ACCOUNT2

if [ $LOCAL = true ];then
echo "stop nodeos"
js4eos localnet stop
fi