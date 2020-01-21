const example_decline_multi_token_receiver = artifacts.require('example_decline_multi_token_receiver');
const { unit } = require('./../helpers/constants');
const configureTaquitoInstance = require('./../helpers/configureTaquitoInstance');

module.exports = async (deployer, network, accounts) => {
    configureTaquitoInstance(this.tezos);
    await deployer.deploy(example_decline_multi_token_receiver, unit);
};