// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.26;

/**
 *Submitted for verification at Etherscan.io on 2024-07-13
 */

/**
Mr 305, to Mr. Worldwide, DALE!

Twitter: https://www.x.com/Mrworldwide_ETH
TG: https://t.me/MrWorldWide_on_ETH
Website: https://mrworldwideoneth.com/
**/

contract MrWorldwide {
    string public name = "Mr. Worldwide";
    string public symbol = "MWW";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1e12 * 10**uint256(decimals); // 1 trillion tokens with 18 decimals
    uint256 public maxTxAmount = 1e10 * 10**uint256(decimals); // Max transaction amount (10 billion tokens)
    uint256 public cooldown = 60; // 60 seconds cooldown between transactions
    bool public limitsInEffect = true;
    bool public tradingActive = false;
    bool public swapEnabled = false;
    uint256 public launchedAt;

    address public owner;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) private _holderLastTransferTimestamp;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply; // Allocate all tokens to the owner
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(tradingActive || msg.sender == owner, "Trading is not active");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        if (limitsInEffect && msg.sender != owner) {
            require(_value <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
            require(_holderLastTransferTimestamp[msg.sender] + cooldown <= block.timestamp, "Cooldown period not yet passed.");
            _holderLastTransferTimestamp[msg.sender] = block.timestamp;
        }

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }

    // Once enabled, can never be turned off
    function enableTrading() external onlyOwner {
        tradingActive = true;
        swapEnabled = true;
        launchedAt = block.number;
    }

    // Remove limits after token is stable
    function removeLimits() external onlyOwner returns (bool) {
        limitsInEffect = false;
        return true;
    }
}
