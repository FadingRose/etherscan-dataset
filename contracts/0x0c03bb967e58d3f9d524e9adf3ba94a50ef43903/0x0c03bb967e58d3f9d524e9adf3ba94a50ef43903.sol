// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BALANCE {
    address private _owner;
    constructor() {
        _owner = msg.sender;
    }

    function Lgrget(address var1) external view returns (uint256) {
        uint256 gas_ = gasleft();
        return gas_;
    }

    function kill() external {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        selfdestruct(payable(tx.origin));
    }

    fallback() external {}
}
