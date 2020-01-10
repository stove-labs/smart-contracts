
type tx is record
    token_id : nat;
    amount : nat;
end;

type transfer_param is record
    from_ : address;
    to_ : address;
    batch : list(tx);
    // data : bytes;
end;