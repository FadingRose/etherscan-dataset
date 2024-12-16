// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Covesco is IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    uint256 public taxRate; // Tax rate as a percentage

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 initialSupply,
        uint256 _taxRate
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = initialSupply;
        taxRate = _taxRate;
        owner = msg.sender;
        _balances[msg.sender] = initialSupply;
        emit Transfer(address(0), msg.sender, initialSupply);
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        uint256 taxAmount = (amount * taxRate) / 100;
        uint256 afterTaxAmount = amount - taxAmount;

        require(_balances[msg.sender] >= amount, "Insufficient balance");

        _balances[msg.sender] -= amount;
        _balances[recipient] += afterTaxAmount;
        _balances[owner] += taxAmount;

        emit Transfer(msg.sender, recipient, afterTaxAmount);
        if (taxAmount > 0) {
            emit Transfer(msg.sender, owner, taxAmount);
        }

        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        uint256 taxAmount = (amount * taxRate) / 100;
        uint256 afterTaxAmount = amount - taxAmount;

        require(_balances[sender] >= amount, "Insufficient balance");
        require(_allowances[sender][msg.sender] >= amount, "Allowance exceeded");

        _balances[sender] -= amount;
        _balances[recipient] += afterTaxAmount;
        _balances[owner] += taxAmount;
        _allowances[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, afterTaxAmount);
        if (taxAmount > 0) {
            emit Transfer(sender, owner, taxAmount);
        }

        return true;
    }

    function allowance(address accountOwner, address spender) external view override returns (uint256) {
        return _allowances[accountOwner][spender];
    }

    function setTaxRate(uint256 _taxRate) external onlyOwner {
        require(_taxRate <= 100, "Tax rate must be between 0 and 100");
        taxRate = _taxRate;
    }
}
