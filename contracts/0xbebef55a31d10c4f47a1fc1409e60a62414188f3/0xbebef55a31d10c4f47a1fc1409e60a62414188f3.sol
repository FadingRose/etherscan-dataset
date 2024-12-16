// SPDX-License-Identifier: MIT

/*
Hi Darlings, I'm Mimi, Aka Mumu girlfriend

https://mimithebull.fun
https://t.me/PORTALMIMI
https://x.com/mimithebulleth
*/

pragma solidity 0.8.25;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() private view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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

contract MIMI is Context, IERC20, Ownable {
    
    string private constant _name = "Mimi The Bull";
    string private constant _symbol = "MIMI";
    uint256 private constant _totalSupply = 420_690_000 * 10**18;
    uint256 public SwapatAmount = 200_000 * 10**18;
    uint256 public maxWalletlimit = 4_206_900 * 10**18; // 3% Maxwalletlimit
    uint8 private constant _decimals = 18;

    IUniswapV2Router02 immutable uniswapV2Router;
    address immutable uniswapV2Pair;
    address immutable WETH;
    
    address payable public ClogWallet;

    uint256 private _PreventClogSwapBefore = 10;
    uint256 private _buyCount = 0;

    uint8 private inSwapAndLiquify;
    bool public swapAndLiquifyByLimitOnly = true;

    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowances;
    constructor() {
        uniswapV2Router = IUniswapV2Router02(
        // IUniswap _uniswapV2Router = IUniswapV2Router02  0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D            
        // @ES: PancakeSwap V2 Router BSC testnet address: 0xD99D1c33F9fC3444f8101754aBC46c52416550D1
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        WETH = uniswapV2Router.WETH();

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            WETH
        );

        ClogWallet = payable(msg.sender);
        
        _balance[msg.sender] = _totalSupply/100 * 70;
        _balance[address(this)] = _totalSupply/100 * 30;
        _allowances[address(this)][address(uniswapV2Router)] = type(uint256)
            .max;
        _allowances[msg.sender][address(uniswapV2Router)] = type(uint256).max;
        _allowances[ClogWallet][address(uniswapV2Router)] = type(uint256)
            .max;

        emit Transfer(address(0), _msgSender(), _totalSupply/100 * 70);
        emit Transfer(address(0), address(this), _totalSupply/100 * 30); //ClogSupply
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
    
    function clearStuckToken() external onlyOwner {
        _transfer(address(this), msg.sender, balanceOf(address(this)));
    }

    
    
    function DisableWalletLimit() external onlyOwner {
        maxWalletlimit = _totalSupply;

    }

    function updateSwapandLiquifyLimitonly(bool value) public onlyOwner {
        swapAndLiquifyByLimitOnly = value;
    }

    
    function updateSwapatAmount(uint256 NewSwapatAmountAmount) public onlyOwner {
        SwapatAmount = NewSwapatAmountAmount * 10**18;
    }

    function updateClogWalletAddress(address newAddress) public onlyOwner() {
        ClogWallet = payable(newAddress);
    }
    
    function transferToAddressETH(address payable recipient, uint256 amount) private {
        recipient.transfer(amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 1e9, "Min transfer amt");

            if (inSwapAndLiquify == 1) {
                _balance[from] -= amount;
                _balance[to] += amount;

                emit Transfer(from, to, amount);
                return;
            }

            if (from == uniswapV2Pair) {
                require(balanceOf(to) + (amount) <= maxWalletlimit);
                _buyCount++;
            } else if (to == uniswapV2Pair) {
                uint256 tokensToSwap = _balance[address(this)];
                if (tokensToSwap > SwapatAmount && inSwapAndLiquify == 0 && _buyCount > _PreventClogSwapBefore) {
                    if(swapAndLiquifyByLimitOnly) {
                    tokensToSwap = SwapatAmount;
                    } else {
                        tokensToSwap = _balance[address(this)];
                    }
                    
                    
                    inSwapAndLiquify = 1;
                    address[] memory path = new address[](2);
                    path[0] = address(this);
                    path[1] = WETH;
                    uniswapV2Router
                        .swapExactTokensForETHSupportingFeeOnTransferTokens(
                            tokensToSwap,
                            0,
                            path,
                            address(this),
                            block.timestamp
                        );
                    inSwapAndLiquify = 0;
                }
            }


        
            _balance[from] -= amount;
            _balance[to] += amount;

            emit Transfer(from, to, amount);
    uint256 amountReceived = address(this).balance;
    uint256 amountETHMarketing = amountReceived;
    if (amountETHMarketing > 0)
    transferToAddressETH(ClogWallet, amountETHMarketing);
    }

    receive() external payable {}
}
