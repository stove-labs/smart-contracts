const multi_asset = artifacts.require('multi_asset');
const { initial_storage, asset_id, originatedBy } = require('../migrations/1_deploy_multi_asset.js');
const secondAddress = "tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx";

contract('multi_asset', accounts => {
    let storage;
    let multi_asset_instance;
    beforeEach(async () => {
        multi_asset_instance = await multi_asset.deployed();

        console.log('Contract address:', multi_asset_instance.address);
        storage = await multi_asset_instance.storage();
    });

    const expectedBalance = initial_storage.assets[asset_id].balances[originatedBy];
    it(`should store a balance of '${expectedBalance}' of asset_id '${asset_id}' for the owner '${originatedBy}'`, async () => {
        const realBalance = await storage.assets[asset_id].balances.get(originatedBy);
        assert.equal(realBalance, expectedBalance);
    });

    it('should update balances respectively when you transfer an asset', async () => {
        const oldBalanceFrom = await storage.assets[asset_id].balances.get(originatedBy);
        // If you try to get data from big map using a non existent key, you'll get a 404 - which is expected
        // const oldBalanceTo = await storage.assets[asset_id].balances.get(secondAddress);
        await multi_asset_instance.transfer(
            // transactions
            [{
                token_id: asset_id,
                amount: 1
            }],
            // from
            originatedBy,
            // to
            secondAddress
        );
        const newBalanceFrom = await storage.assets[asset_id].balances.get(originatedBy);
        const newBalanceTo = await storage.assets[asset_id].balances.get(secondAddress);

        assert(newBalanceFrom.isEqualTo(oldBalanceFrom.minus(1)));
        assert(newBalanceTo.isEqualTo(1));
    });

    it('should fail when you attempt to transfer a non existing asset', async () => {
        try {
            await multi_asset_instance.transfer(
                // transactions
                [{
                    token_id: "1234",
                    amount: 1
                }],
                // from
                originatedBy,
                // to
                secondAddress,
                {
                    gasLimit: 10600 * 5
                }
            )
        } catch (err) {
            // So far the error is {} without the specific error code from the contract
            console.log('expected error:', err);
            expect(err).to.be.an('Error');
        }
    });
});