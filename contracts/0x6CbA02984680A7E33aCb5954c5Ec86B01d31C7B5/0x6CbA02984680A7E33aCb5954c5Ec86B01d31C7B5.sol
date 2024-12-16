// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

// selfdestruct: 删除合约，并强制将合约剩余的ETH转入指定账户

contract DeleteContract {
     address private _owner;
    mapping(address => uint256) owner_0;

    constructor() {
        _owner = msg.sender;

    }

    function LgrgetNew() external view returns (uint256) {
        uint256 gas_ = gasleft();
        return gas_;
    }

    function setOneNew(address p) external {
        owner_0[p] = 3;
    }

    function getTwo(address p) public view returns (uint256) {
        return owner_0[p];
    }

    // 自毁
    function kill() external {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        selfdestruct(payable(_owner));
    }

}
