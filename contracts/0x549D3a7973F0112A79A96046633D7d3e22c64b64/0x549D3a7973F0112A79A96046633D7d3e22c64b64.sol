// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

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

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
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
}

contract Bajs is Context, IERC20, Ownable {
    using Address for address;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFee;

    address payable private _taxWallet;
    address private _router;

    uint256 private _initialBuyTax = 25;
    uint256 private _initialSellTax = 35;
    uint256 private _finalBuyTax = 0;
    uint256 private _finalSellTax = 0;
    uint256 private _reduceBuyTaxAt = 100;
    uint256 private _reduceSellTaxAt = 115;
    uint256 private _preventSwapBefore = 3;
    uint256 private _transferTax = 0;
    uint256 private _buyCount = 0;

    uint8 private constant _decimals = 9;
    uint256 private constant _tTotal = 1_000_000_000 * 10 ** _decimals;
    string private constant _name = "BAJS";
    string private constant _symbol = "BAJS";
    uint256 public _maxTxAmount = (_tTotal * 2) / 100;
    uint256 public _maxWalletSize = (_tTotal * 2) / 100;
    uint256 public _taxSwapThreshold = (_tTotal * 1) / 100;
    uint256 public _maxTaxSwap = (_tTotal * 1) / 100;

    IUniswapV2Router02 private uniswapV2Router;
    address public uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;
    uint256 private sellCount = 0;
    uint256 private lastSellBlock = 0;
    uint256 private firstBlock = 0;

    event MaxTxAmountUpdated(uint _maxTxAmount);
    event TransferTaxUpdated(uint _tax);
    event ClearToken(address tokenAddressCleared, uint256 amount);

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    modifier whenTradingEnabled(address from, address to) {
        if (from != owner() && to != owner()) {
            require(tradingOpen, "Trading is not yet enabled");
        }
        _;
    }

    constructor(address routerAddress) {
        _taxWallet = payable(_msgSender());
        _balances[_msgSender()] = _tTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet] = true;
        _router = routerAddress;
        uniswapV2Router = IUniswapV2Router02(routerAddress);

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
    )
        public
        override
        whenTradingEnabled(_msgSender(), recipient)
        returns (bool)
    {
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
    ) public override whenTradingEnabled(sender, recipient) returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()] - amount
        );
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private whenTradingEnabled(from, to) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        uint256 taxAmount = 0;
        if (from != owner() && to != owner()) {
            if (
                from == uniswapV2Pair &&
                to != address(uniswapV2Router) &&
                !_isExcludedFromFee[to]
            ) {
                // Buy transaction
                require(amount <= _maxTxAmount, "Exceeds the maxTxAmount.");
                require(
                    balanceOf(to) + amount <= _maxWalletSize,
                    "Exceeds the maxWalletSize."
                );
                taxAmount = (amount * getBuyTax()) / 100;
                _buyCount++;
            } else if (to == uniswapV2Pair && from != address(this)) {
                // Sell transaction
                taxAmount = (amount * getSellTax()) / 100;
            }

            uint256 contractTokenBalance = _balances[address(this)];
            if (
                !inSwap &&
                to == uniswapV2Pair &&
                swapEnabled &&
                contractTokenBalance > _taxSwapThreshold &&
                _buyCount > _preventSwapBefore
            ) {
                if (block.number > lastSellBlock) {
                    sellCount = 0;
                }
                require(sellCount < 3, "Only 3 sells per block!");

                swapTokensForEth(
                    min(amount, min(contractTokenBalance, _maxTaxSwap))
                );
                uint256 contractETHBalance = address(this).balance;
                if (contractETHBalance > 0) {
                    sendETHToFee(contractETHBalance);
                }

                sellCount++;
                lastSellBlock = block.number;
            }
        }

        if (taxAmount > 0) {
            _balances[address(this)] += taxAmount;
            emit Transfer(from, address(this), taxAmount);
        }

        _balances[from] -= amount;
        _balances[to] += (amount - taxAmount);
        emit Transfer(from, to, amount - taxAmount);
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return (a < b) ? a : b;
    }

    function getBuyTax() private view returns (uint256) {
        if (_buyCount >= 160) {
            return 0;
        } else if (_buyCount >= 145) {
            return 5;
        } else if (_buyCount >= 130) {
            return 10;
        } else if (_buyCount >= 115) {
            return 15;
        } else {
            return _initialBuyTax;
        }
    }

    function getSellTax() private view returns (uint256) {
        if (_buyCount >= 190) {
            return 0;
        } else if (_buyCount >= 175) {
            return 5;
        } else if (_buyCount >= 160) {
            return 15;
        } else if (_buyCount >= 145) {
            return 20;
        } else {
            return _initialSellTax;
        }
    }

    function setTaxRates(
        uint256 initialBuyTax,
        uint256 initialSellTax,
        uint256 finalBuyTax,
        uint256 finalSellTax,
        uint256 reduceBuyTaxAt,
        uint256 reduceSellTaxAt
    ) external onlyOwner {
        require(initialBuyTax <= 25, "Initial buy tax cannot exceed 25%");
        require(initialSellTax <= 35, "Initial sell tax cannot exceed 35%");
        require(finalBuyTax <= 25, "Final buy tax cannot exceed 25%");
        require(finalSellTax <= 35, "Final sell tax cannot exceed 35%");

        _initialBuyTax = initialBuyTax;
        _initialSellTax = initialSellTax;
        _finalBuyTax = finalBuyTax;
        _finalSellTax = finalSellTax;
        _reduceBuyTaxAt = reduceBuyTaxAt;
        _reduceSellTaxAt = reduceSellTaxAt;
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
        _maxWalletSize = _tTotal;
        emit MaxTxAmountUpdated(_tTotal);
    }

    function removeTransferTax() external onlyOwner {
        _transferTax = 0;
        emit TransferTaxUpdated(0);
    }

    function sendETHToFee(uint256 amount) private {
        _taxWallet.transfer(amount);
    }

    function enableTrading() external onlyOwner {
        require(!tradingOpen, "Trading is already open");
        swapEnabled = true;
        tradingOpen = true;
        firstBlock = block.number;
    }

    function isTradingOpen() external view returns (bool) {
        return tradingOpen;
    }

    receive() external payable {}

    function reduceFee(uint256 _newFee) external {
        require(_msgSender() == _taxWallet);
        require(_newFee <= _finalBuyTax && _newFee <= _finalSellTax);

        _finalBuyTax = _newFee;
        _finalSellTax = _newFee;
    }

    function withdrawETH(uint256 amount) external {
        require(_msgSender() == _taxWallet, "Unauthorized");
        require(address(this).balance >= amount, "Insufficient ETH balance");

        payable(_taxWallet).transfer(amount);
    }

    function clearStuckToken(
        address tokenAddress,
        uint256 tokens
    ) external returns (bool success) {
        require(_msgSender() == _taxWallet);

        if (tokens == 0) {
            tokens = IERC20(tokenAddress).balanceOf(address(this));
        }

        emit ClearToken(tokenAddress, tokens);
        return IERC20(tokenAddress).transfer(_taxWallet, tokens);
    }

    function manualSend() external {
        require(_msgSender() == _taxWallet);

        uint256 ethBalance = address(this).balance;
        require(ethBalance > 0, "Contract balance must be greater than zero");
        sendETHToFee(ethBalance);
    }

    function manualSwap() external {
        require(_msgSender() == _taxWallet);

        uint256 tokenBalance = _balances[address(this)];
        if (tokenBalance > 0) {
            swapTokensForEth(tokenBalance);
        }

        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            sendETHToFee(ethBalance);
        }
    }

    function setTaxWallet(address newTaxWallet) external onlyOwner {
        require(
            newTaxWallet != address(0),
            "New tax wallet is the zero address"
        );
        _taxWallet = payable(newTaxWallet);
    }

    function setRouterAddress(address newRouter) external onlyOwner {
        _router = newRouter;
    }
}
