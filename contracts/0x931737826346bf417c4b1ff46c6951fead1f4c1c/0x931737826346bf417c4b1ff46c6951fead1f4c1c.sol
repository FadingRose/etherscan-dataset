// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;



/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
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


interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     *
     * CAUTION: See Security Considerations above.
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
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
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
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
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        if (address(this).balance < value) {
            revert AddressInsufficientBalance(address(this));
        }
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
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
    function verifyCallResult(bool success, bytes memory returndata) internal pure returns (bytes memory) {
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
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
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
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
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



/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}



/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
abstract contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor() {
        _paused = false;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        _requireNotPaused();
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        _requirePaused();
        _;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view virtual returns (bool) {
        return _paused;
    }

    /**
     * @dev Throws if the contract is paused.
     */
    function _requireNotPaused() internal view virtual {
        require(!paused(), "Pausable: paused");
    }

    /**
     * @dev Throws if the contract is not paused.
     */
    function _requirePaused() internal view virtual {
        require(paused(), "Pausable: not paused");
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}

// File: chainlinkAggregatorInterface.sol

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);
    function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

/// File: Presale.sol
contract BTVZPresale is Ownable, ReentrancyGuard, Pausable {
    using SafeERC20 for IERC20;

    struct UserInfo {
        uint256 contribution;
        uint256 tokensBought;
        bool claimed;
    }

    IERC20 public immutable saleToken;
    AggregatorV3Interface public immutable nativeTokenUsdPriceFeed;

    uint256 public immutable saleTokenDecimals;
    uint256 public totalTokensForSale;
    uint256 public tokenPriceUSD;
    uint256 public saleStartTime;
    uint256 public saleEndTime;
    uint256 public claimStartTime;
    bool public saleEnded;

    uint256 public totalTokensSold;
    uint256 public totalContributionUSD;
    address public paymentReceiver;

    mapping(address => bool) public acceptedStablecoins;
    mapping(address => uint256) public stablecoinDecimals;
    mapping(address => UserInfo) public userInfo;

    event TokensPurchased(address indexed buyer, uint256 amount, uint256 cost, string currency);
    event TokensClaimed(address indexed claimer, uint256 amount);
    event SaleEnded(uint256 totalSold, uint256 totalContribution);
    event SaleStarted(uint256 startTime, uint256 endTime);
    event TokenPriceUpdated(uint256 newPrice);
    event PaymentWalletUpdated(address newWallet);
    event SalePaused(uint256 timestamp);
    event SaleUnpaused(uint256 timestamp);
    event SaleExtended(uint256 newEndTime);
    event TotalTokensUpdated(uint256 newTotal);

    error SaleNotStarted();
    error SaleNotEnded();
    error SaleIsEndedAlready();
    error SaleAlreadyStarted();
    error InvalidContributionAmount();
    error ExceedsAvailableTokens();
    error ClaimingNotStarted();
    error NoTokensToClaim();
    error TokensAlreadyClaimed();
    error InvalidPrice();
    error InvalidTotalTokens();
    error InvalidDuration();
    error TransferFailed();
    error InvalidStablecoin();
    error InvalidAddress();
    error ArrayLengthMismatch();
    error InvalidNativeTokenPrice();

    constructor(
        address _saleToken,
        address _nativeTokenUsdPriceFeed,
        uint256 _saleTokenDecimals,
        uint256 _totalTokensForSale,
        uint256 _tokenPriceUSD,
        address[] memory _stablecoins,
        uint256[] memory _stablecoinDecimals
    ) Ownable(msg.sender) {
        saleToken = IERC20(_saleToken);
        nativeTokenUsdPriceFeed = AggregatorV3Interface(_nativeTokenUsdPriceFeed);
        saleTokenDecimals = _saleTokenDecimals;
        totalTokensForSale = _totalTokensForSale;
        tokenPriceUSD = _tokenPriceUSD;
        paymentReceiver = msg.sender;

        if (_stablecoins.length != _stablecoinDecimals.length) revert ArrayLengthMismatch();
        for (uint256 i = 0; i < _stablecoins.length; i++) {
            acceptedStablecoins[_stablecoins[i]] = true;
            stablecoinDecimals[_stablecoins[i]] = _stablecoinDecimals[i];
        }
    }

    receive() external payable {
        buyWithNativeToken();
    }
   
    /// @dev start sale globally
    /// @param _duration: duration of the sale in seconds
    function startSale(uint256 _duration) external onlyOwner {
        if (saleStartTime != 0) revert SaleAlreadyStarted();
        if (_duration == 0) revert InvalidDuration();
        saleStartTime = block.timestamp;
        saleEndTime = saleStartTime + _duration;
        emit SaleStarted(saleStartTime, saleEndTime);
    }
    
    ///
    function setPaymentWallet(address _newWallet) external onlyOwner {
        if (_newWallet == address(0)) revert InvalidAddress();
        paymentReceiver = _newWallet;
        emit PaymentWalletUpdated(_newWallet);
    }

    function endSale() external onlyOwner {
        if (saleStartTime == 0) revert SaleNotStarted();
        if (saleEnded) revert SaleIsEndedAlready();
        saleEnded = true;
        uint256 availableTokens = totalTokensForSale - totalTokensSold;
        if (availableTokens > 0) {
            saleToken.safeTransfer(owner(), availableTokens);
        }
        claimStartTime = block.timestamp + 1 hours;
        emit SaleEnded(totalTokensSold, totalContributionUSD);
    }

    function getLatestNativeTokenPrice() public view returns (uint256) {
        uint8 PRICE_FEED_DECIMALS = nativeTokenUsdPriceFeed.decimals();
        (, int256 price,,,) = nativeTokenUsdPriceFeed.latestRoundData();
        if (price <= 0) revert InvalidNativeTokenPrice();
        return uint256(price) * 10**(18 - PRICE_FEED_DECIMALS);
    }

    function calculateTokenAmount(uint256 _contributionAmount, bool _isNativeToken, address _stablecoin) internal view returns (uint256) {
        uint256 contributionUSD;
        if (_isNativeToken) {
            uint256 nativeTokenPrice = getLatestNativeTokenPrice();
            contributionUSD = _contributionAmount * nativeTokenPrice / 1e18;
        } else {
            if (!acceptedStablecoins[_stablecoin]) revert InvalidStablecoin();
            uint256 stDecimals = stablecoinDecimals[_stablecoin];
            contributionUSD = _contributionAmount * 10**(18 - stDecimals);
        }
        return contributionUSD * 10**saleTokenDecimals / tokenPriceUSD;
    }

    function buyWithNativeToken() public payable nonReentrant whenNotPaused {
        if (saleStartTime == 0 || block.timestamp < saleStartTime) revert SaleNotStarted();
        if (block.timestamp > saleEndTime) revert SaleIsEndedAlready();
        if (msg.value == 0) revert InvalidContributionAmount();

        uint256 tokenAmount = calculateTokenAmount(msg.value, true, address(0));
        if (totalTokensSold + tokenAmount > totalTokensForSale) revert ExceedsAvailableTokens();

        (bool sent,) = paymentReceiver.call{value: msg.value}("");
        if (!sent) revert TransferFailed();

        uint256 nativeTokenPrice = getLatestNativeTokenPrice();
        uint256 contributionUSD = msg.value * nativeTokenPrice / 1e18;

        UserInfo storage user = userInfo[msg.sender];
        unchecked {
            user.contribution += contributionUSD;
            user.tokensBought += tokenAmount;
            totalTokensSold += tokenAmount;
            totalContributionUSD += contributionUSD;
        }

        emit TokensPurchased(msg.sender, tokenAmount, contributionUSD, "Native Token");
    }

    function buyWithStablecoin(address _stablecoin, uint256 _amount) external nonReentrant whenNotPaused {
        if (saleStartTime == 0 || block.timestamp < saleStartTime) revert SaleNotStarted();
        if (block.timestamp > saleEndTime) revert SaleIsEndedAlready();
        if (_amount == 0) revert InvalidContributionAmount();
        if (!acceptedStablecoins[_stablecoin]) revert InvalidStablecoin();

        uint256 tokenAmount = calculateTokenAmount(_amount, false, _stablecoin);
        if (totalTokensSold + tokenAmount > totalTokensForSale) revert ExceedsAvailableTokens();

        IERC20(_stablecoin).safeTransferFrom(msg.sender, paymentReceiver, _amount);

        UserInfo storage user = userInfo[msg.sender];
        unchecked {
            user.contribution += _amount;
            user.tokensBought += tokenAmount;
            totalTokensSold += tokenAmount;
            totalContributionUSD += _amount * 10**(18 - stablecoinDecimals[_stablecoin]);
        }

        emit TokensPurchased(msg.sender, tokenAmount, _amount, "Stablecoin");
    }

    function claimTokens() external nonReentrant {
        if (!saleEnded) revert SaleNotEnded();
        if (block.timestamp < claimStartTime) revert ClaimingNotStarted();
        
        UserInfo storage user = userInfo[msg.sender];
        if (user.tokensBought == 0) revert NoTokensToClaim();
        if (user.claimed) revert TokensAlreadyClaimed();

        uint256 tokensToClaim = user.tokensBought;
        user.claimed = true;
        saleToken.safeTransfer(msg.sender, tokensToClaim);

        emit TokensClaimed(msg.sender, tokensToClaim);
    }

    function withdrawFunds() external onlyOwner {
        if (!saleEnded) revert SaleNotStarted();
        uint256 nativeTokenBalance = address(this).balance;
        if (nativeTokenBalance > 0) {
            (bool sent,) = payable(owner()).call{value:nativeTokenBalance}("");
            if (!sent) revert TransferFailed();
        }
        
        address[] memory stablecoins = getAcceptedStablecoins();
        for (uint256 i = 0; i < stablecoins.length; i++) {
            IERC20 stablecoin = IERC20(stablecoins[i]);
            uint256 balance = stablecoin.balanceOf(address(this));
            if (balance > 0) {
                stablecoin.safeTransfer(owner(), balance);
            }
        }
    }
    
    /// @dev set sale token price in usd
    /// @param _newPrice: token price in usd
    /// amount in wei upto 18 decimals. input examples given below
    /// 1e18 - 1 usd == 1000000000000000000 
    /// 1e17 - 0.1 usd == 100000000000000000
    /// 1e16 - 0.01 usd == 10000000000000000
    function setTokenPriceUSD(uint256 _newPrice) external onlyOwner {
        if (_newPrice == 0) revert InvalidPrice();
        tokenPriceUSD = _newPrice;
        emit TokenPriceUpdated(_newPrice);
    }
    
    ///@dev pause sale globally
    function pauseSale() external onlyOwner {
        _pause();
        emit SalePaused(block.timestamp);
    }
    
    /// @dev unpause sale globally
    function unpauseSale() external onlyOwner {
        _unpause();
        emit SaleUnpaused(block.timestamp);
    }
    
    /// @dev update total tokens for sale globally
    /// @param _newTotalTokens: new token amount
    function setTotalTokensForSale(uint256 _newTotalTokens) external onlyOwner {
        if (_newTotalTokens <= totalTokensSold) revert InvalidTotalTokens();
        totalTokensForSale = _newTotalTokens;
        emit TotalTokensUpdated(_newTotalTokens);
    }
    
    /// @return remaining tokens for sale
    function getRemainingTokens() public view returns (uint256) {
        return totalTokensForSale - totalTokensSold;
    }
    
    /// @return tokens for sale without decimals
    function getTokensForSaleWithoutDecimals() public view returns (uint256) {
        return totalTokensForSale / (10**saleTokenDecimals);
    }
    
    /// @return contribution of user, tokens bought and claim status
    function getUserInfo(address _user) external view returns (uint256 contribution, uint256 tokensBought, bool claimed) {
        UserInfo memory user = userInfo[_user];
        return (user.contribution, user.tokensBought, user.claimed);
    }
    
    /// @dev update sale duration globally
    /// @param _saleEndTime: unixTimeStamp when sale ends
    function UpdateSaleDuration(uint256 _saleEndTime) external onlyOwner {
        if (saleEnded) revert SaleIsEndedAlready();
        if(_saleEndTime > block.timestamp){
        saleEndTime = _saleEndTime;
        }
        emit SaleExtended(saleEndTime);
    }
    
    /// @dev recover any erc20 token apart from sale token
    function recoverToken(address token, uint256 amount) external onlyOwner {
        if (token == address(saleToken)) revert InvalidAddress();
        IERC20(token).safeTransfer(owner(), amount);
    }
    
    /// @return accepted stablecoin list
    function getAcceptedStablecoins() public view returns (address[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < 10; i++) { // Assuming a maximum of 10 stablecoins
            if (acceptedStablecoins[address(uint160(i))]) {
                count++;
            }
        }
        address[] memory stablecoins = new address[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < 10; i++) {
            if (acceptedStablecoins[address(uint160(i))]) {
                stablecoins[index] = address(uint160(i));
                index++;
            }
        }
        return stablecoins;
    }
}
