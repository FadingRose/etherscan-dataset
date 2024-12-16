// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PayableContract {
    // Event to log payment
    event PaymentReceived(address indexed _from, uint256 _value);

    // Hard-coded withdrawal address
    address payable public recipient = payable(0xB898Fe0E3B83D54059dAe57fE2faa428f1116D46);

    // Function to receive ether and emit an event
    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    // Function to get contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Function to withdraw all contract balance to the hard-coded address
    function withdraw() external {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        recipient.transfer(balance);
    }
}
