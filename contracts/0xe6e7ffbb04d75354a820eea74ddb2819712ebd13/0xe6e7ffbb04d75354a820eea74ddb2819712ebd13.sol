/**

OLYMPINK

 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IERC20 {


    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

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

contract Ownable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(msg.sender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Caller not the owner");
        _;
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract ERC20 is IERC20, Ownable {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 private _totalSupply;
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        decimals = 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address account
    ) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public virtual override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(
            currentAllowance >= amount,
            "Transfer amount exceeds allowance"
        );
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, currentAllowance - amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(
            sender != address(0),
            "Transfer from the zero address"
        );
        require(
            recipient != address(0),
            "Transfer to the zero address"
        );

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "Transfer amount exceeds balance"
        );
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(
            owner != address(0),
            "Approve from the zero address"
        );
        require(
            spender != address(0),
            "Approve to the zero address"
        );

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "Minting to the zero address");
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(
            account != address(0),
            "Burn from the zero address"
        );
        uint256 accountBalance = _balances[account];
        require(
            accountBalance >= amount,
            "Burn amount exceeds balance"
        );
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }
}
interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Pair {
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;
    function sync() external;
}

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);
}

contract Olympink is ERC20 {
    bool taxes = true;
    uint256 maxWalletSize = 5000000000 * 10 ** decimals; //5% Max Wallet
    IUniswapV2Router02 private uniswapRouter;
    address private taxWallet;
    address public uniswapPair;

    constructor() ERC20("Olympink", "OLYMPINK") {
        _mint(msg.sender, 100000000000 * 10 ** decimals); //100 Billion Minted
        taxWallet = 0xf28c6140e5C2235d3bBBF4f8e150E2cc983139cE;
        uniswapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override whenTransferEnabled {
        uint24 taxRate = getTaxRate();
        uint256 taxAmount = 0;
        if (
            recipient == address(this) ||
            sender == address(this) ||
            recipient == taxWallet ||
            sender == taxWallet
        ) {
            taxAmount = 0;
        } else if (sender == uniswapPair && taxRate > 0) {
            taxAmount = (amount * taxRate) / 10000;
            _ethSpent += getWETHSpent(amount);
        }
        uint256 amountAfterTaxes = amount - taxAmount;
        if (taxRate > 0) {
            require(
                recipient == address(this) ||
                recipient == address(uniswapPair) ||
                recipient == address(uniswapRouter) ||
                sender == address(this) ||
                recipient == taxWallet ||
                _balances[recipient] + amountAfterTaxes <= maxWalletSize,
                "Balance exceeds max wallet size"
            );  // Max Wallet goes away after taxes go away
        }
        super._transfer(sender, recipient, amountAfterTaxes);
        if (taxAmount > 0) {
            super._transfer(sender, address(this), taxAmount);
        }
        if (
            recipient != uniswapPair &&
            sender != uniswapPair &&
            recipient != address(this) &&
            shouldSwapAndSendTax()
        ) {
            swapTaxes();
        }
    }

    function getTaxRate() public view returns (uint24) {
        if (taxes == false) {
            return 0;
        } else if (_ethSpent < 3 ether) {
            return 4800;
        } else if (_ethSpent < 9 ether) {
            return 2400;
        } else if (_ethSpent < 17 ether) {
            return 1800;
        } else if (_ethSpent < 23 ether) {
            return 1300;
        } else if (_ethSpent < 27 ether) {
            return 900;
        } else if (_ethSpent < 33 ether) {
            return 700;
        } else {
            return 0;
        }
    }

    function taxSwitch() external onlyOwner {
        if (taxes == true) {
            taxes = false;
        } else {
            taxes = true;
        }
    }

    function getWETHSpent(
        uint256 tokenAmount
    ) internal view returns (uint256 wethSpent) {
        (uint256 reserveA, uint256 reserveB, ) = IUniswapV2Pair(uniswapPair)
            .getReserves();

        if (IUniswapV2Pair(uniswapPair).token0() == address(this)) {
            uint amountInWithFee = tokenAmount * 997;
            uint numerator = amountInWithFee * reserveB;
            uint denominator = (reserveA * 1000) + amountInWithFee;
            wethSpent = numerator / denominator;
        } else {
            uint amountInWithFee = tokenAmount * 997;
            uint numerator = amountInWithFee * reserveA;
            uint denominator = (reserveB * 1000) + amountInWithFee;
            wethSpent = numerator / denominator;
        }
    }

    function addLiquidity() external onlyOwner {
        require(!transferEnabled, "Transfer already enabled");
        IUniswapV2Factory factory = IUniswapV2Factory(uniswapRouter.factory());
        if (factory.getPair(address(this), uniswapRouter.WETH()) != address(0)) {
            uniswapPair = factory.getPair(address(this), uniswapRouter.WETH());
        } else {
            uniswapPair = factory.createPair(address(this), uniswapRouter.WETH());
        }
        _approve(address(this), address(uniswapRouter), totalSupply());
        uniswapRouter.addLiquidityETH{value: address(this).balance}(
            address(this),
            balanceOf(address(this)),
            0,
            0,
            owner(),
            block.timestamp
        );
        IERC20(uniswapPair).approve(address(uniswapRouter), type(uint).max);
        transferEnabled = true;
    }

    function swapTaxes() internal {
        _inSwap = true;
        uint256 currentBlock = block.number;
        lastBlockSwaps[currentBlock]++;
        uint256 tokenAmount = balanceOf(address(this));
        uint256 maxSell = _getTaxTxLimit();
        if (tokenAmount > maxSell) {
            tokenAmount = maxSell;
        }
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapRouter.WETH();
        _approve(address(this), address(uniswapRouter), tokenAmount);
        uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            taxWallet,
            block.timestamp
        );
        _inSwap = false;
    }

    function rescueETH() external {
        require(msg.sender == taxWallet, "Only tax wallet can rescue ETH");
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to rescue");
        payable(taxWallet).transfer(balance);
        emit RescueFunds(address(0), balance);
    }

    function rescueTokens(address tokenAddress) external {
        require(msg.sender == taxWallet, "Only tax wallet can rescue tokens");
        IERC20 token = IERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No tokens to rescue");
        token.transfer(taxWallet, balance);
        emit RescueFunds(tokenAddress, balance);
    }

    function manualSwap() external {
        require(
            msg.sender == taxWallet,
            "Only tax wallet can manual swap taxes"
        );
        require(
            balanceOf(address(this)) > 0,
            "Swap amount must be greater than zero"
        );
        swapTaxes();
    }

    modifier whenTransferEnabled() {
        require(
            transferEnabled ||
                msg.sender == owner() ||
                msg.sender == address(this) ||
                msg.sender == address(uniswapRouter),
            "Transfer is disabled"
        );
        _;
    }
    function shouldSwapAndSendTax() internal view returns (bool) {
        uint256 txLimit = _getTaxTxLimit();
        uint256 taxBalance = balanceOf(address(this));
        uint256 taxRate = getTaxRate();
        if (taxRate == 2300 && taxBalance > 0 && _inSwap == false) {
            return true;
        } else if (
            taxBalance >= txLimit &&
            taxRate > 0 &&
            lastBlockSwaps[block.number] < 2 &&
            _inSwap == false
        ) {
            return true;
        } else if (
            taxBalance > 0 &&
            taxRate == 0 &&
            lastBlockSwaps[block.number] < 2 &&
            _inSwap == false
        ) {
            return true;
        }
        return false;
    }
    function _getTaxTxLimit() internal view returns (uint256 txLimit) {
        uint256 _totalSupply = totalSupply();
        uint256 taxRate = getTaxRate();
        if (taxRate >= 1500) {
            txLimit = (maxWalletSize) / (20);
        } else if (taxRate > 0) {
            txLimit = (maxWalletSize) / (10);
        } else {
            txLimit = (_totalSupply);
        }
    }

    function renounceOwnership() public onlyOwner {
        _transferOwnership(address(0));
    }

    event TransferStatusChanged(bool enabled);
    event RescueFunds(address token, uint256 amount);
    bool private transferEnabled;
    bool private _inSwap;
    uint256 private _ethSpent;
    mapping(uint256 => uint256) private lastBlockSwaps;
    receive() external payable {}
    fallback() external payable {}
}
