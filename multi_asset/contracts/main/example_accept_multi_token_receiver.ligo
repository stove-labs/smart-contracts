#include "./../partials/multi_token_receiver.ligo"
type storage is on_multi_tokens_received_param;
(*
    This contract showcases an example implementation of the `On_multi_tokens_received` interface, and it stores
    the received token information in its storage without any further logic.
*)
function main (const action : multi_token_receiver_action; const storage : storage) : (list(operation) * storage)
    is (case action of
        | On_multi_tokens_received(transfer_param) -> ((nil : list(operation)), transfer_param)
        | Placeholder(u) -> ((nil : list(operation)), storage)
    end)