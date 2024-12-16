// SPDX-License-Identifier: MIT

/*

Liquidity Exchange:

dApp: openliquidity.io

backed by CryptoDo

*/

pragma solidity ^0.8.0;

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC1967 implementation slot:
 * ```solidity
 * contract ERC1967 {
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
 * _Available since v4.9 for `string`, `bytes`._
 */
library StorageSlotUpgradeable {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    struct StringSlot {
        string value;
    }

    struct BytesSlot {
        bytes value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(
        bytes32 slot
    ) internal pure returns (AddressSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(
        bytes32 slot
    ) internal pure returns (BooleanSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(
        bytes32 slot
    ) internal pure returns (Bytes32Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(
        bytes32 slot
    ) internal pure returns (Uint256Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` with member `value` located at `slot`.
     */
    function getStringSlot(
        bytes32 slot
    ) internal pure returns (StringSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
     */
    function getStringSlot(
        string storage store
    ) internal pure returns (StringSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := store.slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` with member `value` located at `slot`.
     */
    function getBytesSlot(
        bytes32 slot
    ) internal pure returns (BytesSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
     */
    function getBytesSlot(
        bytes storage store
    ) internal pure returns (BytesSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := store.slot
        }
    }
}

// File: @openzeppelin/contracts-upgradeable@4.9.2/interfaces/IERC1967Upgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC1967.sol)

pragma solidity ^0.8.0;

/**
 * @dev ERC-1967: Proxy Storage Slots. This interface contains the events defined in the ERC.
 *
 * _Available since v4.8.3._
 */
interface IERC1967Upgradeable {
    /**
     * @dev Emitted when the implementation is upgraded.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Emitted when the admin account has changed.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Emitted when the beacon is changed.
     */
    event BeaconUpgraded(address indexed beacon);
}

// File: @openzeppelin/contracts-upgradeable@4.9.2/proxy/beacon/IBeaconUpgradeable.sol

// OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)

pragma solidity ^0.8.0;

/**
 * @dev This is the interface that {BeaconProxy} expects of its beacon.
 */
interface IBeaconUpgradeable {
    /**
     * @dev Must return an address that can be used as a delegate call target.
     *
     * {BeaconProxy} will check that this address is a contract.
     */
    function implementation() external view returns (address);
}

// File: @openzeppelin/contracts-upgradeable@4.9.2/interfaces/draft-IERC1822Upgradeable.sol

// OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)

pragma solidity ^0.8.0;

/**
 * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
 * proxy whose upgrades are fully controlled by the current implementation.
 */
interface IERC1822ProxiableUpgradeable {
    /**
     * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
     * address.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy.
     */
    function proxiableUUID() external view returns (bytes32);
}

// File: @openzeppelin/contracts-upgradeable@4.9.2/utils/AddressUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

pragma solidity ^0.8.1;

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
    function functionCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                0,
                "Address: low-level call failed"
            );
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
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
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

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data
    ) internal view returns (bytes memory) {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
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
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
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
        return
            verifyCallResultFromTarget(
                target,
                success,
                returndata,
                errorMessage
            );
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

    function _revert(
        bytes memory returndata,
        string memory errorMessage
    ) private pure {
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

// File: @openzeppelin/contracts-upgradeable@4.9.2/proxy/utils/Initializable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/Initializable.sol)

pragma solidity ^0.8.2;

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
            (isTopLevelCall && _initialized < 1) ||
                (!AddressUpgradeable.isContract(address(this)) &&
                    _initialized == 1),
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
        require(
            !_initializing && _initialized < version,
            "Initializable: contract is already initialized"
        );
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

// File: @openzeppelin/contracts-upgradeable@4.9.2/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (proxy/ERC1967/ERC1967Upgrade.sol)

pragma solidity ^0.8.2;

/**
 * @dev This abstract contract provides getters and event emitting update functions for
 * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
 *
 * _Available since v4.1._
 */
abstract contract ERC1967UpgradeUpgradeable is
    Initializable,
    IERC1967Upgradeable
{
    function __ERC1967Upgrade_init() internal onlyInitializing {}

    function __ERC1967Upgrade_init_unchained() internal onlyInitializing {}

    // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
    bytes32 private constant _ROLLBACK_SLOT =
        0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev Returns the current implementation address.
     */
    function _getImplementation() internal view returns (address) {
        return
            StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 implementation slot.
     */
    function _setImplementation(address newImplementation) private {
        require(
            AddressUpgradeable.isContract(newImplementation),
            "ERC1967: new implementation is not a contract"
        );
        StorageSlotUpgradeable
            .getAddressSlot(_IMPLEMENTATION_SLOT)
            .value = newImplementation;
    }

    /**
     * @dev Perform implementation upgrade
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    /**
     * @dev Perform implementation upgrade with additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCall(
        address newImplementation,
        bytes memory data,
        bool forceCall
    ) internal {
        _upgradeTo(newImplementation);
        if (data.length > 0 || forceCall) {
            AddressUpgradeable.functionDelegateCall(newImplementation, data);
        }
    }

    /**
     * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCallUUPS(
        address newImplementation,
        bytes memory data,
        bool forceCall
    ) internal {
        // Upgrades from old implementations will perform a rollback test. This test requires the new
        // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
        // this special case will break upgrade paths from old UUPS implementation to new ones.
        if (StorageSlotUpgradeable.getBooleanSlot(_ROLLBACK_SLOT).value) {
            _setImplementation(newImplementation);
        } else {
            try
                IERC1822ProxiableUpgradeable(newImplementation).proxiableUUID()
            returns (bytes32 slot) {
                require(
                    slot == _IMPLEMENTATION_SLOT,
                    "ERC1967Upgrade: unsupported proxiableUUID"
                );
            } catch {
                revert("ERC1967Upgrade: new implementation is not UUPS");
            }
            _upgradeToAndCall(newImplementation, data, forceCall);
        }
    }

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _ADMIN_SLOT =
        0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Returns the current admin.
     */
    function _getAdmin() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 admin slot.
     */
    function _setAdmin(address newAdmin) private {
        require(
            newAdmin != address(0),
            "ERC1967: new admin is the zero address"
        );
        StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
    }

    /**
     * @dev Changes the admin of the proxy.
     *
     * Emits an {AdminChanged} event.
     */
    function _changeAdmin(address newAdmin) internal {
        emit AdminChanged(_getAdmin(), newAdmin);
        _setAdmin(newAdmin);
    }

    /**
     * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
     * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
     */
    bytes32 internal constant _BEACON_SLOT =
        0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;

    /**
     * @dev Returns the current beacon.
     */
    function _getBeacon() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value;
    }

    /**
     * @dev Stores a new beacon in the EIP1967 beacon slot.
     */
    function _setBeacon(address newBeacon) private {
        require(
            AddressUpgradeable.isContract(newBeacon),
            "ERC1967: new beacon is not a contract"
        );
        require(
            AddressUpgradeable.isContract(
                IBeaconUpgradeable(newBeacon).implementation()
            ),
            "ERC1967: beacon implementation is not a contract"
        );
        StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value = newBeacon;
    }

    /**
     * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
     * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
     *
     * Emits a {BeaconUpgraded} event.
     */
    function _upgradeBeaconToAndCall(
        address newBeacon,
        bytes memory data,
        bool forceCall
    ) internal {
        _setBeacon(newBeacon);
        emit BeaconUpgraded(newBeacon);
        if (data.length > 0 || forceCall) {
            AddressUpgradeable.functionDelegateCall(
                IBeaconUpgradeable(newBeacon).implementation(),
                data
            );
        }
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// File: @openzeppelin/contracts-upgradeable@4.9.2/proxy/utils/UUPSUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/UUPSUpgradeable.sol)

pragma solidity ^0.8.0;

/**
 * @dev An upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an
 * {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
 *
 * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is
 * reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing
 * `UUPSUpgradeable` with a custom implementation of upgrades.
 *
 * The {_authorizeUpgrade} function must be overridden to include access restriction to the upgrade mechanism.
 *
 * _Available since v4.1._
 */
abstract contract UUPSUpgradeable is
    Initializable,
    IERC1822ProxiableUpgradeable,
    ERC1967UpgradeUpgradeable
{
    function __UUPSUpgradeable_init() internal onlyInitializing {}

    function __UUPSUpgradeable_init_unchained() internal onlyInitializing {}

    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
    address private immutable __self = address(this);

    /**
     * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
     * a proxy contract with an implementation (as defined in ERC1967) pointing to self. This should only be the case
     * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
     * function through ERC1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
     * fail.
     */
    modifier onlyProxy() {
        require(
            address(this) != __self,
            "Function must be called through delegatecall"
        );
        require(
            _getImplementation() == __self,
            "Function must be called through active proxy"
        );
        _;
    }

    /**
     * @dev Check that the execution is not being performed through a delegate call. This allows a function to be
     * callable on the implementing contract but not through proxies.
     */
    modifier notDelegated() {
        require(
            address(this) == __self,
            "UUPSUpgradeable: must not be called through delegatecall"
        );
        _;
    }

    /**
     * @dev Implementation of the ERC1822 {proxiableUUID} function. This returns the storage slot used by the
     * implementation. It is used to validate the implementation's compatibility when performing an upgrade.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy. This is guaranteed by the `notDelegated` modifier.
     */
    function proxiableUUID()
        external
        view
        virtual
        override
        notDelegated
        returns (bytes32)
    {
        return _IMPLEMENTATION_SLOT;
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     *
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function upgradeTo(address newImplementation) public virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
     * encoded in `data`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     *
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function upgradeToAndCall(
        address newImplementation,
        bytes memory data
    ) public payable virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, data, true);
    }

    /**
     * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
     * {upgradeTo} and {upgradeToAndCall}.
     *
     * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
     *
     * ```solidity
     * function _authorizeUpgrade(address) internal override onlyOwner {}
     * ```
     */
    function _authorizeUpgrade(address newImplementation) internal virtual;

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// File: @openzeppelin/contracts-upgradeable@4.9.2/security/ReentrancyGuardUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

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
abstract contract ReentrancyGuardUpgradeable is Initializable {
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

    function __ReentrancyGuard_init() internal onlyInitializing {
        __ReentrancyGuard_init_unchained();
    }

    function __ReentrancyGuard_init_unchained() internal onlyInitializing {
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

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

// File: @openzeppelin/contracts-upgradeable@4.9.2/utils/ContextUpgradeable.sol

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

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
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {}

    function __Context_init_unchained() internal onlyInitializing {}

    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// File: @openzeppelin/contracts-upgradeable@4.9.2/access/OwnableUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init() internal onlyInitializing {
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal onlyInitializing {
        _transferOwnership(_msgSender());
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
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
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

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

// File: liq_flattened.sol

// File: liquidity.sol

pragma solidity ^0.8.0;

interface ITeamFinanceLocker {
    function lockedToken(
        uint256 lockId
    ) external view returns (address, address, uint256, uint256, bool);

    function transferLocks(uint256 lockId, address newOwner) external;
}

contract OpenLiquidityExchange is
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    UUPSUpgradeable
{
    ITeamFinanceLocker public liquidityLocker;

    struct Deal {
        address borrower;
        address lpToken;
        uint256 lockIndex; // its lockId on TM contract
        uint256 dealAmount;
        uint256 interestRate;
        uint256 loanDuration;
        uint256 startTime;
        address lender;
        bool isRepaid;
        bool isActive;
        bool collateralClaimed;
    }

    struct Auction {
        address owner;
        address highestBidOwner;
        address lpToken;
        uint256 lockIndex; // its lockId on TM contract
        uint256 startPrice;
        uint256 imeddiatelySellPrice;
        uint256 bidStep;
        uint256 duration;
        uint256 startTime;
        bool isActive;
        bool isFinishedImmediately;
        bool immediatelySell;
        bool isRewardClaimed;
    }

    mapping(address => uint256[]) private userDeals;
    mapping(address => uint256[]) private userAuction;
    mapping(uint256 => bool) public auctionClaimed;

    mapping(uint256 => mapping(address => uint256)) bids;
    mapping(uint256 => Auction) public auctions;
    mapping(uint256 => Deal) public loans;
    uint256 public nextAuctionId;
    uint256 public nextLoanId;
    uint256 public ownerFee;
    address public feeReceiver;

    mapping(address => address) referrals;
    uint256 public referralFee = 2000; // 20% from ownerFee

    uint256 public ownerFeeAuction;
    uint256[] public loansDurations;
    uint256[] public ownerFeesLoan;

    // События
    event DealInitialized(
        uint256 indexed dealId,
        address indexed borrower,
        address lpToken,
        uint256 lockIndex,
        uint256 dealAmount,
        uint256 interestRate,
        uint256 loanDuration
    );
    event DealActivated(uint256 indexed dealId, address indexed activator);
    event DealMade(uint256 indexed dealId, address indexed lender);
    event LoanRepaid(uint256 indexed dealId, address indexed repayer);
    event CollateralClaimed(uint256 indexed dealId, address indexed claimer);
    event AuctionStarted(
        uint256 indexed auctionId,
        address indexed owner,
        address lpToken,
        uint256 lockIndex,
        uint256 startPrice,
        uint256 imeddiatelySellPrice,
        uint256 bidStep,
        uint256 duration,
        bool immediatelySell
    );
    event AuctionChanged(
        uint256 indexed auctionId,
        address indexed owner,
        address lpToken,
        uint256 lockIndex,
        uint256 startPrice,
        uint256 imeddiatelySellPrice,
        uint256 bidStep,
        uint256 duration,
        bool immediatelySell
    );
    event AuctionActivated(
        uint256 indexed auctionId,
        address indexed activator
    );
    event BidMade(
        uint256 indexed auctionId,
        address indexed bidder,
        uint256 amount,
        uint256 timestamp
    );
    event AuctionWon(uint256 indexed auctionId, address indexed winner);
    event AuctionPaymentClaimed(
        uint256 indexed auctionId,
        address indexed owner,
        uint256 amount,
        uint256 timestamp
    );
    event BidWithdrawn(
        uint256 indexed auctionId,
        address indexed bidder,
        uint256 amount,
        uint256 timestamp
    );
    event ImmediatelyBought(
        uint256 indexed auctionId,
        uint256 amount,
        uint256 timestamp
    );

    function initialize(
        ITeamFinanceLocker _liquidityLocker,
        uint256 _ownerFeeAuction,
        address _feeReceiver
    ) public initializer {
        __Ownable_init();
        __ReentrancyGuard_init();
        require(_ownerFeeAuction < 10000, "Owner fee must be less than 10000");
        require(
            _feeReceiver != address(0),
            "Fee receiver cannot be zero address"
        );
        liquidityLocker = _liquidityLocker;
        ownerFeeAuction = _ownerFeeAuction;
        feeReceiver = _feeReceiver;

        loansDurations = [7, 14, 30, 60, 180, 365];
        ownerFeesLoan = [100, 200, 400, 500, 700, 1000]; // 100 = 1%
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function setLiquidityLocker(
        ITeamFinanceLocker _liquidityLocker
    ) external onlyOwner {
        liquidityLocker = _liquidityLocker;
    }

    function setFeeReceiver(address _feeReceiver) external onlyOwner {
        require(
            _feeReceiver != address(0),
            "Fee receiver cannot be zero address"
        );
        feeReceiver = _feeReceiver;
    }

    function setReferralFee(uint256 _newReferralFee) external onlyOwner {
        require(
            _newReferralFee <= 10000,
            "Referral Fee must be no greater than 10000"
        );
        referralFee = _newReferralFee;
    }

    function setOwnerFeeAuction(uint256 _ownerFeeAuction) external onlyOwner {
        require(_ownerFeeAuction < 10000, "Owner fee must be less than 10000");
        ownerFeeAuction = _ownerFeeAuction;
    }

    function setOwnerFeeLoans(uint256[] memory _durationsInDays, uint256[] memory _ownerFees) public onlyOwner {
        require(_durationsInDays.length == _ownerFees.length, "Length mismatch");

        loansDurations = _durationsInDays;
        ownerFeesLoan = _ownerFees;
    }

    function getOwnerFee(uint256 duration) internal view returns (uint256) {
        for (uint256 i = 0; i < loansDurations.length; i++) {
            if (duration <= loansDurations[i]) {
                return ownerFeesLoan[i];
            }
        }

        return ownerFeesLoan[ownerFeesLoan.length - 1];
    }

    function checkLiquidityOwner(
        address expectedOwner,
        address lpToken, // doesn't using but needed cause other contract has this arg and we want to have a maximal compatibility
        uint256 _lockId
    ) public view returns (bool) {
        (, address owner, , ,) = liquidityLocker.lockedToken(
            _lockId
        );
        return owner == expectedOwner;
    }

    function getUserLoans(
        address _address
    ) external view returns (uint256[] memory) {
        return userDeals[_address];
    }

    function getUserAuctions(
        address _address
    ) external view returns (uint256[] memory) {
        return userAuction[_address];
    }

    function initializeLoan(
        address lpToken,
        uint256 lockIndex,
        uint256 dealAmount,
        uint256 interestRate,
        uint256 loanDuration
    ) public {
        require(loanDuration > 0, "Loan duration must be greater than 0");
        require(
            checkLiquidityOwner(msg.sender, lpToken, lockIndex),
            "User does not owner of this lock"
        );
        require(interestRate > 0, "interestRate must be greater than 0");
        require(dealAmount > 0, "dealAmount must be greater than 0");

        loans[nextLoanId] = Deal({
            borrower: msg.sender,
            lpToken: lpToken,
            lockIndex: lockIndex,
            dealAmount: dealAmount,
            interestRate: interestRate,
            loanDuration: loanDuration,
            startTime: 0,
            lender: address(0),
            isRepaid: false,
            isActive: false,
            collateralClaimed: false
        });

        emit DealInitialized(
            nextLoanId,
            msg.sender,
            lpToken,
            lockIndex,
            dealAmount,
            interestRate,
            loanDuration
        );

        userDeals[msg.sender].push(nextLoanId);

        nextLoanId++;
    }

    function placeLoanOffer(uint256 dealId) external {
        Deal storage deal = loans[dealId];
        require(deal.borrower != address(0), "Deal is empty");
        require(
            checkLiquidityOwner(address(this), deal.lpToken, deal.lockIndex),
            "Contract does not owner of this liquidity"
        );
        deal.isActive = true;
        emit DealActivated(dealId, msg.sender);
    }

    function acceptLoanOffer(
        uint256 dealId,
        address referrer
    ) external payable nonReentrant {
        Deal storage deal = loans[dealId];
        require(
            msg.sender.code.length == 0,
            "Caller cannot be a smart contract"
        );
        require(deal.isActive, "Deal inactive");
        require(deal.lender == address(0), "Deal already has a lender");
        require(
            deal.borrower != msg.sender,
            "Borrower cannot make loan for himself"
        );
        require(msg.value >= deal.dealAmount, "Insufficient funds");

        deal.lender = msg.sender;
        deal.startTime = block.timestamp;

        uint256 ownerFeeForLoan = getOwnerFee(deal.loanDuration);
        uint256 feeAmount = (deal.dealAmount * ownerFeeForLoan) / 10000;

        uint256 ownerFeeAmount;
        uint256 referralFeeAmount;

        if (referrals[msg.sender] == address(0) && referrer != address(0)) {
            referrals[msg.sender] = referrer;
        }

        address originalReferrer = referrals[msg.sender];

        if (originalReferrer != address(0)) {
            referralFeeAmount = (feeAmount * referralFee) / 10000;
            (bool referralFeeSent, ) = payable(originalReferrer).call{
                value: referralFeeAmount
            }("");
            require(referralFeeSent, "Failed to send referral fee");
        }

        ownerFeeAmount = feeAmount - referralFeeAmount;

        (bool feeSent, ) = payable(feeReceiver).call{value: ownerFeeAmount}("");
        require(feeSent, "Failed to send fee");

        (bool sent, ) = payable(deal.borrower).call{
            value: msg.value - feeAmount
        }("");
        require(sent, "Failed to send funds");

        emit DealMade(dealId, msg.sender);
    }

    function cancelLoan(uint256 dealId) public {
        Deal storage deal = loans[dealId];
        require(deal.isActive == true, "Loan inactive");
        require(deal.borrower == msg.sender, "Caller not lock owner");
        require(deal.lender == address(0), "Cannot cancel processing deal");
        liquidityLocker.transferLocks(
            deal.lockIndex,
            payable(msg.sender)
        );
        loans[dealId].isActive = false;
        loans[dealId].isRepaid = true;
    }

    function repayLoan(uint256 dealId) public payable nonReentrant {
        Deal storage deal = loans[dealId];
        uint256 repayAmount = deal.dealAmount +
            (deal.dealAmount * deal.interestRate) /
            10000;
        require(!deal.isRepaid, "Deal already repaid");
        require(msg.sender == deal.borrower, "Sender is not a borrower");
        require(deal.lender != address(0), "Nothing to repay");
        require(msg.value >= repayAmount, "Insuffitient payable amount");
        require(
            deal.startTime + deal.loanDuration > block.timestamp,
            "Loan duration exceed"
        );
        deal.isRepaid = true;
        liquidityLocker.transferLocks(
            deal.lockIndex,
            payable(msg.sender)
        );
        (bool sent, ) = payable(deal.lender).call{value: msg.value}("");
        require(sent, "Repay failed");
        emit LoanRepaid(dealId, msg.sender);
    }

    function claimCollateral(uint256 dealId) public nonReentrant {
        Deal storage deal = loans[dealId];
        require(deal.lender == msg.sender, "Caller is not lender");
        require(!deal.collateralClaimed, "Already claimed");
        require(
            deal.startTime + deal.loanDuration < block.timestamp,
            "Deal is active yet"
        );
        liquidityLocker.transferLocks(
            deal.lockIndex,
            payable(msg.sender)
        );
        deal.collateralClaimed = true;
        emit CollateralClaimed(dealId, msg.sender);
    }

    function initializeAuction(
        address lpToken,
        uint256 lockIndex,
        uint256 startPrice,
        uint256 imeddiatelySellPrice,
        uint256 bidStep,
        uint256 duration,
        bool immediatelySell
    ) public {
        require(duration > 0, "Duration must be greater than 0");
        require(
            checkLiquidityOwner(msg.sender, lpToken, lockIndex),
            "User does not owner of this lock"
        );
        require(
            imeddiatelySellPrice > 0,
            "imeddiatelySellPrice must be positive number"
        );

        auctions[nextAuctionId] = Auction({
            owner: msg.sender,
            highestBidOwner: address(0),
            lpToken: lpToken,
            lockIndex: lockIndex,
            startPrice: startPrice,
            imeddiatelySellPrice: imeddiatelySellPrice,
            bidStep: bidStep,
            duration: duration,
            startTime: block.timestamp,
            isActive: false,
            isFinishedImmediately: false,
            immediatelySell: immediatelySell,
            isRewardClaimed: false
        });
        emit AuctionStarted(
            nextAuctionId,
            msg.sender,
            lpToken,
            lockIndex,
            startPrice,
            imeddiatelySellPrice,
            bidStep,
            duration,
            immediatelySell
        );

        userAuction[msg.sender].push(nextAuctionId);

        nextAuctionId++;
    }

    function startAuction(uint256 auctionId) external {
        Auction storage auction = auctions[auctionId];
        require(!auction.isActive, "Auction already active");
        require(auction.owner != address(0), "Auction is empty");
        require(
            checkLiquidityOwner(
                address(this),
                auction.lpToken,
                auction.lockIndex
            ),
            "Contract does not owner of this liquidity"
        );
        auction.isActive = true;
        auction.startTime = block.timestamp;
        emit AuctionActivated(auctionId, msg.sender);
    }

    function buyNow(
        uint256 auctionId,
        address referrer
    ) external payable nonReentrant {
        Auction storage auction = auctions[auctionId];
        require(
            msg.sender.code.length == 0,
            "Caller cannot be a smart contract"
        );
        require(
            auction.immediatelySell,
            "Immediately selling is disabled for this lottery"
        );
        require(auction.owner != msg.sender, "Sender is auction owner");
        require(
            msg.value >= auction.imeddiatelySellPrice,
            "Insuffitient payable amount"
        );
        require(
            !auction.isFinishedImmediately &&
                auction.isActive &&
                auction.startTime + auction.duration > block.timestamp,
            "Auction inactive"
        );
        auction.isFinishedImmediately = true;
        auction.highestBidOwner = address(0);
        liquidityLocker.transferLocks(
            auction.lockIndex,
            payable(msg.sender)
        );

        uint256 feeAmount = (msg.value * ownerFeeAuction) / 10000;

        uint256 ownerFeeAuctionAmount;
        uint256 referralFeeAmount;

        if (referrals[msg.sender] == address(0) && referrer != address(0)) {
            referrals[msg.sender] = referrer;
        }

        address originalReferrer = referrals[msg.sender];

        if (originalReferrer != address(0)) {
            referralFeeAmount = (feeAmount * referralFee) / 10000;
            (bool referralFeeSent, ) = payable(originalReferrer).call{
                value: referralFeeAmount
            }("");
            require(referralFeeSent, "Failed to send referral fee");
        }

        ownerFeeAuctionAmount = feeAmount - referralFeeAmount;

        (bool feeSent, ) = payable(feeReceiver).call{value: ownerFeeAuctionAmount}("");
        require(feeSent, "Failed to send fee");

        (bool sent, ) = payable(auction.owner).call{
            value: msg.value - feeAmount
        }("");
        require(sent, "Failed to send funds");

        auction.isRewardClaimed = true;

        emit ImmediatelyBought(auctionId, msg.value, block.timestamp);
    }

    function makeBid(uint256 auctionId) public payable {
        Auction storage auction = auctions[auctionId];
        require(
            !auction.isFinishedImmediately &&
                auction.isActive &&
                auction.startTime + auction.duration > block.timestamp,
            "Auction inactive"
        );
        require(auction.owner != msg.sender, "Sender is auction owner");
        require(
            bids[auctionId][msg.sender] + msg.value >=
                bids[auctionId][auction.highestBidOwner] + auction.bidStep,
            "Bid must be greater than previous + bidStep"
        );
        bids[auctionId][msg.sender] += msg.value;
        auction.highestBidOwner = msg.sender;
        emit BidMade(auctionId, msg.sender, msg.value, block.timestamp);
    }

     function changeAuctionConditions(
        uint256 auctionId,
        uint256 startPrice,
        uint256 imeddiatelySellPrice,
        uint256 bidStep,
        uint256 duration,
        bool immediatelySell
    ) public {
        Auction storage auction = auctions[auctionId];

        require(auction.highestBidOwner == address(0), "You can't change this auction");
        require(auction.startTime + auction.duration < block.timestamp, "Auction is active yet");
        require(duration > 0, "Duration must be greater than 0");
        require(
            auction.owner == msg.sender,
            "User does not owner of this auction"
        );
        require(
            imeddiatelySellPrice > 0,
            "imeddiatelySellPrice must be positive number"
        );

        auctions[auctionId] = Auction({
            owner: auction.owner,
            highestBidOwner: auction.highestBidOwner,
            lpToken: auction.lpToken,
            lockIndex: auction.lockIndex,
            startPrice: startPrice,
            imeddiatelySellPrice: imeddiatelySellPrice,
            bidStep: bidStep,
            duration: duration,
            startTime: block.timestamp,
            isActive: false,
            isFinishedImmediately: false,
            immediatelySell: immediatelySell,
            isRewardClaimed: false
        });
        emit AuctionChanged(
            auctionId,
            msg.sender,
            auction.lpToken,
            auction.lockIndex,
            startPrice,
            imeddiatelySellPrice,
            bidStep,
            duration,
            immediatelySell
        );
    }

    function closeAuction(uint256 auctionId) public {
        Auction storage auction = auctions[auctionId];
        require(
            auction.startTime + auction.duration < block.timestamp,
            "Auction is active yet"
        );
        require(
            auction.highestBidOwner == address(0) &&
                !auction.isFinishedImmediately,
            "Not claimable"
        );
        require(msg.sender == auction.owner, "Caller is not auction owner");

        liquidityLocker.transferLocks(
            auction.lockIndex,
            payable(msg.sender)
        );

        auctions[auctionId].isActive = false;
        auctions[auctionId].isRewardClaimed = true;
    }

    function claimAuctionLiquidity(uint256 auctionId) public nonReentrant {
        Auction memory auction = auctions[auctionId];
        require(
            auction.startTime + auction.duration < block.timestamp,
            "Auction is active yet"
        );
        require(
            msg.sender == auction.highestBidOwner &&
                !auction.isFinishedImmediately,
            "Not eligible for claim"
        );
        require(!auctionClaimed[auctionId], "Already claimed");

        uint256 highestBidAmount = bids[auctionId][msg.sender];
        if (highestBidAmount < auction.bidStep + auction.startPrice) {
            require(auction.isRewardClaimed, "Owner has not approved your bid yet");
        }

        liquidityLocker.transferLocks(
            auction.lockIndex,
            payable(msg.sender)
        );
        auctionClaimed[auctionId] = true;
        emit AuctionWon(auctionId, msg.sender);
    }

    function claimAuctionPayment(
        uint256 auctionId,
        address referrer
    ) external nonReentrant {
        Auction storage auction = auctions[auctionId];
        require(
            !auction.isFinishedImmediately &&
                auction.startTime + auction.duration < block.timestamp,
            "Auction active yet"
        );
        require(
            msg.sender == auction.owner && !auction.isRewardClaimed,
            "Not eligible for claim"
        );
        uint256 bidAmount = bids[auctionId][auction.highestBidOwner];

        require(bidAmount > 0, "Nothing to claim");

        uint256 feeAmount = (bidAmount * ownerFeeAuction) / 10000;

        uint256 ownerFeeAuctionAmount;
        uint256 referralFeeAmount;

        if (referrals[msg.sender] == address(0) && referrer != address(0)) {
            referrals[msg.sender] = referrer;
        }

        address originalReferrer = referrals[msg.sender];

        if (originalReferrer != address(0)) {
            referralFeeAmount = (feeAmount * referralFee) / 10000;
            (bool referralFeeSent, ) = payable(originalReferrer).call{
                value: referralFeeAmount
            }("");
            require(referralFeeSent, "Failed to send referral fee");
        }

        ownerFeeAuctionAmount = feeAmount - referralFeeAmount;

        (bool feeSent, ) = payable(feeReceiver).call{value: ownerFeeAuctionAmount}("");
        require(feeSent, "Failed to send fee");

        (bool sent, ) = payable(msg.sender).call{value: bidAmount - feeAmount}(
            ""
        );
        require(sent, "Withdraw failed");
        auction.isRewardClaimed = true;
        emit AuctionPaymentClaimed(
            auctionId,
            msg.sender,
            bidAmount,
            block.timestamp
        );
    }

    function withdrawBid(uint256 auctionId) external nonReentrant {
        Auction storage auction = auctions[auctionId];
        uint256 bidAmount = bids[auctionId][msg.sender];
        require(
            msg.sender != auction.highestBidOwner && bidAmount > 0,
            "No eligible to withdraw"
        );
        (bool sent, ) = payable(msg.sender).call{value: bidAmount}("");
        require(sent, "Withdraw failed");
        bids[auctionId][msg.sender] = 0;
        emit BidWithdrawn(auctionId, msg.sender, bidAmount, block.timestamp);
    }
}
