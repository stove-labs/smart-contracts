const multi_asset = artifacts.require('multi_asset');
const example_decline_multi_token_receiver = artifacts.require('example_decline_multi_token_receiver');
const { initial_storage, asset_id, asset_balance } = require('../migrations/1_deploy_multi_asset.js');
const { alice, bob } = require('./../scripts/sandbox/accounts');
const findMichelsonScriptRejectedError = require('./../helpers/findMichelsonScriptRejectedError');
const { contractErrors } = require('./../helpers/constants');

const firstAddress = alice.pkh;
const secondAddress = bob.pkh;

contract('multi_asset', accounts => {
    let storage;
    let multi_asset_instance;
    let example_decline_multi_token_receiver_instance;
    
    beforeEach(async () => {
        multi_asset_instance = await multi_asset.deployed();
        example_decline_multi_token_receiver_instance = await example_decline_multi_token_receiver.deployed();
        console.log('multi_asset:', multi_asset_instance.address);
        console.log('example_decline_multi_token_receiver:', example_decline_multi_token_receiver_instance.address);
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

    // it('should fail when the receiver KT1 address rejects the transfer via the receiver interface', async () => {
    //     var rpcError = null;
    //     try {
    //         await multi_asset_instance.transfer(
    //             // transactions
    //             [{
    //                 token_id: asset_id,
    //                 amount: 1
    //             }],
    //             // from
    //             firstAddress,
    //             // to
    //             example_decline_multi_token_receiver_instance.address,
    //             {
    //                 gasLimit: 700000,
    //                 fee: 700000
    //             }
    //         )
    //     } catch (err) {
    //         rpcError = err;
    //     }
    //     console.log('rpcError', rpcError);
    //     const failedWith = findMichelsonScriptRejectedError(rpcError);
    //     console.log('failedWith', failedWith);
    //     assert.equal(failedWith.string, contractErrors.assetIdNotFound);
    // });
});