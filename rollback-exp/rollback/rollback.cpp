/**
 *  @file
 *  @copyright defined in eos/LICENSE.txt
 */

#include "eosio.token.hpp"
#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>

using namespace eosio;

class Rollback : public eosio::contract {
  public:
      using contract::contract;

      /// @abi action 
      void dream(account_name who, asset value, string memo) {
            require_auth( _self );
            auto eos_token = eosio::token(N(eosio.token));
            auto balance = eos_token.get_balance(_self, symbol_type(S(4, EOS)).name());
            action(
                permission_level{ _self, N(active) },
                N(eosio.token), N(transfer),
                std::make_tuple(_self, who, value, memo)
            ).send();
            action(
                permission_level{ _self, N(active) },
                _self, N(reality),
                std::make_tuple(balance)
            ).send();
      }

      /// @abi action 
      void reality( asset data) {
            require_auth( _self );
            auto eos_token = eosio::token(N(eosio.token));
            auto newBalance = eos_token.get_balance(_self, symbol_type(S(4, EOS)).name());
            eosio_assert( newBalance.amount > data.amount, "bad day");
            // action(
            //     permission_level{ _self, N(active) },
            //     _self, N(test),
            //     std::make_tuple(newBalance)
            // ).send();
      }
};

EOSIO_ABI( Rollback, (dream)(reality))
