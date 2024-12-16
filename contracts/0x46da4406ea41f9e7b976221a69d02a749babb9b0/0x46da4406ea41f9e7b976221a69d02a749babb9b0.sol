/**
 *Submitted for verification at Etherscan.io on 2024-07-25
*/

//SPDX-License-Identifier: MIT

/*
 * Let's Make America Great Again with Trump the man !
*/

pragma solidity ^0.8.1;

contract TTM {
    string public constant NAME = "Trump the man";
    string public constant SYMBOL = "TTM";
    uint8 public constant DECIMALS = 18;
    uint256 public constant TOTAL_SUPPLY = 4690000000 * (10 ** uint256(DECIMALS));

    mapping(address => uint256) private _balances;
    event Transfer(address indexed from, address indexed to, uint256 value);
	
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _balances[msg.sender] = TOTAL_SUPPLY;
        emit Transfer(address(0), msg.sender, TOTAL_SUPPLY);
        emit OwnershipTransferred(address(0), msg.sender);
        emit OwnershipTransferred(msg.sender, address(0));
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

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function min(uint256 a, uint256 b) private pure returns (uint256){
      return (a>b)?b:a;
    }
}
