// @TODO: extract initial storage to a separate file
const multi_asset = artifacts.require('multi_asset');
const originatedBy = require('../faucet.json').pkh;
const unit = undefined;
const asset_id = 123;
const asset_balance = 10;
const assets = {
    [asset_id]: {
        fungible: false,
        balances: {
            [`${originatedBy}`]: asset_balance
        }
    }
};
const initial_storage = {
    u: unit,
    assets
}

module.exports = (deployer, network, accounts) => {
    deployer.deploy(multi_asset, initial_storage);  
};

module.exports.asset_id = asset_id;
module.exports.originatedBy = originatedBy;
module.exports.initial_storage = initial_storage;