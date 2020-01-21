#include "./../partials/action.ligo"
#include "./../partials/storage.ligo"
type storage is balance_view_param;
type request_balance_param is record
    asset_contract: address;
    token_id: asset_id;
    owner: asset_owner
end;
type action is 
| Request_balance of request_balance_param
| Receive_balance of balance_view_param

const receive_balance_entrypoint : string = "%receive_balance";
const current_contract : address = self_address;

function on_balance_requested(const request_balance_param : request_balance_param; const storage : storage) : (list(operation) * storage)
    is block {
        const asset_contract_balance_of_entrypoint : contract(balance_of_param) = get_entrypoint(balance_of_entrypoint, request_balance_param.asset_contract);
        const balance_of_operation_param : balance_of_param = record
            balance_request = list
                record
                    owner = request_balance_param.owner;
                    token_id = request_balance_param.token_id
                end
            end;
            balance_view = (get_entrypoint(receive_balance_entrypoint, current_contract) : balance_view);
        end;

        const token_receiver_operation : operation = transaction(
            balance_of_operation_param,
            0mutez,
            asset_contract_balance_of_entrypoint
        );
        
        const operations : list(operation) = list
            token_receiver_operation
        end;

        skip
    } with (operations, storage) 

(*
    This contract showcases an example implementation of the `On_multi_tokens_received` interface, and it stores
    a counter of how many times has the receiver endpoint been invoked.
*)
function main (const action : action; const storage : storage) : (list(operation) * storage)
    is (case action of
        | Request_balance(request_balance_param) -> on_balance_requested(request_balance_param, storage)
        | Receive_balance(balance_view_param) -> ((nil : list(operation)), balance_view_param)
    end)