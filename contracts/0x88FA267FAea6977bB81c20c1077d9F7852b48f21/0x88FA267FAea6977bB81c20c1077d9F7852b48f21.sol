// SPDX-License-Identifier: MIT
/*
    Twitter : https://x.com/neirochaneth

    Website : https://neirochan.live

    Telegram : https://t.me/NeiroChanErc20

*/
pragma solidity ^0.8.24;
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Invalid owner");
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "New owner is ZERO");
        _transferOwnership(newOwner);
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint256) external view returns (address pair);
    function allPairsLength() external view returns (uint256);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (
        uint112 reserve0,
        uint112 reserve1,
        uint32 blockTimestampLast
    );

    function price0CumulativeLast() external view returns (uint256);
    function price1CumulativeLast() external view returns (uint256);
    function kLast() external view returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
    function burn(address to) external returns (uint256 amount0, uint256 amount1);
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}


contract ERC20 is IERC20, Context {
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

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
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: Not owner != address(0)");
        require(spender != address(0), "ERC20: Not spender != address(0)");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        _transfer(from, to, amount);
        uint256 curAllow = _allowances[from][_msgSender()];
        require(curAllow >= amount, "ERC20: Not curAllow >= amount");
        unchecked {
            _approve(from, _msgSender(), curAllow - amount);
        }
        return true;
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subValue) public virtual returns (bool) {
        uint256 curAllow = _allowances[_msgSender()][spender];
        require(curAllow >= subValue, "ERC20: Not curAllow >= subValue");
        unchecked {
            _approve(_msgSender(), spender, curAllow - subValue);
        }
        return true;
    }

    function _mint(
    	address account,
	    uint256 amount
    ) internal virtual {
        require(account != address(0), "ERC20: Not account != address(0)");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(
    	address account,
	    uint256 amount
    ) internal virtual {
        require(account != address(0), "ERC20: Not account != address(0)");
        _beforeTokenTransfer(account, address(0), amount);
        uint256 kBalance = _balances[account];
        require(kBalance >= amount, "ERC20: kBalance >= amount");
        unchecked {
            _balances[account] = kBalance - amount;
        }
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount) internal virtual {
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: Not from != address(0)");
        require(to != address(0), "ERC20: Not to != address(0)");
        _beforeTokenTransfer(from, to, amount);
        uint256 balanceFrom = _balances[from];
        require(balanceFrom >= amount, "ERC20: Not balanceFrom >= amount");
        unchecked {
            _balances[from] = balanceFrom - amount;
        }
        _balances[to] += amount;
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount) internal virtual {
        // Nothing
    }
}

contract NeiroChanERC is ERC20, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 public swapRouter;
    address public swapPair;
    
    uint256 public minSwapTokenAmount;
    uint256 public maxTokenAmountPerWallet;
    uint256 public maxTokenAmountPerTxn;

    bool public TradingActive = false;
    uint256 public ActiveTradingBlock;
    uint256 public PreventSwapbackBlocks;
    bool public SwapEnabled = false;

    address public marketingWallet;
    address public devWallet;

    uint256 public tokenAmountForMarketing;
    uint256 public tokenAmountForDev;

    mapping(address => bool) public ExcludedMaxTokenAmountPerTxn;

    mapping(address => bool) public ExcludedFromTax;

    mapping(address => bool) public automatedMarketMakerPairs;

    bool public limitsInEffect = true;

    uint256 public sellTotalTax;
    uint256 public sellMarketingTax;
    uint256 public sellDevTax;

    uint256 public buyTotalTax;
    uint256 public buyMarketingTax;
    uint256 public buyDevTax;

    
    bool private Swapping;
    mapping(address => bool) private blackList;
    
    constructor() ERC20("Neiro-chan", "Neiro") {
        devWallet = address(msg.sender);
        marketingWallet = address(msg.sender);


        swapRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        swapPair = IUniswapV2Factory(swapRouter.factory()).createPair(address(this), swapRouter.WETH());

        ExcludedMaxTokenAmountPerTxn[owner()] = true;
        ExcludedMaxTokenAmountPerTxn[address(this)] = true;

        uint256 totalSupply = 1_000_000_000 * (10 ** decimals());
        minSwapTokenAmount = 2_500_000 * (10 ** decimals()); //0.25% min swap
        maxTokenAmountPerTxn = 20_000_000 * (10 ** decimals()); //2% max tx amount
        maxTokenAmountPerWallet = 20_000_000 * (10 ** decimals()); //2% max wallet amount
        ExcludedFromTax[address(this)] = true;
        ExcludedFromTax[owner()] = true;


        automatedMarketMakerPairs[address(swapPair)] = true;
        
        ExcludedMaxTokenAmountPerTxn[address(0xdead)] = true;
        ExcludedMaxTokenAmountPerTxn[address(swapRouter)] = true;
        ExcludedMaxTokenAmountPerTxn[address(swapPair)] = true;

        ExcludedFromTax[address(0xdead)] = true;

        sellMarketingTax = 50;
        sellDevTax = 0;
        sellTotalTax = sellMarketingTax + sellDevTax;


        buyMarketingTax = 25;
        buyDevTax = 0;
        buyTotalTax = buyMarketingTax + buyDevTax;

        PreventSwapbackBlocks=3; //default
        _mint(msg.sender, totalSupply);
    }

    function startTrading() external onlyOwner {
        TradingActive = true;
        SwapEnabled = true;
        ActiveTradingBlock=block.number;
    }
    function updatePrecentSwapbackBlocks(uint256 newNum) external onlyOwner{
        PreventSwapbackBlocks=newNum;
    }
    function excludeFromMaxTokenAmountPerTxn(address addr, bool value) external onlyOwner {
        ExcludedMaxTokenAmountPerTxn[addr] = value;
    }
    function excludeFromTax(address account, bool value) external onlyOwner {    	
        ExcludedFromTax[account] = value;
    }

    function removeLimits() external onlyOwner {
        limitsInEffect = false;
    }
    function updateSwapEnabled(bool enabled) external onlyOwner {
        SwapEnabled = enabled;
    }
    function updateMinimumSwapTokenAmount(uint256 amount) external onlyOwner {
        require(amount >= (totalSupply() * 1) / 100000, "Swap amount cannot be lower than 0.001% total supply.");
        require(amount <= (totalSupply() * 5) / 1000, "Swap amount cannot be higher than 0.5% total supply.");
        minSwapTokenAmount = amount;
    }
    function updateMaxTokensPerWallet(uint256 newNum) external onlyOwner {
        require(newNum >= ((totalSupply() * 5) / 1000) / (10 ** decimals()), "Cannot set maxTokenAmountPerWallet lower than 0.5%");
        maxTokenAmountPerWallet = newNum * (10 ** decimals());
    }
    function updateMaxTokenAmountPerTxn(uint256 newNum) external onlyOwner {
        require(newNum >= ((totalSupply() * 1) / 1000) / (10 ** decimals()), "Cannot set maxTokenAmountPerTxn lower than 0.1%");
        maxTokenAmountPerTxn = newNum * (10 ** decimals());
    }
    function BlackListWallet(address addr, bool enable) external onlyOwner {
        blackList[addr] = enable;
    }
    function BulkBlackList(address[] memory _addr, bool enable) external onlyOwner {
        for (uint256 i=0; i <= _addr.length-1; i++) {
            blackList[_addr[i]] = enable;
        }
    }
    function _updateBuyTax(uint256 newMarketFee, uint256 newDevFee) external onlyOwner {
        buyMarketingTax = newMarketFee;
        buyDevTax = newDevFee;
        buyTotalTax = buyMarketingTax + buyDevTax;
        require(buyTotalTax <= 50, "Must keep tax at 50% or less");
    }

    function _updateSellTax(uint256 newMarketFee, uint256 newDevFee) external onlyOwner {
        sellMarketingTax = newMarketFee;
        sellDevTax = newDevFee;
        sellTotalTax = sellMarketingTax + sellDevTax;
        require(sellTotalTax <= 99, "Must keep tax at 95% or less");
    }
    function setMarketingFees(uint256 _buy, uint256 _sell) external onlyOwner {
        buyMarketingTax = _buy;
        buyTotalTax = buyMarketingTax + buyDevTax;
        sellMarketingTax = _sell;
        sellTotalTax = sellMarketingTax + sellDevTax;
    }
    function setAutomatedMarketMakerPairs(address pair, bool value)
        external onlyOwner {
        require(pair != swapPair, "The pair cannot be removed from automatedMarketMakerPairs");
        automatedMarketMakerPairs[pair] = value;
    }
    function swapBack() private {
        bool success;
        uint256 tokenAmountToSwap = tokenAmountForMarketing + tokenAmountForDev;
        uint256 tokenBalance = balanceOf(address(this));
        if (tokenAmountToSwap == 0 || tokenBalance == 0)
            return;

        uint256 prevETHBalance = address(this).balance;
        swapTokensForEth(tokenBalance);

        uint256 ethBalance = address(this).balance.sub(prevETHBalance);
        uint256 ethForDev = ethBalance.mul(tokenAmountForDev).div(tokenAmountToSwap);

        (success, ) = address(devWallet).call{value: ethForDev}("");
        (success, ) = address(marketingWallet).call{ value: address(this).balance }("");

        tokenAmountForMarketing = 0;
        tokenAmountForDev = 0;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: Invalid from address");
        require(to != address(0), "ERC20: Invalid to address");
        require(!blackList[from], "ERC20: Sender is blacklisted");
        require(!blackList[to], "ERC20: Receiver is blacklisted");

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if (limitsInEffect) {
            if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !Swapping) {
                if (!TradingActive) {
                    require(ExcludedFromTax[from] || ExcludedFromTax[to], "Trading is not active.");
                }

                if (automatedMarketMakerPairs[from] && !ExcludedMaxTokenAmountPerTxn[to]) {
                    require(amount <= maxTokenAmountPerTxn, "Buy transfer amount exceeds the maxTokenAmountPerTxn.");
                    require(amount + balanceOf(to) <= maxTokenAmountPerWallet, "Max wallet exceeded");
                }
                else if (automatedMarketMakerPairs[to] && !ExcludedMaxTokenAmountPerTxn[from]) {
                    require(amount <= maxTokenAmountPerTxn, "Sell transfer amount exceeds the maxTokenAmountPerTxn.");
                }
                else if (!ExcludedMaxTokenAmountPerTxn[to]) {
                    require(amount + balanceOf(to) <= maxTokenAmountPerWallet, "Max wallet exceeded");
                }
            }
        }
        uint256 tokenBalance = balanceOf(address(this));
        bool canSwap = tokenBalance >= minSwapTokenAmount;
        if (SwapEnabled 
            && canSwap 
            && !Swapping 
            && !automatedMarketMakerPairs[from] 
            && !ExcludedFromTax[from] 
            && !ExcludedFromTax[to]
            && ActiveTradingBlock+PreventSwapbackBlocks <= block.number
        ) {
            Swapping = true;
            swapBack();
            Swapping = false;
        }

        bool Tax = !Swapping;
        if (ExcludedFromTax[from] || ExcludedFromTax[to])
            Tax = false;

        uint256 fees = 0;
        if (Tax) {
            if (automatedMarketMakerPairs[to] && sellTotalTax > 0) {
                fees = amount.mul(sellTotalTax).div(100);
                tokenAmountForDev += (fees * sellDevTax) / sellTotalTax;
                tokenAmountForMarketing += (fees * sellMarketingTax) / sellTotalTax;
            }
            else if (automatedMarketMakerPairs[from] && buyTotalTax > 0) {
                fees = amount.mul(buyTotalTax).div(100);
                tokenAmountForDev += (fees * buyDevTax) / buyTotalTax;
                tokenAmountForMarketing += (fees * buyMarketingTax) / buyTotalTax;
            }
            if (fees > 0)
                super._transfer(from, address(this), fees);
            amount -= fees;
        }

        super._transfer(from, to, amount);
    }
    receive() external payable {}
    function swapTokensForEth(uint256 amount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = swapRouter.WETH();

        _approve(address(this), address(swapRouter), amount);

        // make the swap
        swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

}
