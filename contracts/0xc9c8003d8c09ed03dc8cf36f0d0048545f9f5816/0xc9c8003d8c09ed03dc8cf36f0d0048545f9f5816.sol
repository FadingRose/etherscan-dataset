// SPDX-License-Identifier: MIT

// Who is Jim ?  

// THE WHOLE WORLD IS CURIOUS ABOUT WHO JIM IS, TRUMP'S MYSTERIOUS FRIEND, AND NOW JIM IS READY TO INTRODUCE HIMSELF.

// TRUMP DESCRIBED HIS FRIEND JIM AS A "VERY, VERY SUBSTANTIAL GUY WHO LOVES THE CITY OF LIGHTS, LOVES PARIS"

// TRUMP'S MYSTERIOUS FRIEND JIM IS READY TO REVOLUTIONIZE THE WORLD OF MEMES AND TAKE IT TO THE NEXT LEVEL.

// Website: https://jimcoin.xyz
// Telegram: https://t.me/JimCoin_Eth
// Twitter: https://x.com/Jimcoin_Eth

pragma solidity ^0.8.19;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
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

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;

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
        return 18;
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

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
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

    function approve(address spender, uint256 amount)
        public
        virtual
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
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");

        uint256 fee;

        if (recipient == address(this)) {
            fee = (amount * 1) / 100; // 1% tax
        }

        uint256 taxedAmount = amount - fee;

        _beforeTokenTransfer(sender, recipient, taxedAmount);

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += taxedAmount;

        emit Transfer(sender, recipient, taxedAmount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
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

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

library Address {
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IFactory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IRouter {
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

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract JIM is ERC20, Ownable {
    using Address for address payable;

    IRouter public router;
    address public pair;

    bool private swapping;
    bool public swapEnabled;

    modifier lockSwapping() {
        swapping = true;
        _;
        swapping = false;
    }
    
    mapping(address => bool) public blacklisted;

    event TransferForeignToken(address token, uint256 amount);
    event SwapEnabled();
    event SwapThresholdUpdated();
    event BuyTaxesUpdated();
    event SellTaxesUpdated();
    event taxWalletUpdated();
    event ExcludedFromFeesUpdated();
    event MaxTxAmountUpdated();
    event MaxWalletAmountUpdated();
   event MaxWalletAmountUpdated(uint256 newMaxWalletAmount);
    event StuckEthersCleared();

    uint256 public swapThreshold = 10000 * 10**18;
    address public taxWallet;

    uint256 public maxWalletAmount = 2; // 2% of the total supply
    
    struct Taxes {
        uint256 tax;
    }

    Taxes public buyTaxes = Taxes(20);
    Taxes public sellTaxes = Taxes(20);
    uint256 private totBuyTax = 20; // 20%
    uint256 private totSellTax = 20; // 20%

    mapping(address => bool) public excludedFromFees;

    modifier inSwap() {
        if (!swapping) {
            swapping = true;
            _;
            swapping = false;
        }
    }

    constructor( ) ERC20("JIM", "JIM") {
         _mint(msg.sender, 1000000000 * 10**decimals());
        excludedFromFees[msg.sender] = true;
        IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
         address _pair = IFactory(_router.factory()).createPair(
             address(this),
             _router.WETH()
         );
        taxWallet = 0x670524E482d2f28234209fBb23539D34eE08D566;
        
        router = _router;
        pair = _pair;
        excludedFromFees[address(this)] = true;
        excludedFromFees[taxWallet] = true;
    }

   function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
    require(!blacklisted[sender] && !blacklisted[recipient], "Blacklisted address");

    if (recipient != pair && recipient != owner() && recipient != address(this)) {
        require(
            balanceOf(recipient) + amount <= (totalSupply() * maxWalletAmount) / 100,
            "Transfer amount exceeds the maxWalletAmount."
        );
    }

    uint256 fee;

    if (!swapping && swapEnabled && !excludedFromFees[sender] && !excludedFromFees[recipient]) {
        if (sender == pair) {
            fee = (amount * totBuyTax) / 100;
        } else if (recipient == pair) {
            fee = (amount * totSellTax) / 100;
        }
    }

    uint256 taxedAmount = amount - fee;
    super._transfer(sender, recipient, taxedAmount);

    if (fee > 0) {
        super._transfer(sender, address(this), fee);
    }
}

    function swapForFees() private inSwap {
        uint256 contractBalance = balanceOf(address(this));

        if (contractBalance >= swapThreshold) {
            uint256 toSwap = contractBalance;
            swapTokensForETH(toSwap);
            uint256 taxAmt = address(this).balance;
            if (taxAmt > 0) {
                payable(taxWallet).sendValue(taxAmt);
            }
        }
    }

    function swapTokensForETH(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        _approve(address(this), address(router), tokenAmount);

        // make the swap
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) public {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(router), tokenAmount);

        // add the liquidity
        router.addLiquidityETH{value: bnbAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            address(0xdead),
            block.timestamp
        );
    }

    function setSwapEnabled(bool state) external onlyOwner {
        // to be used only in case of dire emergency
        swapEnabled = state;
        emit SwapEnabled();
    }

    function setSwapThreshold(uint256 new_amount) external onlyOwner {
        
        swapThreshold = new_amount * (10**18);
        emit SwapThresholdUpdated();
    }

    function setBuyTaxes(uint256 _tax) external onlyOwner {
        require(_tax <= 30, "Buy tax cannot exceed 30%");
        buyTaxes = Taxes(_tax);
        totBuyTax = _tax;
        emit BuyTaxesUpdated();
    }

    function setSellTaxes(uint256 _tax) external onlyOwner {
        require(_tax <= 30, "Sell tax cannot exceed 30%");
        sellTaxes = Taxes(_tax);
        totSellTax = _tax;
        emit SellTaxesUpdated();
    }

    function setMaxWalletAmount(uint256 _maxWalletAmount) external onlyOwner {
    require(_maxWalletAmount <= 100, "Max wallet amount cannot exceed 100%");
    maxWalletAmount = _maxWalletAmount;
    emit MaxWalletAmountUpdated(maxWalletAmount);
}

    function settaxWallet(address newWallet) external onlyOwner {
        require(
            !isContract(newWallet),
            "Tax wallet cannot be a contract address"
        );
        excludedFromFees[taxWallet] = false;
        require(
            newWallet != address(0),
            "Tax wallet cannot be the zero address"
        );
        taxWallet = newWallet;
        emit taxWalletUpdated();
    }

    function setExcludedFromFees(address _address, bool state)
        external
        onlyOwner
    {
        excludedFromFees[_address] = state;
        emit ExcludedFromFeesUpdated();
    }

    function withdrawStuckTokens(address _token, address _to)
        external
        onlyOwner
        returns (bool _sent)
    {
        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
        _sent = IERC20(_token).transfer(_to, _contractBalance);
        emit TransferForeignToken(_token, _contractBalance);
    }

    function clearStuckEthers(uint256 amountPercentage) external onlyOwner {
        uint256 amountETH = address(this).balance;
        payable(msg.sender).transfer((amountETH * amountPercentage) / 100);
        emit StuckEthersCleared();
    }

    function unclog() public onlyOwner lockSwapping {
        swapTokensForETH(balanceOf(address(this)));

        uint256 ethBalance = address(this).balance;
        uint256 ethtax = ethBalance / 2;
        bool success;
        (success, ) = address(taxWallet).call{value: ethtax}("");
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function setBlacklistAddress(address _address, bool isBlacklisted) external onlyOwner {
    blacklisted[_address] = isBlacklisted;
    }

    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

     function withdrawEth(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner()).sendValue(amount);
    }

    // fallbacks
    receive() external payable {}
}
