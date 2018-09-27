#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
#include <eosiolib/asset.hpp>
#include <eosiolib/types.hpp>
#include <eosiolib/action.hpp>
#include <eosiolib/symbol.hpp>
#include <cstring>

using namespace eosio;
using namespace std;

#define EOSIO_ABI_EX( TYPE, MEMBERS ) \
extern "C" { \
    void apply( uint64_t receiver, uint64_t code, uint64_t action ) { \
        auto self = receiver; \
        if( action == N(onerror)) { \
            /* onerror is only valid if it is for the "eosio" code account and authorized by "eosio"'s "active permission */ \
            eosio_assert(code == N(eosio), "onerror action's are only valid from the \"eosio\" system account"); \
        } \
        if((code == N(eosio.token) && action == N(transfer)) ) { \
            TYPE thiscontract( self ); \
            switch( action ) { \
                EOSIO_API( TYPE, MEMBERS ) \
            } \
         /* does not allow destructor of thiscontract to run: eosio_exit(0); */ \
        } \
    } \
} \

class receipt : public eosio::contract {
   private:
        /// @abi table
        struct contact {
            account_name name;
            auto primary_key()const { return name; }
            EOSLIB_SERIALIZE( contact, (name))
        };
        typedef eosio::multi_index<N(contact), contact> contacts;

  public:
    using contract::contract;

    /// @abi action 
    void transfer(account_name from, account_name to, asset quantity, string memo) {
        contacts contacttable( _self, from );
        contacttable.emplace( from, [&]( auto& o ) {
            account_name account = string_to_name(memo.c_str());
            o.name = account;
        });
    }
};

EOSIO_ABI_EX( receipt, (transfer) )
