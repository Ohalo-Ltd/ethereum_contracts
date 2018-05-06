pragma solidity ^0.4.22;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {ISafeOwned, SafeOwned} from "./SafeOwned.sol";
import {ISafeOwnedMulti, SafeOwnedMulti} from "./SafeOwnedMulti.sol";

// A proxy used for calling ISafeOwned contracts.
contract SafeOwnedCallerProxy {

    function offerOwnership(ISafeOwned so, address newOwner) public {
        so.offerOwnership(newOwner);
    }

    function claimOwnership(ISafeOwned so) public {
        so.claimOwnership();
    }

}


// A proxy used for calling ISafeOwnedMulti contracts.
contract SafeOwnedMultiCallerProxy {

    function offerOwnership(ISafeOwnedMulti so, address newOwner, uint index) public {
        so.offerOwnership(newOwner, index);
    }

    function claimOwnership(ISafeOwnedMulti so, uint index) public {
        so.claimOwnership(index);
    }

}


// Tests for the SafeOwned contract.
contract SafeOwnedTests {

    // Ensures that the owner is initialized to the caller address,
    // and that the candidate is initialized to 0.
    function testConstructorInitializiation() public {
        ISafeOwned so = new SafeOwned();

        assert(so.owner() == address(this));
        assert(so.candidate() == 0);
    }

    // Ensures that 'isOwner' returns 'true' when the caller is the owner.
    function testIsOwner_CallerIsOwner() public {
        ISafeOwned so = new SafeOwned();

        assert(so.isOwner(address(this)));
    }

    // Ensures that the 'isOwner' function returns 'false' in one case where
    // the caller is not the owner.
    function testIsOwner_CallerIsNotOwner() public {
        ISafeOwned so = new SafeOwned();

        assert(!so.isOwner(0x1));
    }

    // Ensures that the 'offerOwnership' function sets the candidate correctly
    // when the caller is the owner, and that there are no side-effects to
    // the current owner.
    function testOfferOwnership_CallerIsOwner() public {
        ISafeOwned so = new SafeOwned();

        so.offerOwnership(0x1);

        assert(so.owner() == address(this));
        assert(so.candidate() == 0x1);
    }

    // Ensures that the 'offerOwnership' function fails when the caller
    // is not the owner.
    function testOfferOwnership_CallerIsNotOwner_Fails() public {
        ISafeOwned so = new SafeOwned();

        SafeOwnedCallerProxy proxy = new SafeOwnedCallerProxy();
        proxy.offerOwnership(so, 0x1);
    }

    // Ensures that the 'claimOwnership' function makes the caller into the
    // new owner if they are the current candidate. Also ensures that the candidate
    // is set to 0.
    function testClaimOwnership_CallerIsCandidate() public {
        ISafeOwned so = new SafeOwned();
        SafeOwnedCallerProxy proxy = new SafeOwnedCallerProxy();

        so.offerOwnership(address(proxy));
        proxy.claimOwnership(so);

        assert(so.owner() == address(proxy));
        assert(so.candidate() == 0);
    }

    // Ensures that the 'claimOwnership' function fails if the caller is not
    // the current candidate.
    function testClaimOwnership_CallerIsNotCandidate_Fails() public {
        ISafeOwned so = new SafeOwned();

        so.offerOwnership(0x1);
        so.claimOwnership();
    }

}


// Tests for the SafeOwnedMulti contract.
contract SafeOwnedMultiTests {

    // Ensures that the contract is initialized correctly.
    function testConstructorInitializiation() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();

        assert(som.owner(0) == address(this));
        assert(som.owner(1) == 0);
        assert(som.candidate(0) == 0);
        assert(som.candidate(1) == 0);
    }

    // Ensures that 'offerOwnership' works when called by owner 0 with ownership of 1 as target,
    // and that there are no side effects to unrelated owner and candidate fields.
    function testOfferOwnership1_CallerIsOwner0() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();

        som.offerOwnership(0x1, 1);

        assert(som.owner(0) == address(this));
        assert(som.owner(1) == 0);
        assert(som.candidate(0) == 0);
        assert(som.candidate(1) == 0x1);
    }

    // Ensures that 'offerOwnership' works when called by owner 0 with ownership of 1 as target,
    // and that there are no side effects to unrelated owner and candidate fields.
    function testOfferOwnership0_CallerIsOwner1() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();
        SafeOwnedMultiCallerProxy proxy = new SafeOwnedMultiCallerProxy();

        som.offerOwnership(proxy, 1);
        proxy.claimOwnership(som, 1);

        proxy.offerOwnership(0x1, 0);

        assert(som.owner(0) == address(this));
        assert(som.owner(1) == address(proxy));
        assert(som.candidate(0) == 0x1);
        assert(som.candidate(1) == 0);
    }

    // Ensures that 'offerOwnership' reverts when owner 1 tries to offer ownership
    // of 0 to themselves (the "no offering ownership to yourself" rule).
    function testOfferOwnership0_OwnerIsCandidate_Fails() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();
        SafeOwnedMultiCallerProxy proxy = new SafeOwnedMultiCallerProxy();

        som.offerOwnership(address(proxy), 1);
        proxy.claimOwnership(som, 1);

        offerOwnership(som, address(proxy), 0);
    }

    // Ensures that 'offerOwnership' fails when owner 0 tries to offer ownership
    // of 1 to themselves (the "no offering ownership to yourself" rule).
    function testOfferOwnership1_OwnerIsCandidate_Fails() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();

        som.offerOwnership(address(this), 1);
    }

    // Ensures that 'offerOwnership' fails when owner 0 tries to offer the ownership
    // of their own slot (the "can only pass ownership of the other owner account" rule).
    function testOfferOwnership0_CallerIsNotOwner1_Fails() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();

        som.offerOwnership(0x1, 0);
    }

    // Ensures that 'offerOwnership' fails when owner 1 tries to offer the ownership
    // of their own slot (the "can only pass ownership of the other owner account" rule).
    function testOfferOwnership1_CallerIsNotOwner0_Fails() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();
        SafeOwnedMultiCallerProxy proxy = new SafeOwnedMultiCallerProxy();

        som.offerOwnership(address(proxy), 0);
        proxy.claimOwnership(som, 0);

        som.offerOwnership(0x1, 1);
    }

    // Ensures that 'claimOwnership' works when a claim is made for a properly offered owner 0,
    // that the candidate address is set to 0, and that there are no side effects to unrelated fields.
    function testClaimOwnership0_CallerIsCandidate0() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();
        SafeOwnedMultiCallerProxy proxy = new SafeOwnedMultiCallerProxy();

        som.offerOwnership(address(proxy), 0);
        proxy.claimOwnership(som, 0);

        assert(som.owner(0) == address(proxy));
        assert(som.owner(1) == address(this));
        assert(som.candidate(0) == 0);
        assert(som.candidate(1) == 0);
    }

    // Ensures that 'claimOwnership' works when a claim is made for a properly offered owner 1,
    // that the candidate address is set to 0, and that there are no side effects to unrelated fields.
    function testClaimOwnership1_CallerIsCandidate1() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();
        SafeOwnedMultiCallerProxy proxy = new SafeOwnedMultiCallerProxy();

        som.offerOwnership(address(proxy), 1);
        proxy.claimOwnership(som, 1);

        assert(som.owner(0) == address(this));
        assert(som.owner(1) == address(proxy));
        assert(som.candidate(0) == 0);
        assert(som.candidate(1) == 0);
    }

    // Ensures that 'claimOwnership' fails when trying to claim ownership of
    // 0 without it being offered to the calling address.
    function testClaimOwnership0_CallerIsNotCandidate_Fails() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();

        som.claimOwnership(0);
    }

    // Ensures that 'claimOwnership' fails when trying to claim ownership of
    // 1 without it being offered to the calling address.
    function testClaimOwnership1_CallerIsNotCandidate_Fails() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();

        som.claimOwnership(1);
    }

    // Ensures that 'isOwner' works (returns true) when the tested address
    // is owner 0.
    function testIsOwner_CallerIsOwner0() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();

        assert(som.isOwner(address(this)));
    }

    // Ensures that 'isOwner' returns true when the tested address
    // is owner 0.
    function testIsOwner_CallerIsOwner1() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();
        SafeOwnedMultiCallerProxy proxy = new SafeOwnedMultiCallerProxy();

        som.offerOwnership(address(proxy), 1);
        proxy.claimOwnership(som, 1);

        assert(som.isOwner(address(proxy)));
    }

    // Ensures that 'isOwner' works (returns false) when the tested address
    // is not an owner.
    function testIsOwner_CallerIsNotAnOwner() public {
        ISafeOwnedMulti som = new SafeOwnedMulti();
        SafeOwnedMultiCallerProxy proxy = new SafeOwnedMultiCallerProxy();

        assert(!som.isOwner(address(proxy)));
    }

}