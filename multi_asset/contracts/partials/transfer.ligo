#include "./action.ligo"
#include "./storage.ligo"
#include "./error_codes.ligo"

function get_asset_ledger_or_fail(const asset_id : asset_id; const storage : storage) : asset_ledger
    is (case storage.assets[asset_id] of 
        | Some(asset_ledger) -> asset_ledger
        | None -> (failwith(asset_id_not_found) : asset_ledger)
    end)

function address_has_sufficient_asset_balance(const asset_id : asset_id; const asset_owner : asset_owner; const transaction_amount : nat; const storage : storage) : bool
    is begin
        const asset_ledger : asset_ledger = get_asset_ledger_or_fail(asset_id, storage);
        const asset_balance : option(asset_balance) = asset_ledger.balances[asset_owner];
    end with (case asset_balance of
            | Some(asset_balance) -> asset_balance >= transaction_amount
            | None -> False
        end)

function fail_unless_address_has_sufficient_asset_balance(const asset_id : asset_id; const asset_owner : asset_owner; const transaction_amount : nat; const storage : storage) : unit
    is (case address_has_sufficient_asset_balance(asset_id, asset_owner, transaction_amount, storage) of 
        | True -> Unit
        | False -> failwith(insufficient_balance)
    end)

(* 
    Transfer is only possible if you have sufficient asset balance.
    In case of non fungible assets, having a positive balance counts as asset ownership.
    
    Dev note: please beware that for non fungible assets, a case where the asset_ledger 
    has multiple asset_owners in the asset_ledger, can't happen.
*)
function transfer (const transfer_param : transfer_param; var storage : storage) : (list(operation) * storage)
    is block {
        function transaction_iterator (const transaction : transaction) : unit 
            is block {
                fail_unless_address_has_sufficient_asset_balance(transaction.token_id, transfer_param.from_, transaction.amount, storage);
                
                var asset_ledger : asset_ledger := get_force(transaction.token_id, storage.assets);
                asset_ledger.balances[transfer_param.from_] := abs(get_force(transfer_param.from_, asset_ledger.balances) - transaction.amount);
                asset_ledger.balances[transfer_param.to_] := case asset_ledger.balances[transfer_param.to_] of 
                    | Some(asset_balance) -> asset_balance + transaction.amount
                    | None -> transaction.amount
                end;

                storage.assets[transaction.token_id] := asset_ledger;
            } with Unit;

        list_iter(transaction_iterator, transfer_param.batch);
    } with ((nil : list(operation)), storage)
