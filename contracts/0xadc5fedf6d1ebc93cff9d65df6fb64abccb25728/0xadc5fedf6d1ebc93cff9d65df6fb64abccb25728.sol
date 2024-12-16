// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RUFE {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;

    mapping (address => uint256) public balanceOf;
    mapping (address => uint256) public freezeOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Freeze(address indexed from, uint256 value);
    event Unfreeze(address indexed from, uint256 value);

    constructor(
        uint256 initialSupply,
        string memory tokenName,
        uint8 decimalUnits,
        string memory tokenSymbol
    ) {
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
        owner = msg.sender;
    }

    function transfer(address _to, uint256 _value) public {
        require(_to != address(0), "Transfer to the zero address");
        require(_value > 0, "Transfer value must be greater than zero");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_value > 0, "Approval value must be greater than zero");

        allowance[msg.sender][_spender] = _value;

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Transfer to the zero address");
        require(_value > 0, "Transfer value must be greater than zero");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Insufficient allowance");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(_value > 0, "Burn value must be greater than zero");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;

        emit Burn(msg.sender, _value);

        return true;
    }

    function freeze(uint256 _value) public returns (bool success) {
        require(_value > 0, "Freeze value must be greater than zero");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");

        balanceOf[msg.sender] -= _value;
        freezeOf[msg.sender] += _value;

        emit Freeze(msg.sender, _value);

        return true;
    }

    function unfreeze(uint256 _value) public returns (bool success) {
        require(_value > 0, "Unfreeze value must be greater than zero");
        require(freezeOf[msg.sender] >= _value, "Insufficient frozen balance");

        freezeOf[msg.sender] -= _value;
        balanceOf[msg.sender] += _value;

        emit Unfreeze(msg.sender, _value);

        return true;
    }

    function withdrawEther(uint256 amount) public {
        require(msg.sender == owner, "Only owner can withdraw Ether");
        payable(owner).transfer(amount);
    }

    receive() external payable {}
}
