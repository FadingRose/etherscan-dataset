// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BasicMath {
    function adder(uint _a, uint _b) external pure returns (uint sum, bool error) {
        sum = _a + _b;
        if (sum < _a) {
            // Overflow occurred
            return (0, true);
        } else {
            return (sum, false);
        }
    }

    function subtractor(uint _a, uint _b) external pure returns (uint difference, bool error) {
        if (_b > _a) {
            // Underflow occurred
            return (0, true);
        } else {
            return (_a - _b, false);
        }
    }
}
