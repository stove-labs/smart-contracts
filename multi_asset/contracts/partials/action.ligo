#include "./transfer_param.ligo"

type balance_request is record
    owner : asset_owner;
    token_id : asset_id;
end;

type balance_view_param is list((balance_request * asset_balance));

type balance_view is contract(balance_view_param);

type balance_of_param is record
    balance_request : balance_request;
    balance_view : balance_view;
end;

(* Only for temporary testing purposes *)
type mint_param is record
    addr : address;
    token_id : asset_id;
    amount : asset_balance
end

// type modify_operator_param is address;

// type is_operator_request is record
//     owner : asset_owner;
//     operator : address;
// end;

// type is_operator_view_param is (is_operator_request * bool);

// type is_operator_view is contract(is_operator_view_param);

// type is_operator_param is record
//     is_operator_request : is_operator_request;
//     is_operator_view : is_operator_view;
// end;

type action is

| Transfer of transfer_param

| Balance_of of balance_of_param

(* Only for temporary testing purposes *)
| Mint of mint_param

// | Add_operator of modify_operator_param

// | Remove_operator of modify_operator_param

// | Is_operator of is_operator_param