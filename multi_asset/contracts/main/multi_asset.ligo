#include "./../partials/storage.ligo"
#include "./../partials/action.ligo"
#include "./../partials/transfer.ligo"
#include "./../partials/balance_of.ligo"

(* Only for temporary testing purposes *)
function mint(const param : mint_param; const storage : storage) : (list(operation) * storage)
    is block {
        var asset_ledger : asset_ledger := get_force(param.token_id, storage.assets);
        asset_ledger.balances[param.addr] := param.amount;
        storage.assets[param.token_id] := asset_ledger;
    } with ((nil : list(operation)), storage);

function main (const action : action; const storage : storage) : (list(operation) * storage)
    is (case action of
    | Transfer(transfer_param) -> transfer(transfer_param, storage)
    | Balance_of(balance_of_param) -> balance_of(balance_of_param, storage)
    (* Only for temporary testing purposes *)
    | Mint(mint_param) -> mint(mint_param, storage)
    end)