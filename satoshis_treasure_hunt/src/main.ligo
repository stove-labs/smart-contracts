#include "./../../multi_asset/src/storage.ligo"
#include "./action.ligo"
#include "./error_codes.ligo"

function decline_operations_with_positive_amount (const a : unit) : unit 
    is begin
        if amount =/= 0mutez then failwith(no_incoming_tez_allowed) else skip
    end with Unit

function main (const action : action; const storage : storage) : (list(operation) * storage)
    is begin
        decline_operations_with_positive_amount(Unit);
    end with ((nil : list(operation)), storage)