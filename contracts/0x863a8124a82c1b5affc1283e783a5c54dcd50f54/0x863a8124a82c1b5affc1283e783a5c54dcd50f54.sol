// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

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
// Adjust token name here <<
contract CACOKI is Context, IERC20, Ownable {
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    address payable private _taxWallet;

    uint256 private _buyCount=0;
    uint256 private _tradingStartTimestamp;
    uint256 private _preventSwapBefore=25;
    uint256 private _finalBuyTax=30;
    uint256 private _finalSellTax=50;
    uint256 private _targetTax=5;

    uint8 private constant _decimals = 9;
    uint256 private constant _tTotal = 100_000_000 * 10**_decimals;
    string private constant _name = unicode"CASHCOWKING"; //Name of the project <<
    string private constant _symbol = unicode"CACOKI"; //Ticker symbol <<

    
    uint256 public _maxTxAmount = 1_000_000 * 10**_decimals;
    uint256 public _maxWalletSize = 1_000_000 * 10**_decimals;
    uint256 public _taxSwapThreshold= 1_000_000 * 10**_decimals;
    uint256 public _maxTaxSwap= 1_000_000 * 10**_decimals;
    
    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;
    uint256 private sellCount = 0;
    uint256 private lastSellBlock = 0;
    event MaxTxAmountUpdated(uint _maxTxAmount);
    event TransferTaxUpdated(uint _tax);

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    /// Modifier to check if 15 minutes passed to remove MaxWalletsize and adjust fees by seconds
    modifier _checkTime() {
        if(!tradingOpen) {
            _;
            return;
        }
        
        if(((_tradingStartTimestamp + (15*60)) <= block.timestamp) && (_maxWalletSize < totalSupply())) {
            _maxTxAmount = _tTotal;
            _maxWalletSize=_tTotal;
            emit MaxTxAmountUpdated(_tTotal);
        }

        uint256 actualTimeDiff = block.timestamp - (_tradingStartTimestamp + (15*60));

            if(_finalBuyTax > 5 && _finalSellTax > 5 && (_tradingStartTimestamp + (15*60)) >= block.timestamp) {
                _finalBuyTax = (_targetTax + ((30 - _targetTax) / 900) * actualTimeDiff);
                _finalSellTax = (_targetTax + ((50 - _targetTax) / 900) * actualTimeDiff);
            } else {
                _finalBuyTax = 5;
                _finalSellTax = 5;
            }

        _;
    }

    /// Constructor
    /// @param _pancakeRouter address       Address of the PancakeV2Router
    /// @param _taxAddres address           Address of the taxCollecting wallet
    constructor (address _pancakeRouter, address _taxAddres) {
        _taxWallet = payable(_taxAddres);

        _balances[_msgSender()] = _tTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet] = true;

        uniswapV2Router = IUniswapV2Router02(_pancakeRouter);

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    /// Returs name of the token
    function name() public pure returns (string memory) {
        return _name;
    }

    /// Returns Symbol of the token
    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    /// Returns Decimals of the token
    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    /// Returns total token supply
    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    /// Returns balance of the given address
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /// Transfers token from msg.sender to specified address
    /// @param recipient address    receiver of the tokens
    /// @param amount uint256       amount to transfer in wei
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /// Returns the allowance for the 
    /// @param owner address        Owner of the token
    /// @param spender addres       Contract/User allowed to spend Owners token
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    /// Raises the allowance to spend token from spender address
    /// @param spender address      Contract/User allowed to spend msg.senders token
    /// @param amount uint256       Maximum amount of tokens allowd to spent in wei
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /// Like transfer() function but could be run by others to transfer tokens from my wallet
    /// needs allowance >= amount to transfer
    /// @param sender address       Owner of the tokens to send
    /// @param recipient address    Receiver of the owners token
    /// @param amount uint256       amount to transfer in wei
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
        return true;
    }

    /// Implementation of the approve function
    /// @param owner address        Owner of the tokens
    /// @param spender address      Allowed to spend owners token
    /// @param amount uint256       Maximum allowed amount to spend in wei
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /// Implementation of the transfer function
    /// @param from address         Sender of the token
    /// @param to address           Receiver of the token
    /// @param amount uint256       Amount to send in wei
    function _transfer(address from, address to, uint256 amount) private _checkTime {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        uint256 taxAmount=0;
        if (from != owner() && to != owner()) {

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                taxAmount = (amount * _finalBuyTax) /100;
                _buyCount++;
            }

            if(to == uniswapV2Pair && from != address(this) ){
                taxAmount = (amount * _finalSellTax) / 100;
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold && _buyCount > _preventSwapBefore) {
                if (block.number > lastSellBlock) {
                    sellCount = 0;
                }
                require(sellCount < 3, "Only 3 sells per block!");
                swapTokensAndAdd(min(amount, min(contractTokenBalance, _maxTaxSwap)));

                sellCount++;
                lastSellBlock = block.number;
            }
        }

        if(taxAmount>0){
          swapTaxToETH(taxAmount);
        }

        _balances[from]=_balances[from] - amount;
        _balances[to]=_balances[to] + amount - taxAmount;
        emit Transfer(from, to, amount - taxAmount);
    }

    /// Determines which number is lower and returns it
    /// @param a uint256            First number
    /// @param b uint256            Second number
    function min(uint256 a, uint256 b) private pure returns (uint256){
      return (a>b)?b:a;
    }

    /// swaps tax to eth and added it to liquidty
    /// @param tokenAmount uint256 amount of tokens to swap and add
    function swapTokensAndAdd(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uint256 halfAmount = tokenAmount / 2;

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            halfAmount,
            0,
            path,
            address(this),
            block.timestamp
        );

        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),halfAmount,0,0,address(this),block.timestamp);
    }

    function swapTaxToETH(uint256 taxAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), taxAmount);

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            taxAmount,
            0,
            path,
            _taxWallet,
            block.timestamp
        );
    }

    /// remove all limits from the contract
    function removeLimits() external onlyOwner{
        _maxTxAmount = _tTotal;
        _maxWalletSize=_tTotal;
        emit MaxTxAmountUpdated(_tTotal);
    }

    /// opens the trading
    /// @notice tokens and eth need to be sent here before running the function. This function could only be ran once
    function openTrading() external onlyOwner() {
        require(!tradingOpen,"trading is already open");
        _approve(address(this), address(uniswapV2Router), _tTotal);

        _tradingStartTimestamp = block.timestamp;

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,address(this),block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        swapEnabled = true;
        tradingOpen = true;
    }

    /// Reduces the taxes
    function reduceFee(uint256 _newFee) external onlyOwner {
      require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
      _finalBuyTax=_newFee;
      _finalSellTax=_newFee;
    }

    receive() external payable {}
}
