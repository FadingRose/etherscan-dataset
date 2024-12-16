//SPDX-License-Identifier: MIT
//Socials <<

pragma solidity 0.8.19;

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

interface IUniswapV2Router01 {
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

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
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

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

library Address {
    function sendValue(
        address payable recipient,
        uint256 amount
    ) internal returns (bool) {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        return success; // always proceeds
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
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

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 9;
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
        _transfer(_msgSender(), recipient, amount);
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
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: transfer amount exceeds allowance"
            );
            unchecked {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }

        _transfer(sender, recipient, amount);

        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

contract CASHSHEEPKING is ERC20, Ownable {
    using Address for address payable;

IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    mapping(address => bool) private _isExcludedFromFees;

    address public marketingFeeReceiver;
    uint256 public swapTokensAtAmount;
    uint256 public tradingEnabledTime;

    bool private inSwapAndLiquify;
    bool public swapEnabled;

    uint256 public marketingFeeInitial;
    uint256 public liquidityFeeInitial;

    uint256 public marketingFeeAfter5Minutes;
    uint256 public liquidityFeeAfter5Min;

    uint256 public marketingFeeAfter10Min;
    uint256 public liquidityFeeAfter10Min;

    uint256 public finalMarketingFee;
    uint256 public liquidityFeeAfter15Min;

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event SwapAndSendFee(uint256 tokensSwapped, uint256 bnbSend);
    event SwapTokensAtAmountUpdated(uint256 swapTokensAtAmount);
    event MarketingFeeReceiverChanged(address marketingFeeReceiver);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 bnbReceived,
        uint256 tokensIntoLiqudity
    );
    event ToggleSwapping(bool swapEnabled);

    constructor(address _router, address _feeReceiver) ERC20("CASHSHEEPKING", "CASHEKI") { //uniswapv2router address, feereceiving wallet, Tokenname, symbol

        marketingFeeInitial = 50;

        marketingFeeAfter5Minutes = 25;
        
        marketingFeeAfter10Min = 12;
        
        finalMarketingFee = 5;

        marketingFeeReceiver = _feeReceiver;
        uniswapV2Router = IUniswapV2Router02(_router);

        //Excluding wallets from fees
        _isExcludedFromFees[owner()] = true;
        _isExcludedFromFees[address(0xdead)] = true;
        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[marketingFeeReceiver] = true;

        _mint(owner(), 100_000_000 * (10 ** decimals()));

        swapTokensAtAmount = totalSupply() / 5_000;

        swapEnabled = false;
    }

    receive() external payable {}

    function claimStuckTokens(address token) external onlyOwner {
        require(
            token != address(this),
            "Owner cannot claim contract's balance of its own tokens"
        );
        if (token == address(0x0)) {
            payable(msg.sender).sendValue(address(this).balance);
            return;
        }

        IERC20(token).transfer(
            msg.sender,
            IERC20(token).balanceOf(address(this))
        );
    }

    function excludeFromFees(
        address account,
        bool excluded
    ) external onlyOwner {
        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function changeFeeReceiver(
        address _marketingFeeReceiver
    ) external onlyOwner {
        require(
            _marketingFeeReceiver != address(0) &&
            _marketingFeeReceiver != address(0xdead),
            "Marketing Fee receiver cannot be the zero or dead address"
        );
        marketingFeeReceiver = _marketingFeeReceiver;

        emit MarketingFeeReceiverChanged(marketingFeeReceiver);
    }

    event TradingEnabled(bool tradingEnabled, uint256 tradingEnabledTime);

    bool public tradingEnabled;

    function enableTrading() external onlyOwner {
        require(!tradingEnabled, "Trading already enabled.");
        _approve(address(this), address(uniswapV2Router), type(uint256).max);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        tradingEnabled = true;
        swapEnabled = true;
        tradingEnabledTime = block.timestamp;

        emit TradingEnabled(tradingEnabled, tradingEnabledTime);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "Transfer from the zero address");
        require(to != address(0), "Transfer to the zero address");
        require(
            tradingEnabled 
                || _isExcludedFromFees[from] 
                || _isExcludedFromFees[to],
            "Trading not yet enabled!"
        );

        uint256 marketingFee = 0;

        if (block.timestamp >= tradingEnabledTime + 15 minutes) {
            marketingFee = finalMarketingFee;
        } else if (block.timestamp >= tradingEnabledTime + 10 minutes) {
            marketingFee = marketingFeeAfter10Min;
        } else if (block.timestamp >= tradingEnabledTime + 5 minutes) {
            marketingFee = marketingFeeAfter5Minutes;
        } else {
            marketingFee = marketingFeeInitial;
        }

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        uint256 contractTokenBalance = balanceOf(address(this));
        bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;

        if (overMinTokenBalance && !inSwapAndLiquify && to == uniswapV2Pair && swapEnabled && marketingFee >0) {
            inSwapAndLiquify = true;

            swapAndSendMarketing(contractTokenBalance);
            
            inSwapAndLiquify = false;
        }

        uint256 _totalFees;
        if (_isExcludedFromFees[from] && _isExcludedFromFees[to] && inSwapAndLiquify) {
            _totalFees = 0;
        } else if (from == uniswapV2Pair || to == uniswapV2Pair && tradingEnabled) {
            _totalFees = marketingFee;
        } else {
            _totalFees = 0;
        }

        if (_totalFees > 0) {
            uint256 fees = (amount * _totalFees) / 100;
            amount = amount - fees;
            super._transfer(from, address(this), fees);
        }

        super._transfer(from, to, amount);
    }

    function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
        require(
            newAmount > totalSupply() / 1_000_000,
            "SwapTokensAtAmount must be greater than 0.0001% of total supply"
        );
        swapTokensAtAmount = newAmount;

        emit SwapTokensAtAmountUpdated(swapTokensAtAmount);
    }

    function toggleSwapping(bool _swapEnabled) external onlyOwner {
        require(swapEnabled != _swapEnabled, "Currently at the same stage");
        swapEnabled = _swapEnabled;
        emit ToggleSwapping(swapEnabled);
    }

    function swapAndSendMarketing(uint256 tokenAmount) private {
        uint256 initialBalance = address(this).balance;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        ) {} catch {}

        uint256 newBalance = address(this).balance - initialBalance;

        payable(marketingFeeReceiver).sendValue(newBalance);

        emit SwapAndSendFee(tokenAmount, newBalance);
    }
}
