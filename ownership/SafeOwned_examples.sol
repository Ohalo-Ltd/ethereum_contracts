pragma solidity ^0.4.22;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {SafeOwned} from "./SafeOwned.sol";

// This is an owned demo-contract that keeps a registry of accounts.
contract UserManagerExample is SafeOwned {

    // The registry is an address -> bytes32 mapping. 'bytes32' is the type
    // of the user name.
    mapping(address => bytes32) public users;

    constructor() {}

    // Only the owner may add new users.
    function addUser(address addr, bytes32 name) public onlyOwner {
        users[addr] = name;
    }

    // Only the owner may remove a user.
    function removeUser(address addr, bytes32 name) public onlyOwner {
        delete users[addr];
    }

    // Anyone can change their name so long as they are a registered user.
    function changeName(bytes32 name) public {
        require(users[msg.sender] != 0); // Caller must be a user.
        require(name != 0); // The name must contain at least one character.
        users[msg.sender] = name;
    }

}
