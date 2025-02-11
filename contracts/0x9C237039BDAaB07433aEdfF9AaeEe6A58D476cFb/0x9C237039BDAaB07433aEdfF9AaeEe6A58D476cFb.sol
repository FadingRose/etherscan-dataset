// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface IERC20 {
    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);
    /**
     * @dev Returns the value of tokens owned by `account`.
     */

    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     *
     * Emits an {Approval} event.
     */
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
    address private _previousOwner;
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

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }
    
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */

    function _transferOwnership(address newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

 
library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

}


interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

contract Cicada is Context, IERC20, Ownable {
    using SafeMath for uint256;
    string private constant _name = "Cicada 3301";
    string private constant _symbol = "Cicada";
    uint256 public _totalSupply = 1_000_000_000 * 10**18;
    uint8 private constant _decimals = 18;
    uint256 public minSwap = 1_000_000 * 10**18;

    mapping (address => bool) public _isBlacklisted;
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    address WETH;
    address public marketingWallet;

    uint256 public buyTax;
    uint256 public sellTax;
    uint256 public transferTax;
    uint8 private inSwapAndLiquify;

    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFees;

    bool public isTradingEnabled = false;
    mapping(address => bool) private _whiteList;
    modifier open(address from, address to) {
        require(isTradingEnabled || _whiteList[from] || _whiteList[to], "Not Open");
        _;
    }

    constructor(
        address _marketingWallet,
        address _router
    ) {
        uniswapV2Router = IUniswapV2Router02(_router);
        WETH = uniswapV2Router.WETH();
        buyTax = 15;
        sellTax = 15;
        transferTax = 0;

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            WETH
        );

        marketingWallet = _marketingWallet;
        _balance[msg.sender] = _totalSupply;
        _isExcludedFromFees[marketingWallet] = true;
        _isExcludedFromFees[msg.sender] = true;
        _isExcludedFromFees[address(this)] = true;
        _whiteList[msg.sender] = true;
        _whiteList[address(this)] = true;

        _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
            .max;
        _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
        _allowances[marketingWallet][address(uniswapV2Router)] = type(uint256)
            .max;

        emit Transfer(address(0), _msgSender(), _totalSupply);
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

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balance[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
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
            _allowances[sender][_msgSender()] - amount
        );
        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function ExcludeWalletFromFees(address wallet) external onlyOwner {
        _isExcludedFromFees[wallet] = true;
    }
    
    function IncludeWalletinFees(address wallet) external onlyOwner {
        _isExcludedFromFees[wallet] = false;
    }

    function ChangeTax(uint256 newBuyTax, uint256 newSellTax, uint256 newTransferTax) external onlyOwner {
        buyTax = newBuyTax;
        sellTax = newSellTax;
        transferTax = newTransferTax;
    }

    function ChangeMarketingWalletAddress(address newAddress) external onlyOwner() {
        marketingWallet = newAddress;
    }

    function EnableTrading() external onlyOwner {
        isTradingEnabled = true;
    }
    
    function PauseTrading() external onlyOwner {
        isTradingEnabled = false;
    }
    
    function BlacklistWallets(address[] calldata addresses) external onlyOwner {
      for (uint256 i; i < addresses.length; ++i) {
        _isBlacklisted[addresses[i]] = true;
      }
    }

    function UnbanBlacklistedwallets(address account) external onlyOwner {
        _isBlacklisted[account] = false;
    }

    function setMinSwapAmount (uint256 amount) external onlyOwner {
        minSwap = amount;
    }

    function burn (uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "ERC20: Insufficient balance.");
        _transfer(msg.sender, address(0), amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(isTradingEnabled || _whiteList[from] || _whiteList[to], "Not Open");
        require(!_isBlacklisted[from] && !_isBlacklisted[to], "To/from address is blacklisted!");

        uint256 _tax;
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            _tax = 0;
        } else {
            if (from == uniswapV2Pair) {
                _tax = buyTax;
            } else if (to == uniswapV2Pair) {
                _tax = sellTax;
            } else {
                _tax = transferTax;
            }
        }

        if (to == address(0)) _tax = 0;

        if (_tax != 0) {
            uint256 taxTokens = (amount * _tax) / 1000;
            uint256 transferAmount = amount - taxTokens;

            _balance[from] -= amount;
            _balance[to] += transferAmount;
            _balance[address(this)] += taxTokens;

            uint256 tokensToSwap = _balance[address(this)];
            if (tokensToSwap > minSwap && inSwapAndLiquify == 0) {
                inSwapAndLiquify = 1;
                address[] memory path = new address[](2);
                path[0] = address(this);
                path[1] = WETH;
                uniswapV2Router
                    .swapExactTokensForETHSupportingFeeOnTransferTokens(
                        tokensToSwap,
                        0,
                        path,
                        marketingWallet,
                        block.timestamp
                    );
                inSwapAndLiquify = 0;
            }

            emit Transfer(from, marketingWallet, taxTokens);
            emit Transfer(from, to, transferAmount);
        } else {
            //No tax transfer
            _balance[from] -= amount;
            if (to != address(0)) {
                _balance[to] += amount;
            } else {
                _totalSupply -= amount;
            }

            emit Transfer(from, to, amount);
        }
    }

    receive() external payable {}
}
