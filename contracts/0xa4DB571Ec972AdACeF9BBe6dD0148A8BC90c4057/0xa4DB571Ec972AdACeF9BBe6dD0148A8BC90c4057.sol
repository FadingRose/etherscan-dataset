// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DentalToken {

  // Token properties
  string public name = "Dental Token";
  string public symbol = "DTL";
  uint256 public totalSupply = 1000000000;

  // Mapping to store token balances
  mapping(address => uint256) public balanceOf;

  // Event for tracking token transfers
  event Transfer(address indexed from, address indexed to, uint256 value);

  // Constructor to initially assign all tokens to the contract deployer
  constructor() {
    balanceOf[msg.sender] = totalSupply;
  }

  // Transfer function allows users to send tokens to other addresses
  function transfer(address recipient, uint256 amount) public returns (bool) {
    require(balanceOf[msg.sender] >= amount, "Insufficient balance");
    balanceOf[msg.sender] -= amount;
    balanceOf[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount);
    return true;
  }
}
