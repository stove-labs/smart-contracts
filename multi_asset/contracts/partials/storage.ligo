(* An asset_id is a nat, but it could be a string as well, there are no bussines logic restrictions at the moment *)
type asset_id is nat;
(* An asset_owner can be an address/account, both originated and implicit *)
type asset_owner is address;
(* An asset_balance is never negative, therefore it's a nat instead of an int *)
type asset_balance is nat;
type assets_balances is big_map(asset_owner, asset_balance);

(* An asset_ledger stores assets_balances, while carrying other metadata for the asset *)
type asset_ledger is record
    (* 
        This property indicates if the given asset is fungible or not,
        because the count of owners in the assets_balances is not a deterministic measure for fungibility.
    *)
    fungible: bool;
    balances: assets_balances;
end;

type storage is record
    (* Map of asset_ids and their respective asset_ledgers *)
    assets: map(asset_id, asset_ledger);
    (* placeholder to overcome single-field record migration bug*)
    u: unit;
end;