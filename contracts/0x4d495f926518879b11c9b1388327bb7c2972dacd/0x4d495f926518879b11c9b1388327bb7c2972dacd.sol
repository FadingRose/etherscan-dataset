// SPDX-License-Identifier: MIT
// ProphetBots: Revenue Share (MultiSend)
// Website: https://prophetbots.com
// Telegram: https://t.me/prophetbots
pragma solidity ^0.8.26;

/**
 @dev Basic ERC Interface.
 */
interface ERC20Basic {
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 @dev ERC Interface.
 */
interface ERC20 is ERC20Basic {
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
}

/**
 * @title MultiSend
 * @dev Contract that allows multiple ETH transfers in a single transaction
 */
contract ProphetRevenueShare {
    using SafeMath for uint256;

    function Distribute(address[] calldata addresses, uint256[] calldata amounts) external payable {
        require(addresses.length == amounts.length, "Addresses and amounts arrays must be of the same length");

        uint256 totalAmount = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmount = totalAmount.add(amounts[i]);
        }
        require(msg.value == totalAmount, "Total amount sent must match the sum of amounts to be distributed");

        for (uint256 i = 0; i < addresses.length; i++) {
            payable(addresses[i]).transfer(amounts[i]);
        }
    }
}
