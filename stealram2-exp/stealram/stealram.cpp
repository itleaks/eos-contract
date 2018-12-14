#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
#include <eosiolib/asset.hpp>
#include <eosiolib/types.hpp>
#include <eosiolib/action.hpp>
#include <eosiolib/symbol.hpp>
#include <cstring>

using namespace eosio;
using namespace std;

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
    void hack(account_name to, string memo) {
        action(
            permission_level{to, N(active) },
            _self, N(pay),
            std::make_tuple(to, memo)
        ).send();
    }

    /// @abi action 
    void pay(account_name to, string memo) {
        contacts contacttable( _self, to);
        contacttable.emplace( to, [&]( auto& o ) {
            account_name account = string_to_name(memo.c_str());
            o.name = account;
        });
    }
};

EOSIO_ABI( receipt, (hack)(pay) )
