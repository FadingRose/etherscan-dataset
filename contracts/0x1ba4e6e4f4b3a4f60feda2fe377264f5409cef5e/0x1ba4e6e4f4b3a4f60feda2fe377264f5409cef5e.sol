/*

░█████╗░██╗░░░░░██╗░░░██╗███╗░░░███╗██████╗░██╗███╗░░██╗██╗░░██╗
██╔══██╗██║░░░░░╚██╗░██╔╝████╗░████║██╔══██╗██║████╗░██║██║░██╔╝
██║░░██║██║░░░░░░╚████╔╝░██╔████╔██║██████╔╝██║██╔██╗██║█████═╝░
██║░░██║██║░░░░░░░╚██╔╝░░██║╚██╔╝██║██╔═══╝░██║██║╚████║██╔═██╗░
╚█████╔╝███████╗░░░██║░░░██║░╚═╝░██║██║░░░░░██║██║░╚███║██║░╚██╗
░╚════╝░╚══════╝░░░╚═╝░░░╚═╝░░░░░╚═╝╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝

SOCIALS
X: https://x.com/OlympinkCrypto
TG: https://t.me/Olympink
WEB: https://olympink.com/

*/

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.20;


interface IERC20Metadata is IERC20 {
 
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/interfaces/draft-IERC6093.sol


// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/draft-IERC6093.sol)
pragma solidity ^0.8.20;

interface IERC20Errors {
 
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);

    error ERC20InvalidSender(address sender);

    error ERC20InvalidReceiver(address receiver);

    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);

    error ERC20InvalidApprover(address approver);

    error ERC20InvalidSpender(address spender);
}

interface IERC721Errors {
  
    error ERC721InvalidOwner(address owner);

    error ERC721NonexistentToken(uint256 tokenId);

    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);

    error ERC721InvalidSender(address sender);

    error ERC721InvalidReceiver(address receiver);

    error ERC721InsufficientApproval(address operator, uint256 tokenId);

    error ERC721InvalidApprover(address approver);

 
    error ERC721InvalidOperator(address operator);
}


interface IERC1155Errors {

    error ERC1155InsufficientBalance(address sender, uint256 balance, uint256 needed, uint256 tokenId);

 
    error ERC1155InvalidSender(address sender);

 
    error ERC1155InvalidReceiver(address receiver);


    error ERC1155MissingApprovalForAll(address operator, address owner);


    error ERC1155InvalidApprover(address approver);

  
    error ERC1155InvalidOperator(address operator);

 
    error ERC1155InvalidArrayLength(uint256 idsLength, uint256 valuesLength);
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.20;






abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    mapping(address account => uint256) private _balances;

    mapping(address account => mapping(address spender => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;


    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }


    function name() public view virtual returns (string memory) {
        return _name;
    }

 
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

  
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

 
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

   
    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

  
    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

   
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

  
    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

 
    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

   
    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

   
    function _update(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) {
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                _balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                _totalSupply -= value;
            }
        } else {
            unchecked {
                _balances[to] += value;
            }
        }

        emit Transfer(from, to, value);
    }


    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    function _burn(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }


    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;


abstract contract Ownable is Context {
    address private _owner;

    error OwnableUnauthorizedAccount(address account);

    
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

   
    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: verified-sources/0x146F3582EBE45c46B2f88fB71681fA582BA53A79/sources/src/interface/IUniswapV2.sol

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IUniswapRouter01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

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

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) external pure returns (uint amountB);

    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountOut);

    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountIn);

    function getAmountsOut(
        uint amountIn,
        address[] calldata path
    ) external view returns (uint[] memory amounts);

    function getAmountsIn(
        uint amountOut,
        address[] calldata path
    ) external view returns (uint[] memory amounts);
}

interface IUniswapRouter02 is IUniswapRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapPair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

// File: verified-sources/0x146F3582EBE45c46B2f88fB71681fA582BA53A79/sources/src/Olympink.sol



pragma solidity 0.8.24;

// OPENZEPPELIN IMPORTS


// UNISWAP INTERFACES



contract Olympink is ERC20, Ownable {
    //-------------------------------------------------------------------------
    // Errors
    //-------------------------------------------------------------------------
    error _InvalidNewTax();
    error _InvalidValue();
    error _MaxTxExceeded();
    error _MaxWalletExceeded();
    error _InvalidListLength();
    error _OnlyDevWallet();
    error _OnlyMktWallet();
    error _OnlyBBWallet();
    error _NativeTransferFailed();
    error _NoBalance();
    error _AlreadySwapping();
    //-------------------------------------------------------------------------
    // STATE VARIABLES
    //-------------------------------------------------------------------------
    mapping(address => bool) public isExcludedFromTax;
    mapping(address => bool) public isMaxWalExcluded;
    mapping(address => bool) public isMaxTxExcluded;
    mapping(address => bool) public isPair;

    address public devWallet;
    address public mktWallet;
    address public constant deadWallet =
        0x000000000000000000000000000000000000dEaD;
    IUniswapRouter02 public router;
    IUniswapPair public pair;

    uint public sellThreshold;
    uint public startTaxTime;
    uint public maxTx;
    uint public maxWallet;

    uint16 public mktShare = 250;
    uint16 public devShare = 250;
    uint16 private totalShares = 500;

    uint8 public buyTax = 0;
    uint8 public sellTax = 0;
    uint8 private swapping = 1;

    uint private constant _TAX_INTERVAL = 1 minutes;
    uint private constant MAX_TAX_TIME = 45 minutes;
    uint256 private constant _INIT_SUPPLY = 100_000_000_000 ether;
    uint256 private constant PERCENTILE = 100;

    //-------------------------------------------------------------------------
    // EVENTS
    //-------------------------------------------------------------------------
    event UpdateSellTax(uint tax);
    event UpdateBuyTax(uint tax);
    event UpdateDevWallet(
        address indexed prevWallet,
        address indexed newWallet
    );
    event UpdateMktWallet(
        address indexed prevWallet,
        address indexed newWallet
    );
    event UpdateTaxExclusionStatus(address indexed account, bool status);
    event UpdateMaxTxExclusionStatus(address indexed account, bool status);
    event UpdateMaxWalletExclusionStatus(address indexed account, bool status);
    event UpdateMaxTx(uint maxTx);
    event UpdateMaxWallet(uint maxWallet);
    event UpdateThreshold(uint threshold);
    event SetNewPair(address indexed pair);
    event UpdateShares(uint16 mktShare, uint16 devShare);
    event UpdateUniswapRouter(address indexed router);

    //-------------------------------------------------------------------------
    // CONSTRUCTOR
    //-------------------------------------------------------------------------
    constructor(
        address _devWallet,
        address _mktWallet,
        address newOwner
    ) ERC20("Olympink", "OLYMPINK") Ownable(newOwner) {
        sellThreshold = _INIT_SUPPLY / (1);
        router = IUniswapRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        IUniswapFactory factory = IUniswapFactory(router.factory());
        pair = IUniswapPair(factory.createPair(address(this), router.WETH()));
        isPair[address(pair)] = true;
        _approve(address(this), address(router), type(uint256).max);

        isExcludedFromTax[address(this)] = true;
        isExcludedFromTax[owner()] = true;
        isMaxWalExcluded[owner()] = true;
        isMaxWalExcluded[address(this)] = true;
        isMaxWalExcluded[address(router)] = true;
        isMaxWalExcluded[deadWallet] = true;
        isMaxWalExcluded[address(pair)] = true;
        isMaxTxExcluded[owner()] = true;
        isMaxTxExcluded[address(this)] = true;
        isMaxTxExcluded[address(router)] = true;
        isMaxTxExcluded[address(0)] = true;
        devWallet = _devWallet;
        mktWallet = _mktWallet;
        maxTx = _INIT_SUPPLY;
        maxWallet = _INIT_SUPPLY;

        _mint(owner(), _INIT_SUPPLY);
    }

    //-------------------------------------------------------------------------
    // EXTERNAL / PUBLIC FUNCTIONS
    //-------------------------------------------------------------------------

    receive() external payable {}

    fallback() external payable {}

    //-------------------------------------------------------------------------
    // Owner Functions
    //-------------------------------------------------------------------------

    function setBuyTax(uint8 _buyTax) external onlyOwner {
        if (_buyTax > 50) {
            revert _InvalidNewTax();
        }
        buyTax = _buyTax;
        emit UpdateBuyTax(_buyTax);
    }

    function setSellTax(uint8 _sellTax) external onlyOwner {
        if (_sellTax > 50) {
            revert _InvalidNewTax();
        }
        sellTax = _sellTax;
        emit UpdateBuyTax(_sellTax);
    }

 
    function setTaxExclusionStatus(
        address _address,
        bool _status
    ) external onlyOwner {
        isExcludedFromTax[_address] = _status;
        emit UpdateTaxExclusionStatus(_address, _status);
    }


    function setMaxTx(uint _maxTx) external onlyOwner {
        if (_maxTx < _INIT_SUPPLY / 500) revert _InvalidValue();
        maxTx = _maxTx;
        emit UpdateMaxTx(_maxTx);
    }

 
    function setMaxWallet(uint _maxWallet) external onlyOwner {
        if (_maxWallet < _INIT_SUPPLY / 100) revert _InvalidValue();
        maxWallet = _maxWallet;
        emit UpdateMaxWallet(_maxWallet);
    }


    function updateSellThreshold(uint _sellThreshold) external onlyOwner {
        if (
            _sellThreshold > _INIT_SUPPLY / 1000 ||
            _sellThreshold < _INIT_SUPPLY / 100000
        ) revert _InvalidValue();
        sellThreshold = _sellThreshold;
        emit UpdateThreshold(_sellThreshold);
    }

 
    function manualSwap() external onlyOwner {
        if (swapping != 1) revert _AlreadySwapping();
        uint balance = balanceOf(address(this));
        _swapAndTransfer(balance);
    }


    function addPair(address _pair) external onlyOwner {
        if (_pair == address(0)) revert _InvalidValue();
        isPair[_pair] = true;
        isMaxWalExcluded[_pair] = true;
        emit SetNewPair(_pair);
    }

    function updateUniswapRouter(address _router) external onlyOwner {
        if (router.WETH() != IUniswapRouter02(_router).WETH())
            revert _InvalidValue();
        router = IUniswapRouter02(_router);
        emit UpdateUniswapRouter(_router);
    }

    function recoverNative(address _to, uint _amount) external onlyOwner {
        (bool success, ) = payable(_to).call{value: _amount}("");
        if (!success) revert _NativeTransferFailed();
    }

    function recoverERC20(address _token, address _to) external onlyOwner {
        uint amount = ERC20(_token).balanceOf(address(this));
        ERC20(_token).transfer(_to, amount);
    }

    //-------------------------------------------------------------------------
    // INTERNAL/PRIVATE FUNCTIONS
    //-------------------------------------------------------------------------

    function _update(address from, address to, uint amount) internal override {
        bool isBuy = isPair[from];
        bool isSell = isPair[to];
        bool anyExcluded = isExcludedFromTax[from] || isExcludedFromTax[to];

        if (!isMaxTxExcluded[from] && !isMaxTxExcluded[to] && amount > maxTx)
            revert _MaxTxExceeded();

        uint currentBalance = balanceOf(address(this));
        if (
            !isBuy &&
            currentBalance > sellThreshold &&
            !anyExcluded &&
            swapping == 1
        ) {
            _swapAndTransfer(currentBalance);
        }

        uint fee = 0;
        if (!anyExcluded) {
            uint8 tax = _getTimedTax(isBuy, isSell);
            fee = (amount * tax) / PERCENTILE;
            if (fee > 0) {
                amount -= fee;
                super._update(from, address(this), fee);
            }
        }
        if (isSell && startTaxTime == 0) {
            startTaxTime = block.timestamp;
        }
        if (!isMaxWalExcluded[to] && balanceOf(to) + amount > maxWallet)
            revert _MaxWalletExceeded();

        super._update(from, to, amount);
    }

    function _swapAndTransfer(uint balance) private {
        swapping <<= 1;
        if (balance == 0) revert _NoBalance();
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        uint minAmount = router.getAmountsOut(balance, path)[1];
        minAmount = (minAmount * 7) / 10;
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            balance,
            minAmount,
            path,
            address(this),
            block.timestamp
        );
        uint nativeBalance = address(this).balance;
        if (totalShares == 0) return;
        uint mktAmount = (nativeBalance * mktShare) / totalShares;
        uint devAmount = nativeBalance - mktAmount;
        if (mktAmount > 0) {
            (bool success, ) = payable(mktWallet).call{value: mktAmount}(
                ""
            );
            if (!success) revert _NativeTransferFailed();
        }
        if (devAmount > 0) {
            (bool success, ) = payable(devWallet).call{value: devAmount}("");
            if (!success) revert _NativeTransferFailed();
        }

        swapping >>= 1;
    }


    function _getTimedTax(
        bool isBuy,
        bool isSell
    ) private view returns (uint8) {
        if ((!isBuy && !isSell) || startTaxTime == 0) return 0;

        uint timePassed = block.timestamp - startTaxTime;
        if (timePassed >= MAX_TAX_TIME) {
            if (isBuy) return buyTax;
            if (isSell) return sellTax;
            return 0;
        }
        return uint8(45 - ((timePassed / _TAX_INTERVAL)));
    }
}
