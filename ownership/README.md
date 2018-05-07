# SafeOwned

The `SafeOwned` contract has a two-step transfer of ownership function:

- The first step requires that the current owner calls the `offerOwnership` function, and thereby offering ownership to the new account.
- The second step requires that the new owner claims that ownership by calling the `claimOwnership` function.

This eliminates the risk of replacing the current owner with the wrong account address due to typos or programming errors, and ensures that the new owner account is actually able to transact with the contract.

When a new `SafeOwned` contract is uploaded, the owner address is initialized to the address of the account that uploads the contract (using `msg.sender`), meaning it will be set to a proper account from the start.

Tests can be run from remix - tests that should succeed should execute normally, the ones with failed assertions should not.