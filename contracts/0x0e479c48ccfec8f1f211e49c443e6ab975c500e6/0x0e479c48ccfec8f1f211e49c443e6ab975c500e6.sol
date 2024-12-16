// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract GROWLSALE {
    IERC20 public memecoin;
    address public owner;
    uint256 public price; // Price in wei (e.g., 0.0000028 ETH = 2800000000000 wei)
    uint256 public maxSpendAmount = 0.16 * 10**18; // 0.16 ETH in wei
    mapping(address => uint256) public userSpendAmount;

    event TokensPurchased(address buyer, uint256 amountSpent, uint256 amountBought);
    event TokensDeposited(address owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(IERC20 _memecoin, uint256 _price) {
        memecoin = _memecoin;
        owner = msg.sender;
        price = _price; // Price per memecoin in wei (e.g., 2800000000000 wei per memecoin)
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function setMaxSpendAmount(uint256 _maxSpendAmount) external onlyOwner {
        maxSpendAmount = _maxSpendAmount;
    }

    function buyMemecoins() external payable {
        uint256 ethAmount = msg.value;
        require(ethAmount > 0, "Amount should be greater than zero");
        require(userSpendAmount[msg.sender] + ethAmount <= maxSpendAmount, "Exceeds maximum spend limit");

        uint256 memecoinsToBuy = (ethAmount * 10**18) / price; // ETH has 18 decimals, token has 18 decimals

        require(memecoin.balanceOf(address(this)) >= memecoinsToBuy, "Not enough memecoins in the reserve");

        // Update the user's spend amount
        userSpendAmount[msg.sender] += ethAmount;

        // Transfer memecoins from the contract to the buyer
        require(memecoin.transfer(msg.sender, memecoinsToBuy), "Memecoin transfer failed");

        emit TokensPurchased(msg.sender, ethAmount, memecoinsToBuy);
    }

    function depositGrowlcoins(uint256 amount) external onlyOwner {
        require(memecoin.transferFrom(msg.sender, address(this), amount), "Memecoin transfer failed");
        emit TokensDeposited(msg.sender, amount);
    }

    function withdrawETH(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Not enough ETH in the reserve");
        payable(owner).transfer(amount);
    }

    function withdrawGrowlcoins(uint256 amount) external onlyOwner {
        require(memecoin.balanceOf(address(this)) >= amount, "Not enough memecoins in the reserve");
        memecoin.transfer(owner, amount);
    }

    // Fallback function to accept ETH sent directly to the contract
    fallback() external payable {}
    receive() external payable {}
}
