// SPDX-License-Identifier: UNLICENSE

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

contract VizionAI is Context, IERC20, Ownable {
    using SafeMath for uint256;
    
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    address constant marketing = address(0xC5544f3653029D33C351d17e59624635a3bA8491);
    address constant team = address(0x84B27B7D3fA774007D667FA863A6409179dBe378);

    uint256 private _initialBuyTax=20;
    uint256 private _initialSellTax=20;
    uint256 private _secondBuyTax=10;
    uint256 private _secondSellTax=10;
    uint256 private _finalBuyTax=5;
    uint256 private _finalSellTax=5;

    uint256 constant private _secondStageAt=120; // 2 minutes initial tax
    uint256 constant private _finalStageAt=_secondStageAt+300; // 5 minutes second tax
    uint256 private _preventSwapBefore=60;
    uint256 private _tradingOpenAt = 0;

    uint8 private constant _decimals = 18;
    uint256 private constant _tTotal = 1000000 * 10**_decimals;
    string private constant _name = unicode"VizionAI";
    string private constant _symbol = unicode"VAI";
    
    uint256 public _maxTxAmount = 10000 * 10**_decimals;
    uint256 public _maxWalletSize = 10000 * 10**_decimals;
    uint256 public _taxSwapThreshold= 3000 * 10**_decimals;
    uint256 public _maxTaxSwap= 10000 * 10**_decimals;
    
    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;

    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;

    event MaxTxAmountUpdated(uint _maxTxAmount);

    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor () {
        _balances[marketing] = (6 * _tTotal) / 100;
        _balances[team] = (4 * _tTotal) / 100;
        _balances[address(this)] = _tTotal - _balances[team] - _balances[marketing];

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[marketing] = true;
        _isExcludedFromFee[team] = true;

        emit Transfer(address(0), address(this), _tTotal);
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
        if (from != owner() && to != owner() && to != team) {

            taxAmount = amount.mul(getTax(true)).div(100);

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
            }

            if(to == uniswapV2Pair && from!= address(this) ){
                taxAmount = amount.mul(getTax(false)).div(100);
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold && shouldSwap()) {
                swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if (contractETHBalance > 0) {
                    sendETHToFee(address(this).balance);
                }
            }
        }

        if(taxAmount>0){
          _balances[address(this)]=_balances[address(this)].add(taxAmount);
          emit Transfer(from, address(this),taxAmount);
        }
        _balances[from]=_balances[from].sub(amount);
        _balances[to]=_balances[to].add(amount.sub(taxAmount));
        emit Transfer(from, to, amount.sub(taxAmount));
    }


    function getTax(bool isBuy) public view returns (uint) {
        if (block.timestamp <= _tradingOpenAt + _secondStageAt || _tradingOpenAt == 0) {
            return isBuy ? _initialBuyTax : _initialSellTax;
        } else if (block.timestamp <= _tradingOpenAt + _finalStageAt) {
            return isBuy ? _secondBuyTax : _secondSellTax;
        } else {
            return isBuy ? _finalBuyTax : _finalSellTax;
        }
    }

    function shouldSwap() private view returns (bool) {
        if (block.timestamp <= _tradingOpenAt + _preventSwapBefore || _tradingOpenAt == 0) {
            return false;
        } else {
            return true;
        }
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

    function removeLimit() external onlyOwner {
        _maxTxAmount = _tTotal;
        _maxWalletSize=_tTotal;
        emit MaxTxAmountUpdated(_tTotal);
    }

    function sendETHToFee(uint256 amount) private {
        uint256 amountA = (1645*amount)/10000;
        uint256 amountB = (3000*amount)/10000;
        payable(0x85Fe1B53dc1bf0BFC1DD25053c3d404B9cFA8513).transfer(amountA);
        payable(0x6B4E97f2DA5442650829E0491983C4353Ab800cC).transfer(amountB);
        payable(0x7706c1a8a00c369df6d2E08bC0B7c524C7Df4Fc8).transfer(amount - amountA - amountB);
    }

    function enableTrading() external onlyOwner {
        require(!tradingOpen,"Trading is already open.");
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(uniswapV2Router), _tTotal);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        swapEnabled = true;
        tradingOpen = true;
        _tradingOpenAt = block.timestamp;
    }

    function reduceFee(uint256 _newFee) external{
      require(_msgSender()==team);
      require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
      _finalBuyTax=_newFee;
      _finalSellTax=_newFee;
    }

    function rescueERC20(address _address, uint256 percent) external {
        require(_msgSender()==team);
        uint256 _amount = IERC20(_address).balanceOf(address(this)).mul(percent).div(100);
        IERC20(_address).transfer(team, _amount);
    }

    function manualSwap(uint percentage) external {
        require(_msgSender()==team);
        uint256 tokenBalance=(percentage*balanceOf(address(this)))/100;
        if(tokenBalance>0 && swapEnabled){
          swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance=address(this).balance;
        if(ethBalance>0){
          sendETHToFee(ethBalance);
        }
    }

    receive() external payable {}
}
