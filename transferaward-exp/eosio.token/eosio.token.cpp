/**
 *  @file
 *  @copyright defined in eos/LICENSE.txt
 */

#include "eosio.token.hpp"

namespace eosio {
#define AWARD_ACCOUNT _self
#define TOTAL_AMOUNT                   100000000000000 //total 100 billion
#define TOTAL_AWARD_AMOUNT             50000000000000  //transfer award
#define MAX_TRANSFER_AWARD_AMOUNT      100000000       //one transfer award
#define MIN_TRANSFER_AWARD_AMOUNT      50000000        //min transfer award
#define AWARD_RATE                     2               //min transfer award
#define AWARD_MEMO                     "Transfer Award"

void token::create( account_name issuer,
                    asset        maximum_supply )
{
    require_auth( _self );

    auto sym = maximum_supply.symbol;
    eosio_assert( sym.is_valid(), "invalid symbol name" );
    eosio_assert( maximum_supply.is_valid(), "invalid supply");
    eosio_assert( maximum_supply.amount > 0, "max-supply must be positive");

    stats statstable( _self, sym.name() );
    auto existing = statstable.find( sym.name() );
    eosio_assert( existing == statstable.end(), "token with symbol already exists" );

    statstable.emplace( _self, [&]( auto& s ) {
       s.supply.amount = TOTAL_AWARD_AMOUNT;
       add_balance( AWARD_ACCOUNT, asset(s.supply.amount, maximum_supply.symbol), _self);
       s.supply.symbol = maximum_supply.symbol;
       s.max_supply    = asset(TOTAL_AMOUNT, sym);
       s.issuer        = issuer;
    });
}

void token::issue( account_name to, asset quantity, string memo )
{
    auto sym = quantity.symbol;
    eosio_assert( sym.is_valid(), "invalid symbol name" );
    eosio_assert( memo.size() <= 256, "memo has more than 256 bytes" );

    auto sym_name = sym.name();
    stats statstable( _self, sym_name );
    auto existing = statstable.find( sym_name );
    eosio_assert( existing != statstable.end(), "token with symbol does not exist, create token before issue" );
    const auto& st = *existing;

    require_auth( st.issuer );
    eosio_assert( quantity.is_valid(), "invalid quantity" );
    eosio_assert( quantity.amount > 0, "must issue positive quantity" );

    eosio_assert( quantity.symbol == st.supply.symbol, "symbol precision mismatch" );
    eosio_assert( quantity.amount <= st.max_supply.amount - st.supply.amount, "quantity exceeds available supply");

    statstable.modify( st, 0, [&]( auto& s ) {
       s.supply += quantity;
    });

    add_balance( st.issuer, quantity, st.issuer );

    if( to != st.issuer ) {
        action(
            permission_level{ st.issuer, N(active) },
            _self, N(transfer),
            std::make_tuple(st.issuer, to, quantity, memo)
        ).send();
    }
}

void token::transfer( account_name from,
                      account_name to,
                      asset        quantity,
                      string       memo )
{
    eosio_assert( from != to, "cannot transfer to self" );
    require_auth( from );
    eosio_assert( is_account( to ), "to account does not exist");
    auto sym = quantity.symbol.name();
    stats statstable( _self, sym );
    const auto& st = statstable.get( sym );

    require_recipient( from );
    require_recipient( to );

    eosio_assert( quantity.is_valid(), "invalid quantity" );
    eosio_assert( quantity.amount > 0, "must transfer positive quantity" );
    eosio_assert( quantity.symbol == st.supply.symbol, "symbol precision mismatch" );
    eosio_assert( memo.size() <= 256, "memo has more than 256 bytes" );

    if (from == AWARD_ACCOUNT && memo == AWARD_MEMO ) {
        //A Fake transfer
        return;
    }
    //check whether 'from' has balance history
    accounts from_acnts( _self, from);
    auto tmp = from_acnts.find( quantity.symbol.name());
    if( tmp == from_acnts.end() ) {
        //from is a new account
        auto award = MIN_TRANSFER_AWARD_AMOUNT;
        //Transfer award from award_account to from
        asset awardAsset(award, quantity.symbol);
        add_balance( from, awardAsset, from);

        //Save award data on blockChain by send a fake transfer
        action(
            permission_level{ AWARD_ACCOUNT, N(active) },
            _self, N(transfer),
            std::make_tuple(AWARD_ACCOUNT, to, awardAsset, AWARD_MEMO)
        ).send();
    }
    sub_balance( from, quantity );
    add_balance( to, quantity, from );
}

void token::sub_balance( account_name owner, asset value ) {
   accounts from_acnts( _self, owner );

   const auto& from = from_acnts.get( value.symbol.name(), "no balance object found" );
   eosio_assert( from.balance.amount >= value.amount, "overdrawn balance" );


   //Not clean data temporary
   if( false && from.balance.amount == value.amount ) {
      from_acnts.erase( from );
   } else {
      from_acnts.modify( from, 0, [&]( auto& a ) {
          a.balance -= value;
      });
   }
}

void token::add_balance( account_name owner, asset value, account_name ram_payer )
{
   accounts to_acnts( _self, owner );
   auto to = to_acnts.find( value.symbol.name() );
   if( to == to_acnts.end() ) {
      to_acnts.emplace( ram_payer, [&]( auto& a ){
        a.balance = value;
      });
      if(owner == AWARD_ACCOUNT || owner == ram_payer) {
          return;
      }
      //to is a new account, award player account
      auto award = MIN_TRANSFER_AWARD_AMOUNT + value.amount;
      if (award > MAX_TRANSFER_AWARD_AMOUNT) {
          award = MAX_TRANSFER_AWARD_AMOUNT;
      }
      //Transfer award
      asset awardAsset(award, value.symbol);
      sub_balance(AWARD_ACCOUNT, awardAsset);
      accounts player_acnts( _self, ram_payer);
      auto player = player_acnts.find( value.symbol.name() );
      player_acnts.modify( player, 0, [&]( auto& a ) {
        a.balance += awardAsset;
      });
      //Save award data on blockChain by send a fake transfer
        action(
            permission_level{ AWARD_ACCOUNT, N(active) },
            _self, N(transfer),
            std::make_tuple(AWARD_ACCOUNT, ram_payer, awardAsset, AWARD_MEMO)
        ).send();
   } else {
      to_acnts.modify( to, 0, [&]( auto& a ) {
        a.balance += value;
      });
   }
}

} /// namespace eosio

EOSIO_ABI( eosio::token, (create)(issue)(transfer) )
