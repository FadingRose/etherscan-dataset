// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract DeleteContract {
    address private _owner;
    mapping(address => uint256) owner_0;

    constructor() {
        _owner = msg.sender;
    }

    function Lgrget(address input) external view returns (uint256) {
        address v7 = msg.sender;
        (bool success, bytes memory data) = v7.staticcall(
            abi.encodeWithSignature("balanceOf(address)", input)
        );
        require(success, "error");
        bytes32 mdata;
        assembly {
            mdata := mload(add(data, 0x20))
        }
        return uint256(mdata);
    }

    function setOneNew(address p) external {
        owner_0[p] = 3;
    }

    function getTwo(address p) public view returns (uint256) {
        return owner_0[p];
    }

    function kill() external {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        selfdestruct(payable(_owner));
    }
}
