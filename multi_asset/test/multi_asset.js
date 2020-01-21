const multi_asset = artifacts.require('multi_asset');
const example_decline_multi_token_receiver = artifacts.require('example_decline_multi_token_receiver');
const example_accept_multi_token_receiver = artifacts.require('example_accept_multi_token_receiver');
const example_balance_view_requester = artifacts.require('example_balance_view_requester');

const { initial_storage, asset_id, asset_balance } = require('../migrations/1_deploy_multi_asset.js');
const { alice, bob } = require('./../scripts/sandbox/accounts');
const findMichelsonScriptRejectedError = require('./../helpers/findMichelsonScriptRejectedError');
const { contractErrors, rpcErrors } = require('./../helpers/constants');

/**
 * Replace those addresses in case you want to run the tests on a different network than the sandbox
 */
const firstAddress = alice.pkh;
const secondAddress = bob.pkh;

contract('multi_asset', accounts => {
    let storage;
    let multi_asset_instance;
    let example_decline_multi_token_receiver_instance;
    let example_accept_multi_token_receiver_instance;

    beforeEach(async () => {
        multi_asset_instance = await multi_asset.deployed();
        example_decline_multi_token_receiver_instance = await example_decline_multi_token_receiver.deployed();
        example_accept_multi_token_receiver_instance = await example_accept_multi_token_receiver.deployed();
        example_balance_view_requester_instance = await example_balance_view_requester.deployed();

        console.log('multi_asset:', multi_asset_instance.address);
        console.log('example_decline_multi_token_receiver:', example_decline_multi_token_receiver_instance.address);
        console.log('example_accept_multi_token_receiver:', example_accept_multi_token_receiver_instance.address);
        console.log('example_balance_view_requester:', example_balance_view_requester_instance.address);
        storage = await multi_asset_instance.storage();
    });

    const expectedBalance = initial_storage.assets[asset_id].balances[firstAddress];
    it(`should store a balance of '${expectedBalance}' of asset_id '${asset_id}' for the owner '${firstAddress}'`, async () => {
        const realBalance = await storage.assets[asset_id].balances.get(firstAddress);
        assert.equal(realBalance, expectedBalance);
    });

    it('should update balances respectively when you transfer an asset', async () => {
        // If you try to get data from big map using a non existent key, you'll get a 404 - which is expected
        const oldBalanceFrom = await storage.assets[asset_id].balances.get(firstAddress);
        const oldBalanceTo = await storage.assets[asset_id].balances.get(secondAddress);
        await multi_asset_instance.transfer(
            // transactions
            [{
                token_id: asset_id,
                amount: 1
            }],
            // from
            firstAddress,
            // to
            secondAddress
        );
        const newBalanceFrom = await storage.assets[asset_id].balances.get(firstAddress);
        const newBalanceTo = await storage.assets[asset_id].balances.get(secondAddress);

        assert(newBalanceFrom.isEqualTo(oldBalanceFrom.minus(1)));
        assert(newBalanceTo.isEqualTo(oldBalanceTo.plus(1)));
    });

    it('should fail when you attempt to transfer a non existing asset', async () => {
        var rpcError = null;
        try {
            await multi_asset_instance.transfer(
                // transactions
                [{
                    token_id: 1234,
                    amount: 1
                }],
                // from
                firstAddress,
                // to
                secondAddress,
                {
                    gasLimit: 90000
                }
            )
        } catch (err) {
            rpcError = err;
        }
        const failedWith = findMichelsonScriptRejectedError(rpcError);
        assert.equal(failedWith.string, contractErrors.assetIdNotFound);
    });

    //TODO: add a test for the case when the receiver does not implement the receiver interface endpoint at all
    it('should fail when the receiver KT1 address rejects the transfer via the receiver interface', async () => {
        const oldBalanceFrom = await storage.assets[asset_id].balances.get(firstAddress);
        const transferOperation = await multi_asset_instance.transfer(
            // transactions
            [{
                token_id: asset_id,
                amount: 1
            }],
            // from
            firstAddress,
            // to
            example_decline_multi_token_receiver_instance.address,
            {
                gasLimit: 700000,
                fee: 700000
            }
        )
        const newBalanceFrom = await storage.assets[asset_id].balances.get(firstAddress);
        /**
         * Custom way to find an internal operation error, until Taquito error handling for both top-level and internal operation errors is the same
         */
        const errorId = transferOperation.receipt.results[0].metadata.internal_operation_results[0].result.errors[0].id;
        // expect no balance change on the multi_asset contract
        assert(newBalanceFrom.isEqualTo(oldBalanceFrom));
        //TODO: should this really be a runtime error, rather than `script rejected` error?
        assert.equal(errorId, rpcErrors.michelson.runtimeError);
    });

    it('should execute a transfer successfully when the receiving KT1 address implements the receiver interface without throwing a runtime error (failwith)', async () => {
        const transferOperation = await multi_asset_instance.transfer(
            // transactions
            [{
                token_id: asset_id,
                amount: 1
            }],
            // from
            firstAddress,
            // to
            example_accept_multi_token_receiver_instance.address,
            {
                gasLimit: 700000,
                fee: 700000
            }
        )
        const newBalanceTo = await storage.assets[asset_id].balances.get(example_accept_multi_token_receiver_instance.address);
        const receiverCounter = await example_accept_multi_token_receiver_instance.storage();
        assert.equal(newBalanceTo, 1);
        assert.equal(receiverCounter, 1);
    });

    it('should respond with the requested balance information to the provided balance_view contract when the balance_of endpoint is called', async () => {
        const requestBalanceOperation = await example_balance_view_requester_instance.request_balance(
            multi_asset_instance.address,
            firstAddress,
            asset_id
        );

        const balanceFirstAddress = await storage.assets[asset_id].balances.get(firstAddress);
        console.log('balanceFirstAddress', balanceFirstAddress);
        // Take the first element from the storage list, and access the second touple value
        const requesterStorage = await example_balance_view_requester_instance.storage();
        const requesterBalance = requesterStorage[0]["2"];
        //TODO: why is balanceFirstAddress a bignum unlike requesterBalance?
        assert(balanceFirstAddress.isEqualTo(requesterBalance));
    });
});