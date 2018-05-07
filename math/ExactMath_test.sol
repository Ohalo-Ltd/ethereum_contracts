pragma solidity ^0.4.22;
pragma experimental "v0.5.0";
pragma experimental "ABIEncoderV2";

import {ExactMath} from "./ExactMath.slb";

contract ExactMathTest {

    using ExactMath for *;

    uint internal constant UINT_ZERO = 0;
    uint internal constant UINT_ONE = 1;
    uint internal constant UINT_TWO = 2;
    uint internal constant UINT_ONES = ~uint(0);

    int internal constant INT_ZERO = 0;
    int internal constant INT_ONE = 1;
    int internal constant INT_TWO = 2;
    int internal constant INT_MINUS_ONE = -1;
    int internal constant INT_MAX = int(2**255 - 1);
    int internal constant INT_MIN = int(2**255);

    uint internal constant TEST_VAL_U1 = 937659378456935;
    uint internal constant TEST_VAL_U2 = 23457722001;
    int internal constant TEST_VAL_S1 = 937659378456935;
    int internal constant TEST_VAL_S2 = 23457722001;
    int internal constant TEST_VAL_S1N = -937659378456935;
    int internal constant TEST_VAL_S2N = -23457722001;

    function testMathExactAddUint() public pure returns (bool) {
        uint x = UINT_ZERO;
        uint y = UINT_ZERO;
        assert(x.exactAdd(y) == UINT_ZERO);
        x = UINT_ZERO;
        y = TEST_VAL_U1;
        assert(x.exactAdd(y) == y);
        x = TEST_VAL_U1;
        y = UINT_ZERO;
        assert(x.exactAdd(y) == x);
        x = TEST_VAL_U1;
        y = TEST_VAL_U2;
        assert(x.exactAdd(y) == y.exactAdd(x));
        assert(x.exactAdd(y) == x + y);
        return true;
    }

    function testMathExactAddUintThrowsOverflow() public pure returns (bool) {
        uint x = UINT_ONES;
        uint y = UINT_ONE;
        x.exactAdd(y);
        return true;
    }

    function testMathExactSubUint() public pure returns (bool) {
        uint x = UINT_ZERO;
        uint y = UINT_ZERO;
        assert(x.exactSub(y) == UINT_ZERO);
        x = TEST_VAL_U1;
        y = UINT_ZERO;
        assert(x.exactSub(y) == x);
        x = TEST_VAL_U1;
        y = TEST_VAL_U2;
        assert(x.exactSub(y) == x - y);
        return true;
    }

    function testMathExactSubUintThrowsUnderflow() public pure returns (bool) {
        uint x = 3;
        uint y = 5;
        x.exactSub(y);
        return true;
    }

    function testMathExactMulUint() public pure returns (bool) {
        uint x = UINT_ZERO;
        uint y = UINT_ZERO;
        assert(x.exactMul(y) == UINT_ZERO);
        x = UINT_ZERO;
        y = TEST_VAL_U1;
        assert(x.exactMul(y) == UINT_ZERO);
        x = TEST_VAL_U1;
        y = UINT_ZERO;
        assert(x.exactMul(y) == UINT_ZERO);
        x = UINT_ONE;
        y = UINT_ONE;
        assert(x.exactMul(y) == UINT_ONE);
        x = UINT_ONE;
        y = TEST_VAL_U1;
        assert(x.exactMul(y) == y);
        x = TEST_VAL_U1;
        y = UINT_ONE;
        assert(x.exactMul(y) == x);
        x = TEST_VAL_U1;
        y = TEST_VAL_U2;
        assert(x.exactMul(y) == y.exactMul(x));
        assert(x.exactMul(y) == x * y);
        return true;
    }

    function testMathExactMulUintThrowsOverflow() public pure returns (bool) {
        uint x = UINT_ONES;
        uint y = UINT_TWO;
        x.exactMul(y);
        return true;
    }

    function testMathExactAddInt() public pure returns (bool) {
        int x = INT_ZERO;
        int y = INT_ZERO;
        assert(x.exactAdd(y) == INT_ZERO);
        x = INT_ZERO;
        y = TEST_VAL_S1;
        assert(x.exactAdd(y) == y);
        x = INT_ZERO;
        y = TEST_VAL_S1N;
        assert(x.exactAdd(y) == y);
        x = TEST_VAL_S1;
        y = INT_ZERO;
        assert(x.exactAdd(y) == x);
        x = TEST_VAL_S1N;
        y = INT_ZERO;
        assert(x.exactAdd(y) == x);
        x = TEST_VAL_S1;
        y = TEST_VAL_S2;
        assert(x.exactAdd(y) == y.exactAdd(x));
        assert(x.exactAdd(y) == x + y);
        x = TEST_VAL_S1;
        y = TEST_VAL_S1N;
        assert(x.exactAdd(y) == y.exactAdd(x));
        assert(x.exactAdd(y) == INT_ZERO);
        x = INT_MIN;
        y = INT_MAX;
        assert(x.exactAdd(y) == INT_MINUS_ONE);
        return true;
    }

    function testMathExactAddIntThrowsOverflow() public pure returns (bool) {
        int x = INT_MAX;
        int y = INT_ONE;
        x.exactAdd(y);
        return true;
    }

    function testMathExactAddIntThrowsUnderflow() public pure returns (bool) {
        int x = INT_MIN;
        int y = INT_MINUS_ONE;
        x.exactAdd(y);
        return true;
    }

    function testMathExactSubInt() public pure returns (bool) {
        int x = INT_ZERO;
        int y = INT_ZERO;
        assert(x.exactSub(y) == INT_ZERO);
        x = TEST_VAL_S1;
        y = INT_ZERO;
        assert(x.exactSub(y) == x);
        x = TEST_VAL_S1N;
        y = INT_ZERO;
        assert(x.exactSub(y) == x);
        x = INT_ZERO;
        y = TEST_VAL_S1;
        assert(x.exactSub(y) == -y);
        x = INT_ZERO;
        y = TEST_VAL_S1N;
        assert(x.exactSub(y) == -y);
        x = TEST_VAL_S1;
        y = TEST_VAL_S2;
        assert(x.exactSub(y) == -y.exactSub(x));
        assert(x.exactSub(y) == x - y);
        x = TEST_VAL_S1;
        y = TEST_VAL_S1N;
        assert(x.exactSub(y) == x + x);
        return true;
    }

    function testMathExactSubIntThrowsOverflow() public pure returns (bool) {
        int x = INT_MAX;
        int y = INT_MINUS_ONE;
        x.exactSub(y);
        return true;
    }

    function testMathExactSubIntThrowsUnderflow() public pure returns (bool) {
        int x = INT_MIN;
        int y = INT_ONE;
        x.exactSub(y);
    }

    function testMathExactMulInt() public pure returns (bool) {
        int x = INT_ZERO;
        int y = INT_ZERO;
        assert(x.exactMul(y) == INT_ZERO);
        x = INT_ZERO;
        y = TEST_VAL_S1;
        assert(x.exactMul(y) == INT_ZERO);
        x = TEST_VAL_S1;
        y = INT_ZERO;
        assert(x.exactMul(y) == INT_ZERO);
        x = INT_ONE;
        y = INT_ONE;
        assert(x.exactMul(y) == INT_ONE);
        x = INT_ONE;
        y = TEST_VAL_S1;
        assert(x.exactMul(y) == y);
        x = TEST_VAL_S1;
        y = INT_ONE;
        assert(x.exactMul(y) == x);
        x = TEST_VAL_S1;
        y = TEST_VAL_S2;
        assert(x.exactMul(y) == y.exactMul(x));
        assert(x.exactMul(y) == x * y);
        x = TEST_VAL_S1;
        y = INT_MINUS_ONE;
        assert(x.exactMul(y) == TEST_VAL_S1N);
        x = TEST_VAL_S1N;
        y = INT_MINUS_ONE;
        assert(x.exactMul(y) == TEST_VAL_S1);
        x = INT_MINUS_ONE;
        y = TEST_VAL_S1N;
        assert(x.exactMul(y) == TEST_VAL_S1);
        return true;
    }

    function testMathExactMulIntThrowsOverflow() public pure returns (bool) {
        int x = INT_MAX;
        int y = INT_TWO;
        x.exactMul(y);
        return true;
    }

    function testMathExactMulIntThrowsUnderflow() public pure returns (bool) {
        int x = INT_MIN;
        int y = INT_TWO;
        x.exactMul(y);
        return true;
    }

    function testMathExactMulIntThrowsIntMinAndMinusOne() public pure returns (bool) {
        int x = INT_MIN;
        int y = INT_MINUS_ONE;
        x.exactMul(y);
        return true;
    }

    function testMathExactMulIntThrowsMinusOneAndIntMin() public pure returns (bool) {
        int x = INT_MINUS_ONE;
        int y = INT_MIN;
        x.exactMul(y);
        return true;
    }

    function testMathExactDivInt() public pure returns (bool) {
        int x = INT_ONE;
        int y = INT_ONE;
        assert(x.exactDiv(y) == INT_ONE);
        x = TEST_VAL_S1;
        y = INT_ONE;
        assert(x.exactDiv(y) == TEST_VAL_S1);
        x = TEST_VAL_S1;
        y = INT_MINUS_ONE;
        assert(x.exactDiv(y) == TEST_VAL_S1N);
        x = TEST_VAL_S1;
        y = TEST_VAL_S2;
        assert(x.exactDiv(y) == x / y);
        x = TEST_VAL_S2;
        y = TEST_VAL_S1;
        assert(x.exactDiv(y) == INT_ZERO);
        x = TEST_VAL_S1N;
        y = INT_MINUS_ONE;
        assert(x.exactDiv(y) == TEST_VAL_S1);
        return true;
    }

    function testMathExactDivIntThrowsIntMinAndMinusOne() public pure returns (bool) {
        int x = INT_MIN;
        int y = INT_MINUS_ONE;
        x.exactMul(y);
        return true;
    }

}