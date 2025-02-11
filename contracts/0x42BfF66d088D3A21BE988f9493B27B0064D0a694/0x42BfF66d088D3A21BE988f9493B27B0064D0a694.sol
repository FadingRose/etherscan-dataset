// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartWorld {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    // Address to receive transaction fees
    address public constant feeAddress = 0x68f571d35eD3b92af7631F4736B39C8bCD60C256;
    uint256 public constant feePercentage = 10; // 10% fee

    constructor() {
        _name = "SmartWorld";
        _symbol = "SMT";
        _decimals = 18;

        _totalSupply = 980000000000 * 10**uint256(_decimals);
        _balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender] - amount
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender] - subtractedValue
        );
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "SmartWorld: transfer from the zero address");
        require(recipient != address(0), "SmartWorld: transfer to the zero address");

        uint256 feeAmount = (amount * feePercentage) / 100;
        uint256 transferAmount = amount - feeAmount;

        _balances[sender] -= amount;
        _balances[recipient] += transferAmount;
        _balances[feeAddress] += feeAmount;

        emit Transfer(sender, recipient, transferAmount);
        emit Transfer(sender, feeAddress, feeAmount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "SmartWorld: approve from the zero address");
        require(spender != address(0), "SmartWorld: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
