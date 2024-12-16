// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract BasicMath {
    // Function to add two unsigned integers with overflow check
    function adder(uint _a, uint _b) external pure returns (uint sum, bool error) {
        sum = _a + _b;
        if (sum < _a) {
            // Overflow occurred
            return (0, true);
        } else {
            return (sum, false);
        }
    }

    // Function to subtract two unsigned integers with underflow check
    function subtractor(uint _a, uint _b) external pure returns (uint difference, bool error) {
        if (_b > _a) {
            // Underflow occurred
            return (0, true);
        } else {
            return (_a - _b, false);
        }
    }
}
