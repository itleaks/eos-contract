#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
using namespace eosio;

class hello : public eosio::contract {
  public:
    using contract::contract;

    /// @abi action 
    void hi( account_name from, account_name to) {
        require_auth(from);
        print( "Hello, from:", name{from}, ", to:", name{to});
        action(
            //这里{to, active}必须授权给{_self, eosio.code}
            permission_level{to, N(active)},
            //调用 hello.target合约 的'callme' action
            N(hello.target), N(callme),
            std::make_tuple(to)
         ).send();
    }
};

EOSIO_ABI( hello, (hi) )
