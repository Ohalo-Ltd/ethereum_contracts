pragma solidity ^0.4.22;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

// Interface for the single account safe owner management contract.
contract ISafeOwned {

    // Emitted when ownership is offered.
    // 'candidate' is the candidate for ownership.
    event OfferOwnership(address indexed candidate);

    // Emitted when ownership is claimed.
    // 'newOwner' is the address of the new owner.
    event ClaimOwnership(address indexed newOwner);

    // Offer ownership to an account.
    // 'newOwner' is the address to the account of the would-be owner.
    function offerOwnership(address newOwner) public;

    // Claim ownership.
    function claimOwnership() public;

    // Checks if a given account is the owner.
    // 'acc' is the account address to be checked.
    function isOwner(address acc) public view returns(bool);

    // Get the owner address.
    function owner() public view returns(address);

    // Get the candidate address.
    function candidate() public view returns(address);
}


contract SafeOwned is ISafeOwned {

    address private _owner;
    address private _candidate;

    constructor() public {
        _owner = msg.sender;
    }

    function offerOwnership(address newOwner) public {
        require(msg.sender == _owner);

        _candidate = newOwner;
        emit OfferOwnership(newOwner);
    }

    function claimOwnership() public {
        require(msg.sender == _candidate);

        _owner = _candidate;
        _candidate = 0;
        emit ClaimOwnership(msg.sender);
    }

    function isOwner(address acc) public view returns (bool) {
        return acc == _owner;
    }

    function owner() public view returns(address) {
        return _owner;
    }

    function candidate() public view returns(address) {
        return _candidate;
    }

}
