// SPDX-License-Identifier: UNLICENSED
// File: contracts/Utils.sol


pragma solidity ^0.8.16;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

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

// SafeERC20 required by OApp
library SafeERC20 {
    using Address for address;

    /**
     * @dev An operation with an ERC20 token failed.
     */
    error SafeERC20FailedOperation(address token);

    /**
     * @dev Indicates a failed `decreaseAllowance` request.
     */
    error SafeERC20FailedDecreaseAllowance(address spender, uint256 currentAllowance, uint256 requestedDecrease);

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeCall(token.transfer, (to, value)));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeCall(token.transferFrom, (from, to, value)));
    }

    /**
     * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        forceApprove(token, spender, oldAllowance + value);
    }

    /**
     * @dev Decrease the calling contract's allowance toward `spender` by `requestedDecrease`. If `token` returns no
     * value, non-reverting calls are assumed to be successful.
     */
    function safeDecreaseAllowance(IERC20 token, address spender, uint256 requestedDecrease) internal {
        unchecked {
            uint256 currentAllowance = token.allowance(address(this), spender);
            if (currentAllowance < requestedDecrease) {
                revert SafeERC20FailedDecreaseAllowance(spender, currentAllowance, requestedDecrease);
            }
            forceApprove(token, spender, currentAllowance - requestedDecrease);
        }
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Meant to be used with tokens that require the approval
     * to be set to zero before setting it to a non-zero value, such as USDT.
     */
    function forceApprove(IERC20 token, address spender, uint256 value) internal {
        bytes memory approvalCall = abi.encodeCall(token.approve, (spender, value));

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(token, abi.encodeCall(token.approve, (spender, 0)));
            _callOptionalReturn(token, approvalCall);
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data);
        if (returndata.length != 0 && !abi.decode(returndata, (bool))) {
            revert SafeERC20FailedOperation(address(token));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
     */
    function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
        // and not revert is the subcall reverts.

        (bool success, bytes memory returndata) = address(token).call(data);
        return success && (returndata.length == 0 || abi.decode(returndata, (bool))) && address(token).code.length > 0;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );
        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Ownable is Context {
    address private _owner;
    bool initialized = false;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    function _setOwner() internal {
        require(!initialized, "Invalid init");
        _transferOwnership(_msgSender());
        initialized = true;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
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

interface IUniswapV3SwapCallback {
    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}

interface IMulticall {
    /// @notice Call multiple functions in the current contract and return the data from all of them if they all succeed
    /// @dev The `msg.value` should not be trusted for any method callable from multicall.
    /// @param data The encoded function data for each of the calls to make to this contract
    /// @return results The results from each of the calls passed in via data
    function multicall(
        bytes[] calldata data
    ) external payable returns (bytes[] memory results);
}

interface ISwapRouter is IUniswapV3SwapCallback, IMulticall {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(
        ExactInputSingleParams calldata params
    ) external payable returns (uint256 amountOut);

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    function exactInput(
        ExactInputParams calldata params
    ) external payable returns (uint256 amountOut);

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    function exactOutputSingle(
        ExactOutputSingleParams calldata params
    ) external payable returns (uint256 amountIn);

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
    }

    function exactOutput(
        ExactOutputParams calldata params
    ) external payable returns (uint256 amountIn);
}

interface IUniswapV3PoolActions {
    function initialize(uint160 sqrtPriceX96) external;

    function mint(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount,
        bytes calldata data
    ) external returns (uint256 amount0, uint256 amount1);

    function collect(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount0Requested,
        uint128 amount1Requested
    ) external returns (uint128 amount0, uint128 amount1);

    function burn(
        int24 tickLower,
        int24 tickUpper,
        uint128 amount
    ) external returns (uint256 amount0, uint256 amount1);

    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
    ) external returns (int256 amount0, int256 amount1);

    function flash(
        address recipient,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;

    function increaseObservationCardinalityNext(
        uint16 observationCardinalityNext
    ) external;
}

interface IUniswapV3PoolDerivedState {
    function observe(
        uint32[] calldata secondsAgos
    )
        external
        view
        returns (
            int56[] memory tickCumulatives,
            uint160[] memory secondsPerLiquidityCumulativeX128s
        );

    function snapshotCumulativesInside(
        int24 tickLower,
        int24 tickUpper
    )
        external
        view
        returns (
            int56 tickCumulativeInside,
            uint160 secondsPerLiquidityInsideX128,
            uint32 secondsInside
        );
}

interface IUniswapV3PoolEvents {
    event Initialize(uint160 sqrtPriceX96, int24 tick);

    event Mint(
        address sender,
        address indexed owner,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount,
        uint256 amount0,
        uint256 amount1
    );

    event Collect(
        address indexed owner,
        address recipient,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount0,
        uint128 amount1
    );

    event Burn(
        address indexed owner,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount,
        uint256 amount0,
        uint256 amount1
    );

    event Swap(
        address indexed sender,
        address indexed recipient,
        int256 amount0,
        int256 amount1,
        uint160 sqrtPriceX96,
        uint128 liquidity,
        int24 tick
    );

    event Flash(
        address indexed sender,
        address indexed recipient,
        uint256 amount0,
        uint256 amount1,
        uint256 paid0,
        uint256 paid1
    );

    event IncreaseObservationCardinalityNext(
        uint16 observationCardinalityNextOld,
        uint16 observationCardinalityNextNew
    );

    event SetFeeProtocol(
        uint8 feeProtocol0Old,
        uint8 feeProtocol1Old,
        uint8 feeProtocol0New,
        uint8 feeProtocol1New
    );

    event CollectProtocol(
        address indexed sender,
        address indexed recipient,
        uint128 amount0,
        uint128 amount1
    );
}

interface IUniswapV3PoolImmutables {
    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function fee() external view returns (uint24);

    function tickSpacing() external view returns (int24);

    function maxLiquidityPerTick() external view returns (uint128);
}

interface IUniswapV3PoolOwnerActions {
    function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;

    function collectProtocol(
        address recipient,
        uint128 amount0Requested,
        uint128 amount1Requested
    ) external returns (uint128 amount0, uint128 amount1);
}

interface IUniswapV3PoolState {
    function slot0()
        external
        view
        returns (
            uint160 sqrtPriceX96,
            int24 tick,
            uint16 observationIndex,
            uint16 observationCardinality,
            uint16 observationCardinalityNext,
            uint8 feeProtocol,
            bool unlocked
        );

    function feeGrowthGlobal0X128() external view returns (uint256);

    function feeGrowthGlobal1X128() external view returns (uint256);

    function protocolFees()
        external
        view
        returns (uint128 token0, uint128 token1);

    function liquidity() external view returns (uint128);

    function ticks(
        int24 tick
    )
        external
        view
        returns (
            uint128 liquidityGross,
            int128 liquidityNet,
            uint256 feeGrowthOutside0X128,
            uint256 feeGrowthOutside1X128,
            int56 tickCumulativeOutside,
            uint160 secondsPerLiquidityOutsideX128,
            uint32 secondsOutside,
            bool initialized
        );

    function tickBitmap(int16 wordPosition) external view returns (uint256);

    function positions(
        bytes32 key
    )
        external
        view
        returns (
            uint128 _liquidity,
            uint256 feeGrowthInside0LastX128,
            uint256 feeGrowthInside1LastX128,
            uint128 tokensOwed0,
            uint128 tokensOwed1
        );

    function observations(
        uint256 index
    )
        external
        view
        returns (
            uint32 blockTimestamp,
            int56 tickCumulative,
            uint160 secondsPerLiquidityCumulativeX128,
            bool initialized
        );
}

interface IUniswapV3Pool is
    IUniswapV3PoolImmutables,
    IUniswapV3PoolState,
    IUniswapV3PoolDerivedState,
    IUniswapV3PoolActions,
    IUniswapV3PoolOwnerActions,
    IUniswapV3PoolEvents
{}
// File: contracts/Uniswap.sol


pragma solidity ^0.8.9;

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function burn(
        address to
    ) external returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

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
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

    function getAmountsIn(
        uint256 amountOut,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

// File: contracts/Token.sol




/*
#######################################################################################################################
#######################################################################################################################

Micropets Upgradable Token Contract
https://micropets.io

Copyright CryptIT GmbH

#######################################################################################################################
#######################################################################################################################
*/

pragma solidity ^0.8.16;


contract MicroPets is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) public excludedFromFee;
    mapping(uint24 => address) public feeToPoolAddress;
    mapping(address => bool) public isPoolAddress;

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;

    uint256 private _taxCollected;

    uint256 private minimumTokensBeforeSwap;
    uint256 private minimumETHToTransfer;

    address payable public lpVaultAddress;
    address payable public marketingAddress;
    address payable public developmentAddress;
    address payable public coinStakingAddress;
    address public tokenReserveAddress;

    bool public swapAndLiquifyEnabled;
    bool public autoSplitShares;
    bool public taxesEnabled;

    bool inSwapAndLiquify;
    bool inSplitShares;

    Configs public tokenConfigs;

    IUniswapV2Router02 public uniswapV2Router;

    struct Configs {
        uint8 coinShareLP;
        uint8 coinShareMarketing;
        uint8 coinShareDevelopment;
        uint8 coinShareStaking;
        uint8 tokenShareReserve;
        uint8 buyTax;
        uint8 sellTax;
    }

    address public _bridgeContract;
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event EnabledUniswap();
    event ExcludeFromFee(address indexed wallet);
    event IncludeInFee(address indexed wallet);
    event UpdateOperationWallet(
        address prevWallet,
        address newWallet,
        string operation
    );
    event UpdateTax(uint8 buyTax, uint8 sellTax);

    modifier lockForSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    modifier lockForSplitShare() {
        inSplitShares = true;
        _;
        inSplitShares = false;
    }

    modifier onlyBridge() {
        require(msg.sender == _bridgeContract);
        _;
    }

    ////////////////////////////////////////////////////////////////////
    // Upgrade add state
    ////////////////////////////////////////////////////////////////////

    function initialize() public {
        _setOwner();

        _name = "MicroPets";
        _symbol = "PETS";
        _totalSupply = 10_000_000_000 * 10 ** 18;
        uint256 ownerSupply = 500_000_000 * 10 ** 18;

        _balances[_msgSender()] = _totalSupply.sub(ownerSupply);
        emit Transfer(address(0), _msgSender(), _totalSupply.sub(ownerSupply));

        _balances[0x38402a3316A4Ab8fc742AE42c30D2ff9b6f43DC5] = ownerSupply;
        emit Transfer(
            address(0),
            0x38402a3316A4Ab8fc742AE42c30D2ff9b6f43DC5,
            ownerSupply
        );

        excludedFromFee[_msgSender()] = true;
        excludedFromFee[address(this)] = true;

        minimumTokensBeforeSwap = 300 * 10 ** 18;
        minimumETHToTransfer = 5 * 10 ** 17;

        swapAndLiquifyEnabled = true;
        autoSplitShares = true;
        taxesEnabled = true;

        _setupExchange(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

        _setShares(18, 27, 27, 27, 8, 12, 12);

        _setLpVaultAddress(payable(0x70875197aCf27ae827Dc056acE22f5893fd55ED5));

        _setMarketingAddress(
            payable(0x4aDFaf09e978657337ba596f5D1D61D068962Ec2)
        );
        _setDevelopmentAddress(
            payable(0x465fE58cAFadEA9C80D04078B72c5Bb1136f28C0)
        );
        _setCoinStakingAddress(
            payable(0x5bfAf16Cc8E39Cc34EC575A1E510E4f293EaFc44)
        );
        _setTokenReserveAddress(0xE9fCB23A23ade85D424625B00C77eA99f8e64C0D);
    }

    // Start ERC-20 standard functions

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) external virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) external virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    // End ERC-20 standard functions
    function mintBridge(address account, uint256 value) public onlyBridge {
        require(account != address(0), "Cannot mint from address 0");
        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    function burnBridge(address account, uint256 value) public onlyBridge {
        require(account != address(0), "Cannot burn from address 0");
        uint256 fromBalance = _balances[account];
        require(fromBalance >= value, "Insufficient value sent");
        _totalSupply = _totalSupply.sub(value);
        _balances[account] = fromBalance.sub(value);
        emit Transfer(account, address(0), value);
    }

    function updateBridgeAddress(address _newBridgeAddress) public onlyOwner {
        _bridgeContract = _newBridgeAddress;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        if (amount == 0) {
            emit Transfer(from, to, 0);
            return;
        }

        if (!taxesEnabled || excludedFromFee[from] || excludedFromFee[to]) {
            _transferStandard(from, to, amount);
            return;
        }

        bool isToPool = isPoolAddress[to]; //means sell or provide LP
        bool isFromPool = isPoolAddress[from]; //means buy or remove LP

        if (!isToPool && !isFromPool) {
            _transferStandard(from, to, amount);
            return;
        }

        if (isToPool) {
            handleTaxAutomation();
            _transferWithTax(from, to, amount, tokenConfigs.sellTax);
        } else {
            _transferWithTax(from, to, amount, tokenConfigs.buyTax);
        }
    }

    function handleTaxAutomation() internal {
        bool hasSwapped = false;

        if (!inSwapAndLiquify && !inSplitShares && swapAndLiquifyEnabled) {
            uint256 contractTokenBalance = balanceOf(address(this));
            if (contractTokenBalance >= minimumTokensBeforeSwap) {
                swapAndLiquify(contractTokenBalance);
                hasSwapped = true;
            }
        }

        if (
            !hasSwapped &&
            !inSplitShares &&
            !inSwapAndLiquify &&
            autoSplitShares &&
            address(this).balance >= minimumETHToTransfer
        ) {
            _distributeTax();
        }
    }

    function safeTransferETH(address payable to, uint256 value) internal {
        (bool sentETH, ) = to.call{value: value}("");
        require(sentETH, "Failed to send ETH");
    }

    function safeTransferToken(address token, address to, uint value) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0xa9059cbb, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "Failed to send token"
        );
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint value
    ) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x23b872dd, from, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "Failed to transfer from"
        );
    }

    function manualSwapAndLiquify(
        uint256 tokenAmountToSwap
    ) external onlyOwner {
        if (!inSwapAndLiquify && !inSplitShares) {
            uint256 contractTokenBalance = balanceOf(address(this));

            require(
                contractTokenBalance >= tokenAmountToSwap,
                "Invalid amount"
            );

            if (tokenAmountToSwap >= minimumTokensBeforeSwap) {
                swapAndLiquify(tokenAmountToSwap);
            }
        }
    }

    function swapTokensForETH(
        uint256 tokenAmount
    ) internal returns (uint256 swappedAmount, uint256 tokenReserveShare) {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        IUniswapV2Factory factory = IUniswapV2Factory(
            uniswapV2Router.factory()
        );
        address pair = factory.getPair(path[0], path[1]);
        uint256 maxSwap = _balances[pair].div(100);

        swappedAmount = tokenAmount > maxSwap ? maxSwap : tokenAmount;
        tokenReserveShare = swappedAmount
            .mul(tokenConfigs.tokenShareReserve)
            .div(100);

        swappedAmount = swappedAmount.sub(tokenReserveShare);

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            swappedAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function swapAndLiquify(uint256 tokensToSwap) internal lockForSwap {
        (uint256 swappedAmount, uint256 tokenReserveShare) = swapTokensForETH(
            tokensToSwap
        );
        _transferStandard(
            address(this),
            tokenReserveAddress,
            tokenReserveShare
        );
        _taxCollected = _taxCollected.add(swappedAmount).add(tokenReserveShare);
    }

    function _calcuclateShare(
        uint8 share,
        uint256 amount
    ) internal pure returns (uint256) {
        return amount.mul(share).div(100);
    }

    function _distributeTax() internal lockForSplitShare {
        uint256 balance = address(this).balance;

        safeTransferETH(
            lpVaultAddress,
            _calcuclateShare(tokenConfigs.coinShareLP, balance)
        );
        safeTransferETH(
            marketingAddress,
            _calcuclateShare(tokenConfigs.coinShareMarketing, balance)
        );
        safeTransferETH(
            developmentAddress,
            _calcuclateShare(tokenConfigs.coinShareDevelopment, balance)
        );
        safeTransferETH(
            coinStakingAddress,
            _calcuclateShare(tokenConfigs.coinShareStaking, balance)
        );
    }

    function distributeTax() external onlyOwner {
        _distributeTax();
    }

    function _transferStandard(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
    }

    function _transferWithTax(
        address sender,
        address recipient,
        uint256 amount,
        uint256 tax
    ) internal {
        if (tax == 0) {
            _transferStandard(sender, recipient, amount);
            return;
        }

        _balances[sender] = _balances[sender].sub(amount);

        uint256 taxAmount = amount.mul(tax).div(100);
        uint256 receiveAmount = amount.sub(taxAmount);

        _balances[address(this)] = _balances[address(this)].add(taxAmount);
        _balances[recipient] = _balances[recipient].add(receiveAmount);

        emit Transfer(sender, recipient, receiveAmount);
    }

    function includeInFee(address account) external onlyOwner {
        excludedFromFee[account] = false;
        emit IncludeInFee(account);
    }

    function excludeFromFee(address account) external onlyOwner {
        excludedFromFee[account] = true;
        emit ExcludeFromFee(account);
    }

    function _setMarketingAddress(address payable _marketingAddress) internal {
        marketingAddress = _marketingAddress;
    }

    function _setDevelopmentAddress(
        address payable _developmentAddress
    ) internal {
        developmentAddress = _developmentAddress;
    }

    function _setLpVaultAddress(address payable _vaultAddress) internal {
        lpVaultAddress = _vaultAddress;
    }

    function _setCoinStakingAddress(
        address payable _coinStakingAddress
    ) internal {
        coinStakingAddress = _coinStakingAddress;
    }

    function _setTokenReserveAddress(address _tokenReserveAddress) internal {
        tokenReserveAddress = _tokenReserveAddress;
    }

    function isContract(address _addr) internal view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    function setMarketingAddress(
        address payable _marketingAddress
    ) external onlyOwner {
        require(!isContract(_marketingAddress), "Cannot set contract address");
        emit UpdateOperationWallet(
            marketingAddress,
            _marketingAddress,
            "marketing"
        );
        _setMarketingAddress(_marketingAddress);
    }

    function setDevelopmentAddress(
        address payable _developmentAddress
    ) external onlyOwner {
        require(
            !isContract(_developmentAddress),
            "Cannot set contract address"
        );
        emit UpdateOperationWallet(
            developmentAddress,
            _developmentAddress,
            "development"
        );
        _setDevelopmentAddress(_developmentAddress);
    }

    function setLpVaultAddress(
        address payable _vaultAddress
    ) external onlyOwner {
        require(!isContract(_vaultAddress), "Cannot set contract address");
        emit UpdateOperationWallet(lpVaultAddress, _vaultAddress, "lpvault");
        _setLpVaultAddress(_vaultAddress);
    }

    function setCoinStakingAddress(
        address payable _coinStakingAddress
    ) external onlyOwner {
        require(
            !isContract(_coinStakingAddress),
            "Cannot set contract address"
        );
        emit UpdateOperationWallet(
            coinStakingAddress,
            _coinStakingAddress,
            "staking"
        );
        _setCoinStakingAddress(_coinStakingAddress);
    }

    function setTokenReserveAddress(
        address _tokenReserveAddress
    ) external onlyOwner {
        emit UpdateOperationWallet(
            tokenReserveAddress,
            _tokenReserveAddress,
            "reserve"
        );
        _setTokenReserveAddress(_tokenReserveAddress);
    }

    function _setShares(
        uint8 coinShareLP,
        uint8 coinShareMarketing,
        uint8 coinShareDevelopment,
        uint8 coinShareStaking,
        uint8 tokenShareReserve,
        uint8 buyTax,
        uint8 sellTax
    ) internal {
        tokenConfigs.coinShareLP = coinShareLP;
        tokenConfigs.coinShareMarketing = coinShareMarketing;
        tokenConfigs.coinShareDevelopment = coinShareDevelopment;
        tokenConfigs.coinShareStaking = coinShareStaking;
        tokenConfigs.tokenShareReserve = tokenShareReserve;
        tokenConfigs.buyTax = buyTax;
        tokenConfigs.sellTax = sellTax;
    }

    function setShares(
        uint8 coinShareLP,
        uint8 coinShareMarketing,
        uint8 coinShareDevelopment,
        uint8 coinShareStaking,
        uint8 tokenShareReserve,
        uint8 buyTax,
        uint8 sellTax
    ) external onlyOwner {
        require(buyTax <= 25 && sellTax <= 25, "Invalid Tax");
        require(tokenShareReserve <= 100, "Invalid token share");
        require(
            coinShareLP +
                coinShareMarketing +
                coinShareDevelopment +
                coinShareStaking ==
                100,
            "Invalid coin shares"
        );
        _setShares(
            coinShareLP,
            coinShareMarketing,
            coinShareDevelopment,
            coinShareStaking,
            tokenShareReserve,
            buyTax,
            sellTax
        );
        emit UpdateTax(buyTax, sellTax);
    }

    function getTax() external view returns (uint8, uint8) {
        return (tokenConfigs.buyTax, tokenConfigs.sellTax);
    }

    function setMinimumTokensBeforeSwap(
        uint256 _minimumTokensBeforeSwap
    ) external onlyOwner {
        minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
    }

    function setMinimumETHToTransfer(
        uint256 _minimumETHToTransfer
    ) external onlyOwner {
        minimumETHToTransfer = _minimumETHToTransfer;
    }

    function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    function setAutoSplitSharesEnables(bool _enabled) external onlyOwner {
        autoSplitShares = _enabled;
    }

    function addPoolAddress(address pool) external onlyOwner {
        isPoolAddress[pool] = true;
    }

    function removePoolAddress(address pool) external onlyOwner {
        isPoolAddress[pool] = false;
    }

    function _setupExchange(address newRouter) internal {
        IUniswapV2Router02 _newPancakeRouter = IUniswapV2Router02(newRouter);
        IUniswapV2Factory factory = IUniswapV2Factory(
            _newPancakeRouter.factory()
        );

        address existingPair = factory.getPair(
            address(this),
            _newPancakeRouter.WETH()
        );

        if (existingPair == address(0)) {
            address lpPool = factory.createPair(
                address(this),
                _newPancakeRouter.WETH()
            );

            isPoolAddress[lpPool] = true;
        } else {
            isPoolAddress[existingPair] = true;
        }

        uniswapV2Router = _newPancakeRouter;
    }

    function setupExchange(address newRouter) external onlyOwner {
        _setupExchange(newRouter);
    }

    function totalTaxCollected() external view onlyOwner returns (uint256) {
        return _taxCollected;
    }

    function burn(uint256 amount) external {
        require(balanceOf(_msgSender()) >= amount, "Insufficient balance");
        _balances[_msgSender()] = _balances[_msgSender()].sub(amount);
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(_msgSender(), address(0), amount);
    }

    receive() external payable {}
}
