//TODO: extract initial storage to a separate file
const multi_asset = artifacts.require('multi_asset');
const _ = require('lodash');
const eztz = require('eztz.js').eztz;
const { unit } = require('./../helpers/constants');
const { alice, bob } = require('./../scripts/sandbox/accounts');
const generateAddress = require('./../helpers/generateAddress');
const configureTaquitoInstance = require('./../helpers/configureTaquitoInstance');

const asset_id = 123;
const asset_balance = 10;

const assets = {
    [asset_id]: {
        fungible: false,
        balances: {
            [`${alice.pkh}`]: asset_balance,
            [`${bob.pkh}`]: asset_balance
        }
    }
};

const initial_storage = {
    u: unit,
    assets
}

module.exports = async (deployer, network, accounts) => {
    configureTaquitoInstance(this.tezos);
    await deployer.deploy(multi_asset, initial_storage, {
        gasLimit: 90000
    });
};

module.exports.generateAddress = generateAddress;
module.exports.asset_id = asset_id;
module.exports.initial_storage = initial_storage;