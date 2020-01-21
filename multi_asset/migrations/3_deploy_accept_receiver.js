const example_accept_multi_token_receiver = artifacts.require('example_accept_multi_token_receiver');
const { unit } = require('./../helpers/constants');
const configureTaquitoInstance = require('./../helpers/configureTaquitoInstance');

const initial_storage = 0;
module.exports = async (deployer, network, accounts) => {
    configureTaquitoInstance(this.tezos);
    await deployer.deploy(example_accept_multi_token_receiver, initial_storage);
};