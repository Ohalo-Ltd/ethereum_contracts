pragma solidity ^0.4.22;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

// Interface for the multiple account safe owner management contract.
contract ISafeOwnedMulti {

    // Emitted when ownership is offered.
    // 'candidate' is the candidate for ownership.
    // 'index' is the owner index.
    event OfferOwnership(address indexed to, uint indexed index);

    // Emitted when ownership is offered.
    // 'candidate' is the candidate for ownership.
    // 'index' is the owner index.
    event ClaimOwnership(address indexed newOwner, uint indexed index);

    // Offer ownership to an account.
    // 'newOwner' is the account-address of the would-be new owner.
    // 'index' is the owner index.
    function offerOwnership(address newOwner, uint index) public;

    // Lets a candidate claim ownership.
    // 'index' is the owner index.
    function claimOwnership(uint index) public;

    // Checks if a given account is an owner.
    function isOwner(address acc) public view returns(bool);

    // Get the owner address at 'index'.
    function owner(uint index) public view returns(address);

    // Get the candidate address at index 'index'.
    function candidate(uint index) public view returns(address);
}


contract SafeOwnedMulti is ISafeOwnedMulti {

    address[2] private _owners;
    address[2] private _candidates;

    constructor() public {
        _owners[0] = msg.sender;
    }

    function offerOwnership(address newOwner, uint index) public {
        require(msg.sender != newOwner && msg.sender == _owners[(index + 1) & 1]);

        _candidates[index] = newOwner;
        emit OfferOwnership(newOwner, index);
    }

    function claimOwnership(uint index) public {
        require(msg.sender == _candidates[index]);

        _owners[index] = _candidates[index];
        _candidates[index] = 0;
        emit ClaimOwnership(_msg.sender, index);
    }

    function isOwner(address acc) public view returns (bool) {
        return acc == _owners[0] || acc == _owners[1];
    }

    function owner(uint index) public view returns(address) {
        return _owners[index];
    }

    function candidate(uint index) public view returns(address) {
        return _candidates[index];
    }

}
