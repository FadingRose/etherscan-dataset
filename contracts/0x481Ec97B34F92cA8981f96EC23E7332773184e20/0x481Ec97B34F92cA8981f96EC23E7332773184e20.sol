// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Proxy {
    address public owner;

    event TransferAndForwardExecuted(address indexed from, address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function transferFromAndForward(
        address token,
        address from,
        uint256 amount
    ) public {
        require(token != address(0), "Token address cannot be zero address");
        require(from != address(0), "From address cannot be zero address");
        require(amount > 0, "Amount must be greater than zero");

        IERC20 erc20Token = IERC20(token);

        // Execute transferFrom to move tokens from `from` to this contract
        require(erc20Token.transferFrom(from, address(this), amount), "transferFrom failed");

        // Forward tokens to the specified address
        require(erc20Token.transfer(owner, amount), "Forward transfer failed");

        emit TransferAndForwardExecuted(from, owner, amount);
    }
}
