#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
using namespace eosio;

class target : public eosio::contract {
  public:
    using contract::contract;

    /// @abi action 
    void callme( account_name user ) {
        require_auth(user);
        print( "Call me from, ", name{user} );
    }
};

EOSIO_ABI( target, (callme) )
