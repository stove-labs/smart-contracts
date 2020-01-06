type asset_id is nat;
type asset_owner is address;
type asset_balance is nat;
type assets_balances is big_map(asset_owner, asset_balance);

type asset_ledger is record
    fungible: bool;
    balances: assets_balances;
end;

type storage is record
    assets: map(asset_id, asset_ledger);
    (* placeholder to overcome single-field record migration bug*)
    u: unit;
end;