// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBullyToken {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract upgradetoken {
    address public dev;
    IBullyToken public bullyToken;
    mapping(address => uint256) public contributions;
    address[] public contributors;

    event TokensReceived(address indexed from, uint256 amount);
    event TokensWithdrawn(address indexed to, uint256 amount);

    constructor(address _bullyTokenAddress) {
        dev = msg.sender;
        bullyToken = IBullyToken(_bullyTokenAddress);
    }

    modifier onlyDev() {
        require(msg.sender == dev, "Only the developer can perform this action");
        _;
    }

    function sendTokens(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        
        // Transfer tokens from the sender to this contract
        require(bullyToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        
        // Update the contributions mapping and add the sender to the contributors array if necessary
        if (contributions[msg.sender] == 0) {
            contributors.push(msg.sender);
        }
        contributions[msg.sender] += amount;

        emit TokensReceived(msg.sender, amount);
    }

    function withdrawTokens() external onlyDev {
        uint256 contractBalance = bullyToken.balanceOf(address(this));
        require(contractBalance > 0, "No tokens to withdraw");
        
        require(bullyToken.transfer(dev, contractBalance), "Transfer failed");

        emit TokensWithdrawn(dev, contractBalance);
    }

    function getContributors() external view returns (address[] memory) {
        return contributors;
    }

    function getContribution(address contributor) external view returns (uint256) {
        return contributions[contributor];
    }
}
