/**
 *X : https://x.com/neiro_ethereum
*/

// SPDX-License-Identifier: unlicense

pragma solidity ^0.8.20;

contract NeiroERC {
    string public constant name = "Neiro 2.0";  
    string public constant symbol = "Neiro";  
    uint8 public constant decimals = 18;
    uint256 public constant totalSupply = 100_000_000 * 10**decimals;

    // Removed BurnAmount and ConfirmAmount 

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
        
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    address payable constant deployer = payable(address(0xd15f85d974D7814856D0A17a3A5dfdf10F26f763)); 

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
        allowance[from][msg.sender] -= amount;        
        return _transfer(from, to, amount);
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

    // Neiro
}
