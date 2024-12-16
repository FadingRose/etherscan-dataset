// SPDX-License-Identifier: MIT

/*
Website: https://shitfurie.fun/

Telegram: https://t.me/ShitFurie

X: https://x.com/ShitFurie
*/

pragma solidity ^0.8.0;

contract SHIT {
    string public name = "Shit Furie";
    string public symbol = "SHIT";
    uint8 public decimals = 18;
    uint256 public totalSupply = 100000000 * 10**uint256(decimals);
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "Not enough tokens");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(value <= balanceOf[from], "Not enough tokens");
        require(value <= allowance[from][msg.sender], "Allowance exceeded");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "Only owner can transfer ownership");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function renounceOwnership() public {
        require(msg.sender == owner, "Only owner can renounce ownership");
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }
}
