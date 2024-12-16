/*
 * UNISCAN - AI-based prediction solution for your crypto-trades
 * 
 * This is a promotional contract, building community first
 * 
 * TG : https://t.me/uniscan
*/

// SPDX-License-Identifier: UNLICENSE

pragma solidity ^0.8.24;

contract UNISCAN_marketing {
    string public constant NAME = "UNISCAN AI";
    string public constant SYMBOL = "SCAN";
    uint8 public constant DECIMALS = 9;
    uint256 public constant TOTAL_SUPPLY = 1000000 * (10 ** uint256(DECIMALS));

    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
        emit OwnershipTransferred(_owner, address(0));
    }

    function totalSupply() public pure returns (uint256) {
        return TOTAL_SUPPLY;
    }

    function name() public pure returns (string memory) {
        return NAME;
    }

    function symbol() public pure returns (string memory) {
        return SYMBOL;
    }

    function decimals() public pure returns (uint8) {
        return DECIMALS;
    }
}
