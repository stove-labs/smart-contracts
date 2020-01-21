#include "./../storage.ligo"
#include "./../error_codes.ligo"
(*
    Returns an asset_ledger or fails with the predefined error code
*)
function get_asset_ledger_or_fail(const asset_id : asset_id; const storage : storage) : asset_ledger
    is (case storage.assets[asset_id] of 
        | Some(asset_ledger) -> asset_ledger
        | None -> (failwith(asset_id_not_found) : asset_ledger)
    end)