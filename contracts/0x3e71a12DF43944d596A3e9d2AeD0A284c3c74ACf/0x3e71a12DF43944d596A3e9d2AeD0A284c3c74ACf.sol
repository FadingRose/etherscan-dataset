// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SorosCoin {
    string public constant name = "Soros Coin";
    string public constant symbol = "SOROSCOIN";
    uint256 public constant decimals = 18;
    uint256 public constant initialSupply = 1_000_000_000 * (10 ** decimals);

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balances[msg.sender] = initialSupply;
        emit Transfer(address(0), msg.sender, initialSupply);
    }

    function totalSupply() external pure returns (uint256) {
        return initialSupply;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) external returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balances[msg.sender] >= _value, "Insufficient balance");

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        require(_to != address(0), "Invalid address");
        require(balances[_from] >= _value, "Insufficient balance");
        require(allowed[_from][msg.sender] >= _value, "Allowance exceeded");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) external view returns (uint256) {
        return allowed[_owner][_spender];
    }
}
