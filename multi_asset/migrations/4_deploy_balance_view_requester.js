const example_balance_view_requester = artifacts.require('example_balance_view_requester');
const { unit } = require('./../helpers/constants');
const configureTaquitoInstance = require('./../helpers/configureTaquitoInstance');

const initial_storage = [];
module.exports = async (deployer, network, accounts) => {
    configureTaquitoInstance(this.tezos);
    await deployer.deploy(example_balance_view_requester, initial_storage);
};