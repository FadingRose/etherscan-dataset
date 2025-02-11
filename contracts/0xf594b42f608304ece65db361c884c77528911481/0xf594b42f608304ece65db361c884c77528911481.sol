// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    using SafeMath for uint256;

    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev The ETH balance of the account is not enough to perform the operation.
     */
    error AddressInsufficientBalance(address account);

    /**
     * @dev There's no code at `target` (it is not a contract).
     */
    error AddressEmptyCode(address target);

    /**
     * @dev A call to an address target failed. The target may have reverted.
     */
    error FailedInnerCall();

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.20/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        if (address(this).balance < amount) {
            revert AddressInsufficientBalance(address(this));
        }

        (bool success, ) = recipient.call{value: amount}("");
        if (!success) {
            revert FailedInnerCall();
        }
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason or custom error, it is bubbled
     * up by this function (like regular Solidity function calls). However, if
     * the call reverted with no returned reason, this function reverts with a
     * {FailedInnerCall} error.
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCallWithValue(target, data, 0);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        if (address(this).balance < value) {
            revert AddressInsufficientBalance(address(this));
        }
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and reverts if the target
     * was not a contract or bubbling up the revert reason (falling back to {FailedInnerCall}) in case of an
     * unsuccessful call.
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata
    ) internal view returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            // only check if target is a contract if the call was successful and the return data is empty
            // otherwise we already know that it was a contract
            if (returndata.length == 0 && target.code.length == 0) {
                revert AddressEmptyCode(target);
            }
            return returndata;
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and reverts if it wasn't, either by bubbling the
     * revert reason or with a default {FailedInnerCall} error.
     */
    function verifyCallResult(bool success, bytes memory returndata)
        internal
        pure
        returns (bytes memory)
    {
        if (!success) {
            _revert(returndata);
        } else {
            return returndata;
        }
    }

    /**
     * @dev Reverts with returndata if present. Otherwise reverts with {FailedInnerCall}.
     */
    function _revert(bytes memory returndata) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert FailedInnerCall();
        }
    }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    /**
     * @dev An operation with an ERC20 token failed.
     */
    error SafeERC20FailedOperation(address token);

    /**
     * @dev Indicates a failed `decreaseAllowance` request.
     */
    error SafeERC20FailedDecreaseAllowance(
        address spender,
        uint256 currentAllowance,
        uint256 requestedDecrease
    );

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeCall(token.transfer, (to, value)));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeCall(token.transferFrom, (from, to, value))
        );
    }

    /**
     * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        forceApprove(token, spender, oldAllowance + value);
    }

    /**
     * @dev Decrease the calling contract's allowance toward `spender` by `requestedDecrease`. If `token` returns no
     * value, non-reverting calls are assumed to be successful.
     */
    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 requestedDecrease
    ) internal {
        unchecked {
            uint256 currentAllowance = token.allowance(address(this), spender);
            if (currentAllowance < requestedDecrease) {
                revert SafeERC20FailedDecreaseAllowance(
                    spender,
                    currentAllowance,
                    requestedDecrease
                );
            }
            forceApprove(token, spender, currentAllowance - requestedDecrease);
        }
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Meant to be used with tokens that require the approval
     * to be set to zero before setting it to a non-zero value, such as USDT.
     */
    function forceApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        bytes memory approvalCall = abi.encodeCall(
            token.approve,
            (spender, value)
        );

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(
                token,
                abi.encodeCall(token.approve, (spender, 0))
            );
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
    function _callOptionalReturnBool(IERC20 token, bytes memory data)
        private
        returns (bool)
    {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
        // and not revert is the subcall reverts.

        (bool success, bytes memory returndata) = address(token).call(data);
        return
            success &&
            (returndata.length == 0 || abi.decode(returndata, (bool))) &&
            address(token).code.length > 0;
    }
}

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}


interface AggregatorV3Interface {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

contract PresaleCoinSec is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 public startTimeSale;
    uint256 public endTimeSale;
    uint256 public tokenTotalSold;
    uint256 public usdRate;

    struct UserInfo {
       uint256 totalAmount;
    }

    IERC20 public token = IERC20(0xd3CD30046aE84843333291EA56BcE78C751CCC06);
    IERC20 public usdcToken = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    IERC20 public usdtToken = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    AggregatorV3Interface public priceFeedETH = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    AggregatorV3Interface public priceFeedUSDC = AggregatorV3Interface(0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6);
    AggregatorV3Interface public priceFeedUSDT = AggregatorV3Interface(0x3E7d1eAB13ad0104d2750B8863b489D65364e32D);

    mapping(address => UserInfo) public userInfo;

    event TokensPurchased(address indexed buyer, uint256 amount, string currency);
    event TokensClaimed(address indexed claimer, uint256 amount);
    event TokensRecovered(address indexed sender, address indexed tokenAddress, uint256 amount);

    constructor(uint256 _startTime, uint256 _endTime) {
        startTimeSale = _startTime;
        endTimeSale = _endTime;
        usdRate = 1e18;
    }

    function buyTokensWithETH() external payable nonReentrant {
        require(block.timestamp >= startTimeSale, "Presale has not started yet");
        require(block.timestamp <= endTimeSale, "Presale has ended");
        require(msg.value > 0, "Amount must be greater than zero");

        uint256 ethAmount = msg.value;
        uint256 amount = getTokenAmountETH(ethAmount);
        require(amount > 0, "Amount must be greater than zero");
        uint256 remainingTokens = token.balanceOf(address(this));
        require(amount <= remainingTokens, "Not enough tokens available");

        UserInfo storage user = userInfo[msg.sender];

        (bool ethTransferSuccess, ) = payable(owner()).call{value: ethAmount}("");
        require(ethTransferSuccess, "ETH transfer failed");

        user.totalAmount = user.totalAmount.add(amount);
        tokenTotalSold = tokenTotalSold.add(amount);

        emit TokensPurchased(msg.sender, amount, "ETH");
    }

    function buyTokensWithUSDC(uint256 usdcAmount) external nonReentrant {
        require(block.timestamp >= startTimeSale, "Presale has not started yet");
        require(block.timestamp <= endTimeSale, "Presale has ended");
        require(usdcAmount > 0, "Amount must be greater than zero");

        uint256 amount = getTokenAmountUSDC(usdcAmount);
        uint256 tokenAmount = amount.mul(1e18).div(1e6);
        require(tokenAmount > 0, "Amount must be greater than zero");
        uint256 remainingTokens = token.balanceOf(address(this));
        require(tokenAmount <= remainingTokens, "Not enough tokens available");

        UserInfo storage user = userInfo[msg.sender];

        usdcToken.safeTransferFrom(msg.sender, owner(), usdcAmount);

        user.totalAmount = user.totalAmount.add(tokenAmount);
        tokenTotalSold = tokenTotalSold.add(tokenAmount);

        emit TokensPurchased(msg.sender, tokenAmount, "USDC");
        
    }

    function buyTokensWithUSDT(uint256 usdtAmount) external nonReentrant {
        require(block.timestamp >= startTimeSale, "Presale has not started yet");
        require(block.timestamp <= endTimeSale, "Presale has ended");
        require(usdtAmount > 0, "Amount must be greater than zero");

        uint256 amount = getTokenAmountUSDT(usdtAmount);
        uint256 tokenAmount = amount.mul(1e18).div(1e6);
        require(tokenAmount > 0, "Amount must be greater than zero");
        uint256 remainingTokens = token.balanceOf(address(this));
        require(tokenAmount <= remainingTokens, "Not enough tokens available");

        UserInfo storage user = userInfo[msg.sender];

        usdtToken.safeTransferFrom(msg.sender, owner(), usdtAmount);

        user.totalAmount = user.totalAmount.add(tokenAmount);
        tokenTotalSold = tokenTotalSold.add(tokenAmount);

        emit TokensPurchased(msg.sender, tokenAmount, "USDT");
        
    }

    function claimTokens() external nonReentrant {
        require(block.timestamp > endTimeSale, "Presale is still active");
        UserInfo storage user = userInfo[msg.sender];

        uint256 claimableAmount = user.totalAmount;
        require(claimableAmount > 0, "No tokens to claim");

        token.safeTransfer(msg.sender, claimableAmount);

        user.totalAmount = 0;

        emit TokensClaimed(msg.sender, claimableAmount);
    }

    function getClaimableTokens(address _user) external view returns (uint256) {
        UserInfo storage user = userInfo[_user];
        uint256 claimableAmount = user.totalAmount;
        if (claimableAmount == 0) {
            return 0;
        }
        return claimableAmount;
    }

    function getTokenAmountETH(uint256 amountETH) public view returns (uint256) {
        uint256 lastETHPriceByUSD = getLatestPriceETHPerUSD();
        return amountETH.mul(lastETHPriceByUSD).div(getPriceInUSD());
    }

    function getTokenAmountUSDC(uint256 amountUSDC) public view returns (uint256) {
        uint256 lastUSDCPriceByUSD = getLatestPriceUSDCPerUSD();
        return amountUSDC.mul(lastUSDCPriceByUSD).div(getPriceInUSD());
    }

    function getTokenAmountUSDT(uint256 amountUSDT) public view returns (uint256) {
        uint256 lastUSDTPriceByUSD = getLatestPriceUSDTPerUSD();
        return amountUSDT.mul(lastUSDTPriceByUSD).div(getPriceInUSD());
    }

    function getLatestPriceETHPerUSD() public view returns (uint256) {
        (, int256 price, , , ) = priceFeedETH.latestRoundData();
        price = (price * (10**10));
        return uint256(price);
    }

    function getLatestPriceUSDCPerUSD() public view returns (uint256) {
        (, int256 price, , , ) = priceFeedUSDC.latestRoundData();
        price = (price * (10**10));
        return uint256(price);
    }

    function getLatestPriceUSDTPerUSD() public view returns (uint256) {
        (, int256 price, , , ) = priceFeedUSDT.latestRoundData();
        price = (price * (10**10));
        return uint256(price);
    }

    function getPriceInUSD() public view returns (uint256) {
        return usdRate;
    }

    function updateContractAddresses(address _newPriceFeedETH, address _newPriceFeedUSDC, address _newPriceFeedUSDT) external onlyOwner {
        require(_newPriceFeedETH != address(0), "ETH price feed address cannot be zero");
        require(_newPriceFeedUSDC != address(0), "USDC price feed address cannot be zero");
        require(_newPriceFeedUSDT != address(0), "USDT price feed address cannot be zero");
        priceFeedETH = AggregatorV3Interface(_newPriceFeedETH);
        priceFeedUSDC = AggregatorV3Interface(_newPriceFeedUSDC);
        priceFeedUSDT = AggregatorV3Interface(_newPriceFeedUSDT);
    }

    function setToken(IERC20 _newToken, IERC20 _newUsdcToken, IERC20 _newUsdtToken) external onlyOwner {
        require(address(_newToken) != address(0), "Token address cannot be zero");
        require(address(_newUsdcToken) != address(0), "USDC Token address cannot be zero");
        require(address(_newUsdtToken) != address(0), "USDT Token address cannot be zero");
        token = _newToken;
        usdcToken = _newUsdcToken;
        usdtToken = _newUsdtToken;
    }

    function setUsdRate(uint256 _newUsdRate) external onlyOwner {
        require(_newUsdRate > 0, "USD rate must be greater than zero");
        usdRate = _newUsdRate;
    }

    function getUsdRaised() external view returns (uint256) {
        return tokenTotalSold.mul(usdRate).div(1e18);
    }

    function setEndTime(uint256 _endTime) external onlyOwner {
        endTimeSale = _endTime;
    }

    function setStartTime(uint256 _startTime) external onlyOwner {
        startTimeSale = _startTime;
    }

    function withdrawETH() external onlyOwner {
        uint256 ethBalance = address(this).balance;
        (bool success, ) = payable(msg.sender).call{value: ethBalance}("");
        require(success, "ETH withdrawal failed");
    }

    function withdrawLeftToken() external onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No tokens");
        token.safeTransfer(owner(), balance);
    }
    
    function recoverWrongTokens(address _tokenAddress) external onlyOwner {
        IERC20 wrongToken = IERC20(_tokenAddress);
        uint256 balance = wrongToken.balanceOf(address(this));
        require(balance > 0, "No tokens to recover");

        require(wrongToken.transfer(owner(), balance), "Token recovery failed");

        emit TokensRecovered(msg.sender, _tokenAddress, balance);
    }
}
