// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PriceFeed {
    address public owner;
    uint256 public price;

    event PriceUpdated(uint256 oldPrice, uint256 newPrice);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(uint256 _initialPrice) {
        owner = msg.sender;
        price = _initialPrice; // Set the initial price during deployment
    }

    function updatePrice(uint256 _price) public onlyOwner {
        uint256 oldPrice = price;
        price = _price;
        emit PriceUpdated(oldPrice, _price);
    }

    function getPrice() public view returns (uint256) {
        return price;
    }
}
