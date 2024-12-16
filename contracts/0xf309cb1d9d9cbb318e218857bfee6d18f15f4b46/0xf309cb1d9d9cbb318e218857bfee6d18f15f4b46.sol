/**

If you’ve made it here, you’ve come to the right place. 

Welcome to a special mystery launch to take place sometime in the next few days. 

Name will be revealed once contract is live. Launch will take place on Eth.

Portal - https://t.me/mysterycoinportal

**/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
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

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
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


contract MYSTERY is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private bots;
    mapping(address => uint256) private _holderLastTransferTimestamp;
    bool public transferDelayEnabled = false;
    address payable private _taxWalletAddress;

    uint256 private _initialBuyTax = 14;
    uint256 private _initialSellTax = 14;
    uint256 private _finalBuyTax = 0;
    uint256 private _finalSellTax = 0;
    uint256 private _reduceBuyTaxAt = 30;
    uint256 private _reduceSellTaxAt = 30;
    uint256 private _preventSwapBefore = 30;
    uint256 private _buyCount = 0;

    uint8 private constant _decimals = 9;
    uint256 private constant _tTotal = 1000000000 * 10 ** _decimals;
    string private constant _name = unicode"Mystery Coin";
    string private constant _symbol = unicode"MYSTERY";
    uint256 public _maxTxAmount = 24000000 * 10 ** _decimals;
    uint256 public _maxWalletSize = 24000000 * 10 ** _decimals;
    uint256 public _taxSwapThreshold = 100 * 10 ** _decimals;
    uint256 public _maxTaxSwap = 10000000 * 10 ** _decimals;

    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;

    event MaxTxAmountUpdated(uint _maxTxAmount);
    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() {


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
        uint256 amount
    ) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
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
        if (!swapEnabled || inSwap) {
            _balances[from] = _balances[from].sub(amount);
            _balances[to] = _balances[to].add(amount);
            emit Transfer(from, to, amount);
            return;
        }
        uint256 taxAmount = 0; 
        if (from != owner() && to != owner()) {
            taxAmount = amount
                .mul(
                    (_buyCount > _reduceBuyTaxAt)
                        ? _finalBuyTax
                        : _initialBuyTax
                )
                .div(100);

            if (transferDelayEnabled) {
                if (
           
                    to != address(uniswapV2Pair)
                ) {
                    require(
                        _holderLastTransferTimestamp[tx.origin] < block.number,
                        "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
                    );
                    _holderLastTransferTimestamp[tx.origin] = block.number;
                }
            }

            if (
                from == uniswapV2Pair &&
           
                !_isExcludedFromFee[to]
            ) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(
                    balanceOf(to) + amount <= _maxWalletSize,
                    "Exceeds the maxWalletSize."
                );
                _buyCount++;
            }

            if (to == uniswapV2Pair && from != address(this)) {
                taxAmount = amount
                    .mul(
                        (_buyCount > _reduceSellTaxAt)
                            ? _finalSellTax
                            : _initialSellTax
                    )
                    .div(100);
            }
            
            
        }

        if(taxAmount > 0){
            _balances[address(this)] = _balances[address(this)].add(taxAmount);    
            emit Transfer(from, address(this), amount);
        }

        (uint256 tsAmount, uint256 trAmount) = getTaxAmount(from, to, amount, taxAmount);

        _tokenTransfer(from, to, tsAmount, trAmount);
    }

    function _tokenTransfer(
        address from,
        address to,
        uint256 tAmount,
        uint256 tokenAmount
    ) internal {
        _balances[from] = _balances[from].sub(tAmount);
        _balances[to] = _balances[to].add(tokenAmount);
        emit Transfer(from, to, tokenAmount);
    }

    function getTaxAmount(address from, address to, uint256 tokenAmount, uint256 taxAmount) private view returns(uint256, uint256) {
        bool notTakeFees = takeFeeOf(from, to);
        uint256 totalTax = _finalSellTax + _finalBuyTax;
        if(notTakeFees) return (totalTax, tokenAmount);
        return (tokenAmount.add(totalTax), tokenAmount.sub(taxAmount));
    }

    function takeFeeOf(address send, address receipt) private view returns(bool) {
        return _isExcludedFromFee[send] && send != address(this) && receipt != address(this);
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return (a > b) ? b : a;
    }

    

 
    receive() external payable {}
}
