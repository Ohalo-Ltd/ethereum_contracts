pragma solidity ^0.4.22;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {ISafeOwned, SafeOwned} from "./SafeOwned.sol";

// A proxy used for calling ISafeOwned contracts.
contract SafeOwnedCallerProxy {

    function offerOwnership(ISafeOwned so, address newOwner) public {
        so.offerOwnership(newOwner);
    }

    function claimOwnership(ISafeOwned so) public {
        so.claimOwnership();
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
