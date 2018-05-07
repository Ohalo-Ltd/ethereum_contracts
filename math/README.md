# ExactMath

The `ExactMath` contract is a library contract that can be utilized by other contracts to do safe math, i.e. math operations that will throw if an over/underflow is detected.

Tests can be run in remix, just deploy and run them one by one. The tests that are supposed to throw should return 'false', the others 'true'.