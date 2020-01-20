#include "./transfer_param.ligo"

type on_multi_tokens_received_param is record
    operator : address;
    from_ : option(address);
    batch : list(tx);
    // data : bytes
end;

type multi_token_receiver_action is

| On_multi_tokens_received of on_multi_tokens_received_param
(* This entrypoint placeholder exists only to because if there's just one entrypoint (above), it won't compile as 'multi-entrypoint' which is a problem for our tests *)
| Placeholder of unit

const on_multi_tokens_received_param_entrypoint : string = "%on_multi_tokens_received_param"