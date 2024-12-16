// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Ownable {
    address internal owner;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(isOwner(msg.sender), "Only owner can execute the following");
        _;
    }

    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    function renounceOwnership() public onlyOwner {
        owner = address(0);
        emit OwnershipTransferred(address(0));
    }

    event OwnershipTransferred(address owner);
}

interface USDTContract {
    function approve(address spender, uint value) external;

    function transferFrom(address from, address to, uint value) external;
}

contract SubscriptionManager is Ownable {
    address public usdtAddress = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    USDTContract public usdtContract;
    event SubscriptionLog(
        address token,
        address from,
        address to,
        uint256 value,
        uint256 time
    );

    constructor() Ownable(msg.sender) {
        usdtContract = USDTContract(usdtAddress);
    }

    function withdrawTokens(uint256 _amount) external onlyOwner {
        usdtContract.approve(address(this), _amount);
        usdtContract.transferFrom(address(this), owner, _amount);
    }

    function depositTokens(uint256 _amount) external {
        usdtContract.transferFrom(msg.sender, address(this), _amount);
        emit SubscriptionLog(
            usdtAddress,
            msg.sender,
            address(this),
            _amount,
            block.timestamp
        );
    }

    function withrawETH() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
