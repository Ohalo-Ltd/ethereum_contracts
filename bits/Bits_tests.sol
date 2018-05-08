pragma solidity ^0.4.22;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {Bits} from "./Bits.sol";

contract BitsTest {

    using Bits for uint;

    uint internal constant ZERO = uint(0);
    uint internal constant ONE = uint(1);
    uint internal constant ONES = uint(~0);

    function testBitsBitAnd() public pure returns (bool) {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitAnd(ONES, i*20) == 1);
            assert(ONES.bitAnd(ZERO, i*20) == 0);
            assert(ZERO.bitAnd(ONES, i*20) == 0);
            assert(ZERO.bitAnd(ZERO, i*20) == 0);
        }
        return true;
    }

    function testBitsBitEqual() public pure returns (bool) {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitEqual(ONES, i*20));
            assert(!ONES.bitEqual(ZERO, i*20));
        }
        return true;
    }

    function testBitsBitNotSet() public pure returns (bool) {
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitSet(i*20));
        }
        return true;
    }

    function testBitsBitOr() public pure returns (bool){
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitOr(ONES, i*20) == 1);
            assert(ONES.bitOr(ZERO, i*20) == 1);
            assert(ZERO.bitOr(ONES, i*20) == 1);
            assert(ZERO.bitOr(ZERO, i*20) == 0);
        }
        return true;
    }

    function testBitsBitSet() public pure returns (bool){
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitSet(i*20));
        }
        return true;
    }

    function testBitsBitsWithDifferentIndices() public pure returns (bool){
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bits(i*20, 5) == 31);
        }
        return true;
    }

    function testBitsBitsWithDifferentNumBits() public pure returns (bool){
        for (uint8 i = 1; i < 12; i++) {
            assert(ONES.bits(0, i) == ONES >> (256 - i));
        }
        return true;
    }

    function testBitsBitsGetAll() public pure returns (bool){
        assert(ONES.bits(0, 256) == ONES);
        return true;
    }

    function testBitsBitsGetUpperHalf() public pure returns (bool){
        assert(ONES.bits(128, 128) == ONES >> 128);
        return true;
    }

    function testBitsBitsGetLowerHalf() public pure returns (bool){
        assert(ONES.bits(0, 128) == ONES >> 128);
        return true;
    }

    function testBitsBitsThrowsNumBitsZero() public pure returns (bool){
        ONES.bits(0, 0);
        return true;
    }

    function testBitsBitsThrowsIndexAndLengthOOB() public pure returns (bool){
        ONES.bits(5, 252);
        return true;
    }

    function testBitsBitXor() public pure returns (bool){
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.bitXor(ONES, i*20) == 0);
            assert(ONES.bitXor(ZERO, i*20) == 1);
            assert(ZERO.bitXor(ONES, i*20) == 1);
            assert(ZERO.bitXor(ZERO, i*20) == 0);
        }
        return true;
    }

    function testBitsClearBit() public pure returns (bool){
        for (uint8 i = 0; i < 12; i++) {
            assert(ONES.clearBit(i*20).bit(i*20) == 0);
        }
        return true;
    }

    function testBitsBit() public pure returns (bool){
        for (uint8 i = 0; i < 12; i++) {
            uint v = (ONE << i*20) * (i % 2);
            assert(v.bit(i*20) == i % 2);
        }
        return true;
    }

    function testBitsBitNot() public pure returns (bool){
        for (uint8 i = 0; i < 12; i++) {
            uint v = (ONE << i*20) * (i % 2);
            assert(v.bitNot(i*20) == 1 - i % 2);
        }
        return true;
    }

    function testBitsHighestBitSetAllLowerSet() public pure returns (bool){
        for (uint8 i = 0; i < 12; i += 20) {
            assert((ONES >> i).highestBitSet() == (255 - i));
        }
        return true;
    }

    function testBitsHighestBitSetSingleBit() public pure returns (bool){
        for (uint8 i = 0; i < 12; i += 20) {
            assert((ONE << i).highestBitSet() == i);
        }
        return true;
    }

    function testBitsHighestBitSetThrowsBitFieldIsZero() public pure returns (bool){
        ZERO.highestBitSet();
        return true;
    }

    function testBitsLowestBitSetAllHigherSet() public pure returns (bool){
        for (uint8 i = 0; i < 12; i += 20) {
            assert((ONES << i).lowestBitSet() == i);
        }
        return true;
    }

    function testBitsLowestBitSetSingleBit() public pure returns (bool){
        for (uint8 i = 0; i < 12; i += 20) {
            assert((ONE << i).lowestBitSet() == i);
        }
        return true;
    }

    function testBitsLowestBitSetThrowsBitFieldIsZero() public pure returns (bool){
        ZERO.lowestBitSet();
        return true;
    }

    function testBitsSetBit() public pure returns (bool){
        for (uint8 i = 0; i < 12; i++) {
            assert(ZERO.setBit(i*20) == ONE << i*20);
        }
        return true;
    }

    function testBitsToggleBit() public pure returns (bool){
        for (uint8 i = 0; i < 12; i++) {
            uint v = ZERO.toggleBit(i*20);
            assert(v == ONE << i*20);
            assert(v.toggleBit(i*20) == 0);
        }
        return true;
    }
}