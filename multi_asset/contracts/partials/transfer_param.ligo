#include "./storage.ligo"
type tx is record
    token_id : asset_id;
    amount : asset_balance;
end;

type transfer_param is record
    from_ : asset_owner;
    to_ : asset_owner;
    batch : list(tx);
    // data : bytes;
end;