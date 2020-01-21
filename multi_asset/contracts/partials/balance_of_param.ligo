#include "./storage.ligo"

type balance_request is record
    owner : asset_owner;
    token_id : asset_id;
end;

type balance_view_param_item is (balance_request * asset_balance);
type balance_view_param is list(balance_view_param_item);

type balance_view is contract(balance_view_param);

type balance_of_param is record
    //TODO: rename balance_request types into their plural forms
    balance_request : list(balance_request);
    balance_view : balance_view;
end;

const balance_of_entrypoint : string = "%balance_of"