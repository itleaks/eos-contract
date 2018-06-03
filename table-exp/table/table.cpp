#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
#include <eosiolib/dispatcher.hpp>
#include <eosiolib/multi_index.hpp>

using namespace eosio;

class tabletest : public eosio::contract {
    private:
        /// @abi table
         struct contact {
            account_name name;
            uint64_t     phone;

            auto primary_key()const { return name; }
            uint64_t get_phone()const { return phone; }

            EOSLIB_SERIALIZE( contact, (name)(phone))
        };
        typedef eosio::multi_index<N(contact), contact, indexed_by< N(byphone), const_mem_fun<contact, uint64_t, &contact::get_phone> >
                  > contacts; 

    public:
        using contract::contract;

        /// @abi action 
        void add(account_name owner, account_name name, uint64_t phone ) {
            contacts contacttable( _self, owner );
            contacttable.emplace( _self, [&]( auto& o ) {
                o.name = name;
                o.phone = phone;
            });
        }

        /// @abi action 
        void remove(account_name owner, account_name contact_name) {
            contacts contacttable( _self, owner );
            name n{contact_name};
            auto item = contacttable.find( contact_name );
            if( item == contacttable.end() ) {
                print_f("Not found name:%sn", n.to_string().data());
            } else {
                contacttable.erase(item);
            };
        }

        /// @abi action 
        void modify(account_name owner, account_name contact_name, uint64_t phone) {
            contacts contacttable( _self, owner );
            name n{contact_name};
            auto item = contacttable.find( contact_name );
            if( item == contacttable.end() ) {
                print_f("Not found name:%sn", n.to_string().data());
            } else {
                contacttable.modify( item, _self, [&]( auto& o ) {
                    o.phone = phone;
                });
            };
        }

        /// @abi action 
        void findbyname(account_name owner, account_name contact_name) {
            contacts contacttable( _self, owner );
            name n{contact_name};
            auto item = contacttable.find( contact_name );
            if( item == contacttable.end() ) {
                print_f("Not found name:%s\n", n.to_string().data());
            } else {
                n = name{item->name};
                print_f("Found phone:%, for %s\n", item->phone, n.to_string().data());
            };
        }

        /// @abi action 
        void findbyphone(account_name owner, uint64_t phone) {
            contacts contacttable( _self, owner );
            auto phoneinx = contacttable.get_index<N(byphone)>();
            auto item = phoneinx.find(phone);
            if( item == phoneinx.end() ) {
                print_f("Not found phone:%\n", phone);
            } else {
                name n{item->name};
                print_f("Found name:%s for phone:%\n", n.to_string().data(), item->phone);
            };
        }
};

EOSIO_ABI( tabletest, (add) (remove) (modify) (findbyname) (findbyphone))