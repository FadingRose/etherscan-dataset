// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

contract MyTestContract {
    function getBaseFee() public view returns (uint) {
        return block.basefee;
    }
}
