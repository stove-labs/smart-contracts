#include "./transfer_param.ligo"

type balance_request is record
    owner : address;
    token_id : nat;
end;

type balance_view_param is list((balance_request * nat));

type balance_view is contract(balance_view_param);

type balance_of_param is record
    balance_request : balance_request;
    balance_view : balance_view;
end;

type modify_operator_param is address;

type is_operator_request is record
    owner : address;
    operator : address;
end;

type is_operator_view_param is (is_operator_request * bool);

type is_operator_view is contract(is_operator_view_param);

type is_operator_param is record
    is_operator_request : is_operator_request;
    is_operator_view : is_operator_view;
end;

type action is

| Transfer of transfer_param

| Balance_of of balance_of_param

// | Add_operator of modify_operator_param

// | Remove_operator of modify_operator_param

// | Is_operator of is_operator_param