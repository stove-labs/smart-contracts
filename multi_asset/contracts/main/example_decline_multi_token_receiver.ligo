#include "./../partials/multi_token_receiver.ligo"
type storage is unit;

function on_multi_tokens_received(const on_multi_tokens_received_param : on_multi_tokens_received_param; const storage : storage) : (list(operation) * storage)
    is block {
        failwith("0")
    } with ((nil : list(operation)), Unit) 

(*
    This contract showcases an example implementation of the `On_multi_tokens_received` interface, and it
    declines the multi token transfer by throwing a code failure.
*)
function main (const action : multi_token_receiver_action; const storage : storage) : (list(operation) * storage)
    is (case action of
    | On_multi_tokens_received(on_multi_tokens_received_param) -> on_multi_tokens_received(on_multi_tokens_received_param, storage)
    | Placeholder(u) -> ((nil : list(operation)), storage)
    end)