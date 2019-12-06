# [Tezos] Satoshi's Treasure Hunt 


## Payout contract

### Architecture overview

Thoughts:
- Hunt tokens ownership should stay in the hands of the user, e.g. it should not be transfered to the Payout contract right away.
- The contract should know that an NFT was claimed, even when the ownership stays with the user, in order to prevent a payout-lockdown by users who decide not to transfer their tokens to the Payout contract after solving the clues.
- The Payout contract does not have to be a standalone contract, it can be an extension of a MAC-like contract
- Payout can be based on the Approval mechanics of MAC, this would mean that when a user claims an NFT, it'd be transfered to an address controlled by the user. Subsequentially, the user would have to set the Payout contract as an operator, to enable a payout to be made later on. This could be done in one operation with a modified MAC-like contract. Setting the operator and claiming the token at once, prevents a payout lockdown by potentionally malicious users - as long as the `Remove_operator` operation is not possible on the MAC-like contract. You're still free to trade the token ownership to someone else




Payout:
- get `Balance_of` for the sender/source (?), if the sender/source(?) is the owner of the specified `token_id`, (???) _check if the payout balance has been reached_ (???), payout the respective amount for that `token_id` based on it's weight.