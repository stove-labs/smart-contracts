#include "./transfer_param.ligo"

type on_multi_tokens_received_param is record
    operator : address;
    from_ : option(address);
    batch : list(transaction);
    // data : bytes
end;

type multi_token_receiver_action is

| On_multi_tokens_received of on_multi_tokens_received_param

const on_multi_tokens_received_param_entrypoint : string = "%on_multi_tokens_received_param"