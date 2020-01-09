#include "./action.ligo"
#include "./storage.ligo"
#include "./error_codes.ligo"
#include "./helpers/option.ligo"
(* @TODO: preprocess/remove if not necessary *)
#include "./multi_token_receiver.ligo"

(*
    Returns an asset_ledger or fails with the predefined error code
*)
function get_asset_ledger_or_fail(const asset_id : asset_id; const storage : storage) : asset_ledger
    is (case storage.assets[asset_id] of 
        | Some(asset_ledger) -> asset_ledger
        | None -> (failwith(asset_id_not_found) : asset_ledger)
    end)

(*
    Returns True only if the given asset_owner has a balance of asset_id that is greater or equal 
    to the transaction_amount required to complete the given transaction_amount
*)
function address_has_sufficient_asset_balance(const asset_id : asset_id; const asset_owner : asset_owner; const transaction_amount : nat; const storage : storage) : bool
    is begin
        const asset_ledger : asset_ledger = get_asset_ledger_or_fail(asset_id, storage);
        const asset_balance : option(asset_balance) = asset_ledger.balances[asset_owner];
    end with (case asset_balance of
            | Some(asset_balance) -> asset_balance >= transaction_amount
            | None -> False
        end)

(* 
    Throws a predefined error code in case the given asset_owner doesnt have sufficient balance to transfer the given asset_id 
*)
function fail_unless_address_has_sufficient_asset_balance(const asset_id : asset_id; const asset_owner : asset_owner; const transaction_amount : nat; const storage : storage) : unit
    is (case address_has_sufficient_asset_balance(asset_id, asset_owner, transaction_amount, storage) of 
        | True -> Unit
        | False -> failwith(insufficient_balance)
    end)

(* 
    Fails with a predefined error code unless the given from_ address has permission to transfer/handle the asset
    Note: In the current implementation, you can only transfer/handle your own assets 
*)
function fail_unless_address_has_permission(const from_ : address) : unit
    is if from_ =/= sender then failwith(transfer_permission_denied) else Unit

(* 
    Transfer is only possible if you have sufficient asset balance & have permission to transfer/handle the asset.
    In case of non fungible assets, having a positive balance counts as asset ownership from the client perspective.
*)
function transfer (const transfer_param : transfer_param; var storage : storage) : (list(operation) * storage)
    is block {

        var operations : list(operation) := list end;

        function transaction_iterator (const transaction : transaction) : unit 
            is block {
                fail_unless_address_has_sufficient_asset_balance(transaction.token_id, transfer_param.from_, transaction.amount, storage);
                fail_unless_address_has_permission(transfer_param.from_);

                (* 
                    Update balances in the asset_ledger for `from_` and `to_` addresses 
                *)
                var asset_ledger : asset_ledger := get_force(transaction.token_id, storage.assets);
                const current_from_balance : nat = get_force(transfer_param.from_, asset_ledger.balances);
                (* abs() is used here because subtraction result is always int, 
                however it will always be > 0 because we're subtracting two nats *)
                asset_ledger.balances[transfer_param.from_] := abs(current_from_balance - transaction.amount);

                const current_to_balance : nat = get_with_default_nat(asset_ledger.balances[transfer_param.to_], 0n);
                asset_ledger.balances[transfer_param.to_] := current_to_balance + transaction.amount;

                (* 
                    Update asset_ledger in the storage
                *)
                storage.assets[transaction.token_id] := asset_ledger;
            } with Unit;

        (* Iterate trough and apply all the proposed transactions if they meet the contract requirements *)
        list_iter(transaction_iterator, transfer_param.batch);

        (* @TODO: add accounts whitelist, but make sure both whitelisting and token receiver features are optional*)
        (* Emit a token receiver operation if the to_ address is an originated account *)
        (* @TODO: preprocess/remove if not necessary *)
        case (transfer_param.to_ = self_address) of
            (* If the to_ address is the current contract, don't emit a token receiver operation *)
            | True -> skip
            | False -> begin
                const token_receiver_contract_entrypoint : contract(on_multi_tokens_received_param) = get_entrypoint(on_multi_tokens_received_param_entrypoint, transfer_param.to_);
                const token_receiver_operation_param : on_multi_tokens_received_param = record
                    operator = sender;
                    from_ = Some(transfer_param.from_);
                    batch = transfer_param.batch;
                    // data = transfer_param.data
                end;

                const token_receiver_operation : operation = transaction(
                    token_receiver_operation_param,
                    0mutez,
                    token_receiver_contract_entrypoint
                );

                operations := token_receiver_operation # operations;
                skip
            end
        end

    } with (operations, storage)
