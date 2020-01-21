#include "./../partials/multi_token_receiver.ligo"
type storage is nat;

function on_multi_tokens_received(const on_multi_tokens_received_param : on_multi_tokens_received_param; const storage : storage) : (list(operation) * storage)
    is block {
        storage := storage + 1n;
    } with ((nil : list(operation)), storage) 

(*
    This contract showcases an example implementation of the `On_multi_tokens_received` interface, and it stores
    a counter of how many times has the receiver endpoint been invoked.
*)
function main (const action : multi_token_receiver_action; const storage : storage) : (list(operation) * storage)
    is (case action of
        | On_multi_tokens_received(transfer_param) -> on_multi_tokens_received(transfer_param, storage)
        | Placeholder(u) -> ((nil : list(operation)), storage)
    end)