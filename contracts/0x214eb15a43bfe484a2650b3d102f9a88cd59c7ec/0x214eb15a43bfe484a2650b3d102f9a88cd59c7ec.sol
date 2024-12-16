// Sources flattened with hardhat v2.22.3 https://hardhat.org

// SPDX-License-Identifier: GPL-2.0-or-later AND MIT

pragma abicoder v2;

// File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.9.6

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

pragma solidity ^0.8.17;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     *
     * Furthermore, `isContract` will also return true if the target contract within
     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
     * which only has an effect at the end of a transaction.
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

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
     * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}


// File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.9.6

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/Initializable.sol)

pragma solidity ^0.8.17;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     * @custom:oz-retyped-from bool
     */
    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
     * constructor.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        bool isTopLevelCall = !_initializing;
        require(
            (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
            "Initializable: contract is already initialized"
        );
        _initialized = 1;
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: setting the version to 255 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint8 version) {
        require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
        _initialized = version;
        _initializing = true;
        _;
        _initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized != type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint8) {
        return _initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _initializing;
    }
}


// File @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20PermitUpgradeable.sol@v4.9.6

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.4) (token/ERC20/extensions/IERC20Permit.sol)

pragma solidity ^0.8.17;

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 *
 * ==== Security Considerations
 *
 * There are two important considerations concerning the use of `permit`. The first is that a valid permit signature
 * expresses an allowance, and it should not be assumed to convey additional meaning. In particular, it should not be
 * considered as an intention to spend the allowance in any specific way. The second is that because permits have
 * built-in replay protection and can be submitted by anyone, they can be frontrun. A protocol that uses permits should
 * take this into consideration and allow a `permit` call to fail. Combining these two aspects, a pattern that may be
 * generally recommended is:
 *
 * ```solidity
 * function doThingWithPermit(..., uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public {
 *     try token.permit(msg.sender, address(this), value, deadline, v, r, s) {} catch {}
 *     doThing(..., value);
 * }
 *
 * function doThing(..., uint256 value) public {
 *     token.safeTransferFrom(msg.sender, address(this), value);
 *     ...
 * }
 * ```
 *
 * Observe that: 1) `msg.sender` is used as the owner, leaving no ambiguity as to the signer intent, and 2) the use of
 * `try/catch` allows the permit to fail and makes the code tolerant to frontrunning. (See also
 * {SafeERC20-safeTransferFrom}).
 *
 * Additionally, note that smart contract wallets (such as Argent or Safe) are not able to produce permit signatures, so
 * contracts should have entry points that don't rely on permit.
 */
interface IERC20PermitUpgradeable {
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


// File @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol@v4.9.6

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.17;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Upgradeable {
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
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
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
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}


// File @openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol@v4.9.6

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.3) (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.17;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20Upgradeable {
    using AddressUpgradeable for address;

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20Upgradeable token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20Upgradeable token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    /**
     * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeIncreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
    }

    /**
     * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeDecreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
        }
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Meant to be used with tokens that require the approval
     * to be set to zero before setting it to a non-zero value, such as USDT.
     */
    function forceApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
        bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
            _callOptionalReturn(token, approvalCall);
        }
    }

    /**
     * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
     * Revert on invalid signature.
     */
    function safePermit(
        IERC20PermitUpgradeable token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
     */
    function _callOptionalReturnBool(IERC20Upgradeable token, bytes memory data) private returns (bool) {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
        // and not revert is the subcall reverts.

        (bool success, bytes memory returndata) = address(token).call(data);
        return
            success && (returndata.length == 0 || abi.decode(returndata, (bool))) && AddressUpgradeable.isContract(address(token));
    }
}


// File @uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol@v1.0.1

// Original license: SPDX_License_Identifier: GPL-2.0-or-later
pragma solidity >=0.5.0;

/// @title Callback for IUniswapV3PoolActions#swap
/// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
interface IUniswapV3SwapCallback {
    /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
    /// @dev In the implementation you must pay the pool tokens owed for the swap.
    /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
    /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
    /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
    /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
    /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}


// File @uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol@v1.4.4

// Original license: SPDX_License_Identifier: GPL-2.0-or-later
pragma solidity >=0.7.5;
// Original pragma directive: pragma abicoder v2

/// @title Router token swapping functionality
/// @notice Functions for swapping tokens via Uniswap V3
interface ISwapRouter is IUniswapV3SwapCallback {
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

    /// @notice Swaps `amountIn` of one token for as much as possible of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    /// @notice Swaps `amountIn` of one token for as much as possible of another along the specified path
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactInputParams` in calldata
    /// @return amountOut The amount of the received token
    function exactInput(ExactInputParams calldata params) external payable returns (uint256 amountOut);

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

    /// @notice Swaps as little as possible of one token for `amountOut` of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutputSingle(ExactOutputSingleParams calldata params) external payable returns (uint256 amountIn);

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutput(ExactOutputParams calldata params) external payable returns (uint256 amountIn);
}


// File contracts/AddressUtils.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;

library AddressUtils {
    modifier onlyContract(address account_) {
        requireNonZeroAddress(account_);

        require(isContract(account_), 'AddressUtils: Only contracts allowed');
        _;
    }

    modifier notContract(address account_) {
        requireNonZeroAddress(account_);

        require(!isContract(account_), 'AddressUtils: Contracts not allowed');
        _;
    }

    function isContract(address account_) internal view returns (bool) {
        return account_.code.length > 0;
    }

    function requireNonZeroAddress(address account_) internal pure {
        require(
            account_ != address(0),
            'AddressUtils: Zero address not allowed'
        );
    }

    function requireZeroAddress(address account_) internal pure {
        require(
            account_ == address(0),
            'AddressUtils: Non Zero address'
        );
    }

    function requireIsContract(address account_) internal view {
        requireNonZeroAddress(account_);
        require(
            isContract(account_),
            'AddressUtils: Account is not a contract'
        );
    }

    function requireNotContract(address account_) internal view {
        requireNonZeroAddress(account_);
        require(!isContract(account_), 'AddressUtils: Account is a contract');
    }

    function functionCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                0,
                'AddressUtils: low-level call failed'
            );
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            'AddressUtils: insufficient balance for call'
        );
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                requireIsContract(target);
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(
        bytes memory returndata,
        string memory errorMessage
    ) private pure {
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


// File contracts/Admin.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;

abstract contract Admin is Initializable {
    using AddressUtils for address;

    address private _admin;

    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);

    function __Admin_init(address admin_) internal onlyInitializing {
        admin_.requireNotContract();
        _admin = admin_;
    }

    modifier onlyAdmin() {
        require(msg.sender == _admin, 'MemoContract: caller is not admin');
        _;
    }

    function getAdmin() public view returns (address) {
        return _admin;
    }

    function changeAdmin(address newAdmin_) external onlyAdmin {
        newAdmin_.requireNotContract();
        emit AdminChanged(_admin, newAdmin_);
        _admin = newAdmin_;
    }
}


// File contracts/BaseContract.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;


abstract contract BaseContract is Initializable, Admin {
    uint8 internal _initializedVersion;

    function getContractInitVersion() public view returns (uint8) {
        return _initializedVersion;
    }
}


// File contracts/IERC20Extended.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20Extended {
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function nonces(address owner) external view returns (uint256);
}


// File contracts/ERC20Utils.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;



struct PermitData {
    address owner;
    address spender;
    uint256 value;
    uint256 deadline;
    uint8 v;
    bytes32 r;
    bytes32 s;
}

library ERC20Utils {
    using SafeERC20Upgradeable for IERC20Upgradeable;

    /**
     * Permits the specified spender to spend the specified amount of tokens on behalf of the owner.
     *
     * @param token_ The address of the ERC20 token contract.
     * @param data_ The permit data, including the owner, spender, value, deadline, and signature parameters.
     */
    function _permitWithAuthorization(
        address token_,
        PermitData calldata data_
    ) internal {
        IERC20Extended token = IERC20Extended(token_);

        try token.nonces(data_.owner) returns (uint256 nonceBefore) {
            token.permit(
                data_.owner,
                data_.spender,
                data_.value,
                data_.deadline,
                data_.v,
                data_.r,
                data_.s
            );
            uint256 nonceAfter = token.nonces(data_.owner);
            require(nonceAfter == nonceBefore + 1, 'Permit failed, nonce mismatch');
        } catch {
            revert('Permit token does not support nonces');
        }
    }

    function _erc20BalanceOf(
        address token_,
        address account_
    ) internal view returns (uint256) {
        return IERC20Upgradeable(token_).balanceOf(account_);
    }

    function _erc20Approve(
        address token_,
        address spender_,
        uint256 amount_
    ) internal {
        IERC20Upgradeable(token_).safeApprove(spender_, amount_);
    }

    function _transferErc20TokensFromContract(
        address token_,
        address recipient_,
        uint256 amount_
    ) internal {
        IERC20Upgradeable(token_).safeTransfer(recipient_, amount_);
    }

    function _transferErc20TokensFromSender(
        address token_,
        address recipient_,
        uint256 amount_
    ) internal {
        IERC20Upgradeable(token_).safeTransferFrom(
            msg.sender,
            recipient_,
            amount_
        );
    }

    function _safeTransferFrom(
        address token_,
        address owner_,
        address recipient_,
        uint256 amount_
    ) internal {
        IERC20Upgradeable(token_).safeTransferFrom(
            owner_,
            recipient_,
            amount_
        );
    }

    function _getErc20Allowance(
        address token_,
        address owner_,
        address spender_
    ) internal view returns (uint256) {
        return IERC20Upgradeable(token_).allowance(owner_, spender_);
    }
}


// File contracts/IWETH.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;

interface IWETH {
    function balanceOf(address owner) external view returns (uint);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function deposit() external payable;

    function withdraw(uint wad) external;
}


// File contracts/TokenWhitelist.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;



abstract contract TokenWhitelist is BaseContract {
    using AddressUtils for address;

    mapping(address => address) internal _outputTokenToWithdrawers;

    function isValidOutputToken(address token_) public view returns (bool) {
        return getWithdrawerWallet(token_) != address(0);
    }

    function whitelistOutputToken(
        address token_,
        address withdrawer_
    ) external onlyAdmin returns (bool) {
        withdrawer_.requireNotContract();
        require(
            getWithdrawerWallet(token_) == address(0),
            'MemoContract: Output token already whitelisted'
        );
        _outputTokenToWithdrawers[token_] = withdrawer_;
        return true;
    }

    function removeOutputToken(address token_) external onlyAdmin returns (bool) {
        require(
            getWithdrawerWallet(token_) != address(0),
            'MemoContract: Output token not whitelisted'
        );
        delete _outputTokenToWithdrawers[token_];
        return true;
    }

    function getWithdrawerWallet(address token_) public view returns (address) {
        token_.requireIsContract();
        return _outputTokenToWithdrawers[token_];
    }
}


// File contracts/SwapFee.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;


abstract contract SwapFee is TokenWhitelist {
    using AddressUtils for address;

    address internal _swapFeeWallet;
    uint256 internal _swapFeeBps;

    event SwapFeeWalletChanged(
        address indexed oldWallet,
        address indexed newWallet
    );

    event SwapFeeBpsChanged(
        uint256 oldFee,
        uint256 newFee
    );

    function setSwapFeeWallet(
        address swapFeeWallet_
    ) external onlyAdmin returns (bool) {
        return _setSwapFeeWallet(swapFeeWallet_);
    }

    function _setSwapFeeWallet(
        address swapFeeWallet_
    ) internal returns (bool) {
        swapFeeWallet_.requireNotContract();
        emit SwapFeeWalletChanged(_swapFeeWallet, swapFeeWallet_);
        _swapFeeWallet = swapFeeWallet_;
        return true;
    }

    function getSwapFeeWallet() external view returns (address) {
        return _swapFeeWallet;
    }

    function setSwapFee(uint256 swapFeeBps_) external onlyAdmin returns (bool) {
        return _setSwapFeeBps(swapFeeBps_);
    }

    function _setSwapFeeBps(uint256 swapFeeBps_) internal returns (bool) {
        emit SwapFeeBpsChanged(_swapFeeBps, swapFeeBps_);
        _swapFeeBps = swapFeeBps_;
        return true;
    }

    function getSwapFeeBps() external view returns (uint256) {
        return _swapFeeBps;
    }
}


// File contracts/WethUtils.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;



abstract contract WethUtils is SwapFee {
    using AddressUtils for address;

    IWETH internal _wethToken;

    event WethTokenChanged(address indexed oldWeth, address indexed newWeth);

    function setWethToken(
        address wethToken_
    ) external onlyAdmin returns (bool) {
        return _setWethToken(wethToken_);
    }

    function _setWethToken(
        address wethToken_
    ) internal returns (bool) {
        wethToken_.requireIsContract();
        emit WethTokenChanged(address(_wethToken), wethToken_);
        _wethToken = IWETH(wethToken_);
        return true;
    }

    function wethToken() external view returns (address) {
        return address(_wethToken);
    }

    // wrap ETH to WETH, ETH will be deducted from contract balance and WETH will be added to contract balance
    function _wrapReceivedEth() internal returns (bool) {
        uint256 wethBalanceBefore = _wethToken.balanceOf(address(this));
        _wethToken.deposit{value: msg.value}();

        require(
            _wethToken.balanceOf(address(this)) ==
                wethBalanceBefore + msg.value,
            'MemoContract: WETH_RECEIVED_NOT_EQUAL_AMOUNT'
        );

        return true;
    }
}


// File contracts/MemoSwapV1.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;




struct MemoSwapV2Data {
    address sourceToken;
    uint256 sourceAmount;
    address outputToken;
    uint256 minTokenOut;
    uint24 poolFee;
    uint160 sqrtPriceLimitX96;
    uint256 deadline;
}

abstract contract MemoSwapV1 is WethUtils {
    using AddressUtils for address;
    using ERC20Utils for address;

    ISwapRouter internal _swapRouter;

    event UniswapRouterChanged(
        address indexed oldSwapRouter,
        address indexed newSwapRouter
    );

    function setUniswapRouter(
        address routerAddress_
    ) external onlyAdmin returns (bool) {
        return _setUniswapRouter(routerAddress_);
    }

    function _setUniswapRouter(
        address routerAddress_
    ) internal returns (bool) {
        routerAddress_.requireIsContract();
        emit UniswapRouterChanged(address(_swapRouter), routerAddress_);
        _swapRouter = ISwapRouter(routerAddress_);
        return true;
    }

    function uniswapRouter() external view returns (address) {
        return address(_swapRouter);
    }

    function _swapSourceTokenToOutputToken(
        MemoSwapV2Data calldata memoSwapData_
    ) internal returns (uint256 amountOut) {
        if (memoSwapData_.sourceToken == memoSwapData_.outputToken) {
            return memoSwapData_.sourceAmount;
        }
        
        require(memoSwapData_.minTokenOut > 0, 'MemoSwapV2: minTokenOut is Zero');
        require(memoSwapData_.poolFee > 0 && memoSwapData_.poolFee <= 10000, 'MemoSwapV2: Invalid pool fee');

        amountOut = _swapExactInputSingle(
            memoSwapData_.sourceToken,
            memoSwapData_.sourceAmount,
            memoSwapData_.outputToken,
            memoSwapData_.poolFee,
            memoSwapData_.minTokenOut,
            memoSwapData_.sqrtPriceLimitX96,
            memoSwapData_.deadline,
            address(this)
        );
    }

    // swap sourceToken_ to outputToken StableCoin
    // minAmountDstToken_,  this value should be calculated using our SDK or an onchain price oracle
    function _swapExactInputSingle(
        address sourceToken_,
        uint256 sourceAmount_,
        address outputToken_,
        uint24 poolFee_,
        uint256 minAmountDstToken_,
        uint160 sqrtPriceLimitX96_,
        uint256 deadline_,
        address usdcWithdrawer_
    ) internal returns (uint256 amountOut) {
        sourceToken_._erc20Approve(address(_swapRouter), sourceAmount_);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: sourceToken_,
                tokenOut: outputToken_,
                fee: poolFee_,
                recipient: usdcWithdrawer_,
                deadline: deadline_,
                amountIn: sourceAmount_,
                amountOutMinimum: minAmountDstToken_,
                sqrtPriceLimitX96: sqrtPriceLimitX96_
            });

        amountOut = _swapRouter.exactInputSingle(params);
    }
}


// File contracts/MemoTransfer.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;



abstract contract MemoTransfer is MemoSwapV1 {
    using AddressUtils for address;
    using ERC20Utils for address;

    event WithdrawOutputToken(
        address indexed from,
        address indexed to,
        address indexed outputToken,
        uint256 amount
    );

    event SwapAndTransferOutputToken(
        address indexed from,
        address indexed recipientWallet,
        address indexed outputToken,
        address sourceToken,
        uint256 sourceAmount,
        uint256 outputAmount
    );

    event MemoLogged(string memo);

    /**
     * @notice Transfers an output token from the permit signer or caller to the withdrawer wallet with an attached memo.
     * @dev This function transfers a specified amount of an output token to withdrawer wallet.
     *      It supports both direct transfers and transfers using permit data for gasless transactions. The function also logs the memo provided.
     * @param permitData_ Struct containing permit data to allow the contract to transfer the output token from the owner's account.
     *                    If the owner is zero address, it indicates that approvals are used instead of permits.
     * @param outputToken_ The address of the output token to be transferred.
     * @param memo_ A string memo that will be logged with the transaction.
     * @return bool Returns true if the transfer is successful.
     */
    function transferOutputTokenWithMemo(
        PermitData calldata permitData_, // spender == memoContract contract, owner == zero address (when using approvals or usePermit = false)
        address outputToken_,
        string memory memo_
    ) external returns (bool) {
        _assertInput(outputToken_);

        address withdrawerWallet = getWithdrawerWallet(outputToken_);
        address owner = _processPermitOrSender(outputToken_, permitData_);

        outputToken_._safeTransferFrom(
            owner,
            withdrawerWallet,
            permitData_.value
        );
        
        emit WithdrawOutputToken(owner, withdrawerWallet, outputToken_, permitData_.value);
        emit MemoLogged(memo_);

        return true;
    }

    function _assertInput(address outputToken_) internal view {
        require(isValidOutputToken(outputToken_), 'MemoContractV1: Invalid output token');
    }

    function calculateSwapFee(
        uint256 usdcReceived_
    ) public view returns (uint256) {
        return (usdcReceived_ * _swapFeeBps) / 10000;
    }

    /**
     * @notice Swaps a source token for an output token and transfers the output token to our withdrawer wallet, with an attached memo.
     * @dev This function allows the permit signer or caller to swap a specified amount of a source token for an output token and transfer the output token to our withdrawer wallet.
     *      It supports both direct transfers and transfers using permit data for gasless transactions. The function also logs the memo provided.
     * @param memoSwapData_ Struct containing the details of the swap operation, including source token, source amount, output token, and other swap parameters.
     * @param permitMemoData_ Struct containing permit data to allow the contract to transfer the source token from the owner's account.
     *                        If the owner is zero address, it indicates that approvals are used instead of permits.
     * @param memo_ A string memo that will be logged with the transaction.
     * @return bool Returns true if the operation is successful.
     */
    function swapAndTransferOutputTokenWithMemo(
        MemoSwapV2Data calldata memoSwapData_,
        PermitData calldata permitMemoData_,
        string memory memo_
    ) external payable returns (bool) {
        _assertInputSwapData(memoSwapData_);

        address tokenOwner = _processPermitOrSender(memoSwapData_.sourceToken, permitMemoData_);

        if (msg.value > 0) {
            _wrapEthToWeth(memoSwapData_);
        } else {
            memoSwapData_.sourceToken._safeTransferFrom(
                tokenOwner,
                address(this),
                memoSwapData_.sourceAmount
            );
        }

        uint256 outputTokenAmountReceived = _swapSourceTokenToOutputToken(memoSwapData_);

        uint256 swapFee = _transferSwapFee(outputTokenAmountReceived, memoSwapData_.outputToken);

        uint256 actualOutputTokenWithdrawn = outputTokenAmountReceived - swapFee;
        memoSwapData_.outputToken._transferErc20TokensFromContract(
            getWithdrawerWallet(memoSwapData_.outputToken),
            actualOutputTokenWithdrawn
        );

        emit SwapAndTransferOutputToken(
            tokenOwner,
            getWithdrawerWallet(memoSwapData_.outputToken),
            memoSwapData_.outputToken,
            memoSwapData_.sourceToken,
            memoSwapData_.sourceAmount,
            actualOutputTokenWithdrawn
        );
        emit MemoLogged(memo_);

        return true;
    }

    function _assertInputSwapData(MemoSwapV2Data calldata memoSwapData_) internal view {
        require(isValidOutputToken(memoSwapData_.outputToken), 'MemoContractV1: Invalid output token');

        require(
            memoSwapData_.sourceAmount > 0,
            'MemoContractV1: SourceAmount is Zero'
        );
    }

    function _processPermitOrSender(
        address token_,
        PermitData calldata permitMemoData_
    ) internal returns (address) {
        if (permitMemoData_.owner != address(0) && permitMemoData_.value > 0) {
            require(
                permitMemoData_.spender == address(this),
                'MemoContractV1: Spender is not coinflow contract'
            );
            token_._permitWithAuthorization(permitMemoData_);
            return permitMemoData_.owner;
        }
        return msg.sender;
    }

    function _wrapEthToWeth(MemoSwapV2Data calldata memoSwapData_) internal {
        require(
            memoSwapData_.sourceToken == address(_wethToken),
            'MemoSwapV1: Invalid source token'
        );
        require(
            msg.value == memoSwapData_.sourceAmount,
            'Invalid msg.value'
        );

        _wrapReceivedEth();
    }

    function _transferSwapFee(uint256 tokenAmount_, address outputToken_) internal returns (uint256) {
        uint256 swapFee = 0;

        if (_swapFeeBps > 0) {
            swapFee = calculateSwapFee(tokenAmount_);
            outputToken_._transferErc20TokensFromContract(
                _swapFeeWallet,
                swapFee
            );
        }

        return swapFee;
    }
}


// File contracts/MemoContractV1.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.17;



// For first time deployment, call initialize(address admin, wethToken, swapRouter, swapFeeWallet, swapFeeBps)
contract MemoContractV1 is MemoTransfer {
    using AddressUtils for address;
    using ERC20Utils for address;

    uint256[20] private gap_;

    function initialize(
        address admin_,
        address wethToken_,
        address swapRouter_,
        address swapFeeWallet_,
        uint256 swapFeeBps_
    ) external initializer {
        admin_.requireNotContract();
        
        getAdmin().requireZeroAddress();
        __Admin_init(admin_);

        require(
            _initializedVersion == 0,
            'MemoContract: Already initialized'
        );
        _initializedVersion = 1;

        _setUniswapRouter(swapRouter_);
        _setWethToken(wethToken_);
        _setSwapFeeWallet(swapFeeWallet_);
        _setSwapFeeBps(swapFeeBps_);
    }

    function getContractCodeVersion() external pure returns (uint16) {
        return 3;
    }
}
