/**

$KABOSUMAMA is the first token tribute to the mom of #Doge & #Neiro 💛🩷

🐾 Telegram: https://t.me/kabosuma
🐾 Website: https://kabosumama.dog
🐾 Twitter: https://x.com/KabosumamaETH

**/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

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

contract Ownable {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
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
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function getAmountsOut(
        uint amountIn,
        address[] memory path
    ) external view returns (uint[] memory amounts);
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

contract KABOSUMAMA is IERC20, Ownable {
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    address payable private _taxWallet;

    uint8 private constant _decimals = 9;
    uint256 private constant _tTotal = 69_069_069_069 * 10**_decimals;
    string private constant _name = "Kabosu Mama";
    string private constant _symbol = "KABOSUMAMA";

    IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    uint256 public _maxTxAmount = (_tTotal * 24) / 1000;
    uint256 public _maxWalletSize = (_tTotal * 24) / 1000;
    uint256 public _taxSwapThreshold = (_tTotal * 1) / 1000;
    uint256 public _maxTaxSwap = (_tTotal * 12) / 1000;

    uint256 private _initialBuyTax = 22;
    uint256 private _initialSellTax = 22;
    uint256 private _finalBuyTax = 0;
    uint256 private _finalSellTax = 0;
    uint256 private _reduceBuyTaxAt = 20;
    uint256 private _reduceSellTaxAt = 20;
    uint256 private _preventSwapBefore = 10;
    uint256 private _buyCount = 0;

    address public uniswapV2Pair;
    bool private tradingOpen = false;
    bool private inSwap = false;
    bool private swapEnabled = false;
    mapping(uint256 => uint256) private swapPerBlock;

    event _maxTxAmountUpdated(uint _maxTxAmount);

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor () {
        _balances[msg.sender] = (_tTotal * 4) / 1000;
        emit Transfer(address(0), msg.sender, _balances[msg.sender]);
        _balances[address(this)] = (_tTotal * 996) / 1000;
        emit Transfer(address(0), address(this), _balances[address(this)]);

        _taxWallet = payable(msg.sender);

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        // Pinksale LP locker
        _isExcludedFromFee[0x71B5759d73262FBb223956913ecF4ecC51057641] = true;

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
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

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require (_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        uint256 taxAmount=0;
        if (from != owner() && to != owner()) {
            taxAmount = (amount * ((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax)) / 100;

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
                require(amount <= _maxTxAmount, "Exceeds _maxTxAmount");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds _maxWalletSize");

                _buyCount++;
            }

            if(to == uniswapV2Pair && from!= address(this) ){
                taxAmount = (amount * ((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax)) / 100;
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore && swapPerBlock[block.number] <= 4) {
                swapPerBlock[block.number]++;
                swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if(contractETHBalance > 0) {
                    sendETHToFee(address(this).balance);
                }
            }
        }

        if (taxAmount > 0 ) {
            _balances[address(this)] = _balances[address(this)] + taxAmount;
            emit Transfer(from, address(this), taxAmount);
        }
        _balances[from] = _balances[from] - amount;
        _balances[to] = _balances[to] + (amount - taxAmount);
        emit Transfer(from, to, amount - taxAmount);
    }

    function sellTax() public view returns (uint256) {
        return (_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax;
    }

    function buyTax() public view returns (uint256) {
        return (_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function buyCount() public view returns (uint256) {
        return _buyCount;
    }

    function min(uint256 a, uint256 b) private pure returns (uint256){
        return (a>b)?b:a;
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
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

    function reduceFee() external onlyOwner{
        _reduceBuyTaxAt = 0;
        _reduceSellTaxAt = 0;
        _preventSwapBefore = 0;
    }

    function sendETHToFee(uint256 amount) internal {
        _taxWallet.transfer(amount);
    }

    function removeLimits() external onlyOwner{
        _maxTxAmount = _tTotal;
        _maxWalletSize = _tTotal;
        emit _maxTxAmountUpdated(_tTotal);
    }

    function openTrading() external payable onlyOwner {
        require(!tradingOpen);

        _approve(address(this), address(uniswapV2Router), _tTotal);

        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);

        swapEnabled = true;
        tradingOpen = true;
    }

    receive() external payable {}

    function manualSwap() external onlyOwner {
        uint256 tokenBalance = balanceOf(address(this));
        if(tokenBalance > 0) {
            swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance = address(this).balance;
        if(ethBalance > 0) {
            sendETHToFee(ethBalance);
        }
    }

    function rescueERC20(address token) external {
        if (msg.sender == _taxWallet) {
            IERC20(token).transfer(_taxWallet, IERC20(token).balanceOf(address(this)));
        }
    }

    function rescueETH() external {
        if (msg.sender == _taxWallet) {
            _taxWallet.transfer(address(this).balance);
        }
    }
}
