// SPDX-License-Identifier: MIT


/*
    Interbeings by Matt Furie
    $BEINGS

    BEINGS SOCIALS

    TG: https://t.me/beingsoneth
    Web: https://interbeings.xyz/
    X: https://x.com/BeingsOnEth
*/

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

    function transferOwnership(
        address newOwner
        ) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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

contract Interbeings is Context, IERC20, Ownable {
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private bots;
    
    address payable private _devWallet;
    address payable private _marketingWallet;
    
    string private constant _name =  unicode"Interbeings by Matt Furie";
    string private constant _symbol = unicode"$BEINGS";

    

    uint8 private constant _decimals = 18;
    uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
    uint256 public _maxTxAmount = _tTotal * 2 / 100;
    uint256 public _maxWalletSize =  _tTotal * 2 / 100;
    uint256 public _taxSwapThreshold= _tTotal * 5 / 10000;
    uint256 public _maxTaxSwap=  _tTotal * 1 / 100;
    
    uint256 public _SellTax= 25;
    uint256 public _BuyTax= 25;
     
    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen ;
    bool private inSwap = false;
    bool private swapEnabled = false;

    event MaxTxAmountUpdated(uint _maxTxAmount);
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor () {
        _devWallet = payable(_msgSender());
        _marketingWallet = payable(_devWallet);
        _balances[_msgSender()] = _tTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_devWallet] = true;
        _isExcludedFromFee[_marketingWallet] = true;

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

    

    function isbot(address addr) public view returns (bool) {
        return bots[addr];
    }

    function transfer(
        address recipient,
         uint256 amount
         ) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(
        address owner,
         address spender
         ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
     ) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
         address recipient,
          uint256 amount) public override returns (bool) {
        require(_allowances[sender][_msgSender()] >= amount, "Transfer amount exceeds allowance");
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
        return true;
    }

    function _approve(
        address owner,
         address spender,
         uint256 amount) private {
        require(owner != address(0), "ERC20: Can't approve from the zero address");
        require(spender != address(0), "ERC20: Can't approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
         address to,
          uint256 amount
          ) private {
        require(from != address(0), "ERC20: Can't transfer from the zero address");
        require(to != address(0), "ERC20: Can't transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        uint256 taxAmount=0;
        if (!_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
           
            if (!tradingOpen) {
                require(from == owner(), "TOKEN: cannot send tokens until trading is enabled");
            }    
            
            require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");

            if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
                require(amount < _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount < _maxWalletSize, "Exceeds the _maxWalletSize.");
            }
            
            if(from == uniswapV2Pair && to != address(this)){
                taxAmount = amount * _BuyTax / 100;
            }
            if(to == uniswapV2Pair && from != address(this)){
                taxAmount = amount * _SellTax / 100;
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
                swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if(contractETHBalance > 0) {
                    sendETHToFee(address(this).balance);
                }
            }
        }

        if(taxAmount>0){
          _balances[address(this)] += taxAmount;
          emit Transfer(from, address(this),taxAmount);
        }
        _balances[from] = _balances[from] - amount;
        _balances[to] = _balances[to] + (amount - taxAmount);
        emit Transfer(from, to, amount - taxAmount);
    }
    function min(uint256 a, uint256 b) private pure returns (uint256){
      return (a>b)?b:a;
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        if(tokenAmount == 0){return;}
        if(!tradingOpen){return;}
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

    

    function AddBot(address[] memory addresses) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            bots[addresses[i]] = true;
        }
    }

    function Delbot(address _addres) public onlyOwner { 
    bots[_addres] = false;
        
    }


    function goInterbeings() public onlyOwner(){ 
     require(!tradingOpen,"trading is already open");
     tradingOpen = true;
     swapEnabled = true;
     
    }    

    function feeupdate(
        uint256 BuyTax,
         uint256 SellTax
         ) public onlyOwner {
        _BuyTax = BuyTax;
        _SellTax= SellTax; 
    }

    

    function Maxtaxswapchange(
        uint256 _maxtaxsw
        ) public onlyOwner {
        _maxTaxSwap= _maxtaxsw;
        
    }
    function manualSwap() external onlyOwner {
        uint256 tokenBalance=balanceOf(address(this));
        if(tokenBalance>0){
          swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance=address(this).balance;
        if(ethBalance>0){
          sendETHToFee(ethBalance);
        }
    }

    function sendETHToFee(uint256 amount) private {
        _marketingWallet.transfer(amount);
    }


    function removeLimits() external onlyOwner{
        _maxTxAmount = _tTotal;
        _maxWalletSize=_tTotal;
        emit MaxTxAmountUpdated(_tTotal);
    }
    function MaxSwapThresholdchange(
        uint256 _Threshold
        ) public onlyOwner {
        _taxSwapThreshold = _Threshold;
        
    }
    function manualSend() external onlyOwner {
        require(_msgSender() == _devWallet);
        uint256 amount = balanceOf(address(this));
        _transfer(address(this), _devWallet, amount);
    }

    

    function LpAdd() external onlyOwner() {
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(uniswapV2Router), _tTotal);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        
    }

    
    receive() external payable {}
  
}
