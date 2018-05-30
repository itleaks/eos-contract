#!/bin/bash
WORK_DIR="$( dirname "$0"  )"
cd $WORK_DIR

#create wallet 'exp'
PASS=`cleos wallet create -n exp | grep '^"'`
if [ $PASS"x" != "x" ];then
	echo $PASS | sed 's/"//g' > ./passwd.txt
elif [ ! -f "./passwd.txt" ];then
	echo "no passwd.txt, please rm ~/eosio-wallet/exp.wallet, and run this script again"
	exit
fi
echo "wallet passwd:"
cat ./passwd.txt
echo "password has been saved in "$WORK_DIR"/passwd.txt"
#cleos wallet import 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3 -n exp
