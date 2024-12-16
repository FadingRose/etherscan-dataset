// SPDX-License-Identifier: MIT

pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;

//import "hardhat/console.sol";

interface UniswapLens {
    function quoteExactInputSingle(
        address tokenIn,
        address tokenOut,
        uint24 fee,
        uint256 amountIn,
        uint160 sqrtPriceLimitX96
    ) external returns (uint256 amountOut);
}

interface UniswapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24  fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(
        ExactInputSingleParams calldata params
    ) external returns (uint256 amountOut);
}

interface UniswapReserve {
    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
    ) external returns (int256 amount0, int256 amount1);
}

interface ERC20Like {
    function approve(address spender, uint value) external returns(bool);
    function transfer(address to, uint value) external returns(bool);
    function balanceOf(address a) external view returns(uint);
}

interface WethLike is ERC20Like {
    function deposit() external payable;
}

interface CurveLike {
    function exchange_underlying(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns(uint);
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external returns(uint);
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy, address receiver) external returns(uint);    
}


interface BAMMLike {
    function swap(uint lusdAmount, uint minEthReturn, address payable dest) external returns(uint);
}

contract ArbTHUSDETH {
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant crvUSD = 0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E;
    address constant LUSD = 0xCFC5bD99915aAa815401C5a41A927aB7a38d29cf;    
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    UniswapLens constant LENS = UniswapLens(0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6);
    UniswapRouter constant ROUTER = UniswapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    UniswapReserve constant USDCETH = UniswapReserve(0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640);
    uint160 constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
    CurveLike constant CURV_crvUSD_thUSD = CurveLike(0x9E641187391B7a5fE9ee193359408CA3894f68a2);
    CurveLike constant CURV_crvUSD_USDC = CurveLike(0x4DEcE678ceceb27446b35C672dC7d61F30bAD69E);

    constructor() public {
        ERC20Like(USDC).approve(address(CURV_crvUSD_USDC), uint(-1));
        ERC20Like(crvUSD).approve(address(CURV_crvUSD_thUSD), uint(-1));        
    }

    function approve(address bamm) external {
        ERC20Like(LUSD).approve(address(bamm), uint(-1));
    }

    function swap(uint ethQty, address bamm, address payable profitReceiver) external payable returns(uint) {
        bytes memory data = abi.encode(bamm, false);
        USDCETH.swap(address(this), false, int256(ethQty), MAX_SQRT_RATIO - 1, data);

        uint retVal = address(this).balance;
        profitReceiver.transfer(retVal);

        return retVal;
     }

    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external {
        require(msg.sender == address(USDCETH), "uniswapV3SwapCallback: invalid sender");

        (address bamm) = abi.decode(data, (address));

        // swap USDC to LUSD
        uint USDCAmount = uint(-1 * amount0Delta);
        //console.log("usdc amount", USDCAmount);
        uint LUSDReturn = swapUSDCToLUSD(USDCAmount);//CURV.exchange_underlying(2, 0, USDCAmount, 1);
        //console.log("LUSDReturn amount", LUSDReturn);

        uint bammReturn = BAMMLike(bamm).swap(LUSDReturn, 1, address(this));
        //console.log("bamm return", bammReturn);

        if(amount1Delta > 0) {
            //console.log(address(this).balance);
            //console.log(uint(amount1Delta));
            //console.log(uint(-1 * amount0Delta));
            WethLike(WETH).deposit{value: uint(amount1Delta)}();
            if(amount1Delta > 0) WethLike(WETH).transfer(msg.sender, uint(amount1Delta));            
        }
    }

    function swapUSDCToLUSD(uint USDCAmount) internal returns(uint) {
        // dump usdc to crvUSD
        //console.log("usdc to crv");
        uint crvUSDAmount = CURV_crvUSD_USDC.exchange(0, 1, USDCAmount, 1);
        //console.log(crvUSDAmount);
        //console.log("via crvUSD to thUSD");
        uint thUSDAmount = CURV_crvUSD_thUSD.exchange(1, 0, crvUSDAmount, 1, address(this));
        //console.log(thUSDAmount);
        return thUSDAmount;
    }

    receive() external payable {}
}
