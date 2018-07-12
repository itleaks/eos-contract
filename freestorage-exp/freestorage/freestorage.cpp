#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
using namespace eosio;

class freestorage : public eosio::contract {
  public:
      using contract::contract;

      /// @abi action 
      void save(std::string data) {
      }
};

EOSIO_ABI( freestorage, (save) )
