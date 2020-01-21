#include "./action.ligo"
#include "./helpers/get_asset_ledger_or_fail.ligo"
#include "./helpers/option.ligo"
#include "./helpers/default_balance.ligo"

function balance_of (const balance_of_param : balance_of_param; const storage : storage) : (list(operation) * storage)
    is block {

        function balance_request_iterator (const balance_request : balance_request) : balance_view_param_item
            is block {
                const asset_ledger : asset_ledger = get_asset_ledger_or_fail(balance_request.token_id, storage);
                const asset_balance : asset_balance = get_with_default_nat(asset_ledger.balances[balance_request.owner], default_balance);
            } with (balance_request, asset_balance);

        const balance_view_param : balance_view_param = list_map(balance_request_iterator, balance_of_param.balance_request);

        const balance_of_response_operation : operation = transaction(
            balance_view_param,
            0mutez,
            balance_of_param.balance_view
        );
        
        const operations : list(operation) = list
            balance_of_response_operation
        end;

        skip;
    } with (operations, storage)
