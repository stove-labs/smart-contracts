const example_decline_multi_token_receiver = artifacts.require('example_decline_multi_token_receiver');
const InMemorySigner = require('@taquito/signer').InMemorySigner;
const { unit } = require('./../helpers/constants');
const { alice, bob } = require('./../scripts/sandbox/accounts');


module.exports = async (deployer, network, accounts) => {
    /**
     * Using a custom signer instead of `faucet.json` until truffle supports
     * importing secret keys directly
     */
    const signer = new InMemorySigner(alice.sk)
    this.tezos.setProvider({signer})

    await deployer.deploy(example_decline_multi_token_receiver, unit);
};