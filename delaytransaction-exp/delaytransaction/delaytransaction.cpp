#include <eosiolib/eosio.hpp>
#include <eosiolib/transaction.hpp>
#include <eosiolib/print.hpp>
using namespace eosio;

class delaytransaction : public eosio::contract {
  public:
      using contract::contract;

      /// @abi action
      void hi(uint128_t id, account_name user ) {
        print( "Hello, ", name{user} );
        eosio::transaction txn{};
        txn.actions.emplace_back(
            eosio::permission_level(_self, N(active)),
            _self,
            N(delayedhi),
            std::make_tuple(id));
        txn.delay_sec = 360;
        //(sender_id, payer, replace_existed)
        txn.send(id, _self, false);
      }

      void delayedhi(uint128_t id) {
          printf( "Delayed Hello %", id);
      }
};

EOSIO_ABI( delaytransaction, (hi)(delayedhi) )
