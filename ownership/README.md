# SafeOwned, SafeOwnedMulti

These contract can be used as alternatives to the standard `owned` contract. The `owned` contract implements a very basic pattern which allow you to assign an owner to a contract and then block callers from accessing certain functions by requiring that the caller is the owner before executing the rest of the code.

### SafeOwned

The `SafeOwned` contract has a two-step transfer of ownership function:

- The first step requires that the current owner calls the `offerOwnership` function, and thereby offering ownership to the new account.
- The second step requires that the new owner claims that ownership by calling the `claimOwnership` function.

This eliminates the risk of replacing the current owner with the wrong account address due to typos or programming errors, and ensures that the new owner account is actually able to transact with the contract.

When a new `SafeOwned` contract is uploaded, the owner address is initialized to the address of the account that uploads the contract (using `msg.sender`), meaning it will be set to a proper account from the start.

### SafeOwnedMulti

The `SafeOwnedMulti` contract adds even more safety by having two owner accounts rather then one, making it possible to continue operating the contract even if one of the owner accounts should stop working. This is very useul if the holder of one of the accounts loses their private key.

The transfer of ownership function requires that new owners claim ownership before the ownership is actually transferred, just like it does in `SafeOwned`, except the owners can only transfer ownership from the other account and not their own, and they may not transfer ownership of the other owner account to themselves. This eliminates the chance of ending up with the same account at both owners, or for an owner to accidentally replace themselves.

When deployed, the contract will initialize owner 0 to `msg.owner`, so it is important for that owner to add an account to owner 1 as well.

Note that despite having two owner accounts, this contract is not meant to work as some kind of multi-user access control system; it should only be replacing contracts where one owner would be appropriate. A normal use-case would be a contract with a single owner that uses one main account and one backup account.
