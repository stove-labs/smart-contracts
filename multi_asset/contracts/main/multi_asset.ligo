#include "./../partials/storage.ligo"
#include "./../partials/action.ligo"
#include "./../partials/transfer.ligo"
#include "./../partials/balance_of.ligo"

function main (const action : action; const storage : storage) : (list(operation) * storage)
    is (case action of
    | Transfer(transfer_param) -> transfer(transfer_param, storage)
    | Balance_of(balance_of_param) -> balance_of(balance_of_param, storage)
    end)


