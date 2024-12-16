/**
 *Submitted for verification at BscScan.com on 2023-09-25
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

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
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
	address private _owner;

	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	/**
	 * @dev Initializes the contract setting the deployer as the initial owner.
	 */
	constructor() {
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
	function owner() public view virtual returns(address) {
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
	 * `onlyOwner` functions anymore. Can only be called by the current owner.
	 *
	 * NOTE: Renouncing ownership will leave the contract without an owner,
	 * thereby removing any functionality that is only available to the owner.
	 */
	function renounceOwnership() public virtual onlyOwner {
		_transferOwnership(address(0));
	}

	/**
	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
	 * Can only be called by the current owner.
	 */
	function transferOwnership(address newOwner) public virtual onlyOwner {
		require(newOwner != address(0), "Ownable: new owner is the zero address");
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

		(bool success, ) = recipient.call {
			value: amount
		}("");
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
	function functionCall(address target, bytes memory data) internal returns(bytes memory) {
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
	function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns(bytes memory) {
		if (address(this).balance < value) {
			revert AddressInsufficientBalance(address(this));
		}
		(bool success, bytes memory returndata) = target.call {
			value: value
		}(data);
		return verifyCallResultFromTarget(target, success, returndata);
	}

	/**
	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
	 * but performing a static call.
	 */
	function functionStaticCall(address target, bytes memory data) internal view returns(bytes memory) {
		(bool success, bytes memory returndata) = target.staticcall(data);
		return verifyCallResultFromTarget(target, success, returndata);
	}

	/**
	 * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
	 * but performing a delegate call.
	 */
	function functionDelegateCall(address target, bytes memory data) internal returns(bytes memory) {
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
	) internal view returns(bytes memory) {
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
	function verifyCallResult(bool success, bytes memory returndata) internal pure returns(bytes memory) {
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

library SafeERC20 {
	using Address
	for address;

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
	 * @dev Decrease the calling contract's allowance toward `spender` by `requestedDecrease`. If `token` returns no value,
	 * non-reverting calls are assumed to be successful.
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
	function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns(bool) {
		// We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
		// we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
		// and not revert is the subcall reverts.

		(bool success, bytes memory returndata) = address(token).call(data);
		return success && (returndata.length == 0 || abi.decode(returndata, (bool))) && address(token).code.length > 0;
	}
}

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

library ECDSA {
    enum RecoverError {
        NoError,
        InvalidSignature,
        InvalidSignatureLength,
        InvalidSignatureS,
        InvalidSignatureV
    }

    function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return; // no error: do nothing
        } else if (error == RecoverError.InvalidSignature) {
            revert("ECDSA: invalid signature");
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert("ECDSA: invalid signature length");
        } else if (error == RecoverError.InvalidSignatureS) {
            revert("ECDSA: invalid signature 's' value");
        } else if (error == RecoverError.InvalidSignatureV) {
            revert("ECDSA: invalid signature 'v' value");
        }
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature` or error string. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     *
     * Documentation for signature generation:
     * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
     * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
     *
     * _Available since v4.3._
     */
    function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
        // Check the signature length
        // - case 65: r,s,v signature (standard)
        // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
        } else if (signature.length == 64) {
            bytes32 r;
            bytes32 vs;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            assembly {
                r := mload(add(signature, 0x20))
                vs := mload(add(signature, 0x40))
            }
            return tryRecover(hash, r, vs);
        } else {
            return (address(0), RecoverError.InvalidSignatureLength);
        }
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, signature);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
     *
     * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
     *
     * _Available since v4.3._
     */
    function tryRecover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address, RecoverError) {
        bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        uint8 v = uint8((uint256(vs) >> 255) + 27);
        return tryRecover(hash, v, r, s);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
     *
     * _Available since v4.2._
     */
    function recover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, r, vs);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
     * `r` and `s` signature fields separately.
     *
     * _Available since v4.3._
     */
    function tryRecover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address, RecoverError) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS);
        }
        if (v != 27 && v != 28) {
            return (address(0), RecoverError.InvalidSignatureV);
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            return (address(0), RecoverError.InvalidSignature);
        }

        return (signer, RecoverError.NoError);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `v`,
     * `r` and `s` signature fields separately.
     */
    function recover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from `s`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
    }

    /**
     * @dev Returns an Ethereum Signed Typed Data, created from a
     * `domainSeparator` and a `structHash`. This produces hash corresponding
     * to the one signed with the
     * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
     * JSON-RPC method as part of EIP-712.
     *
     * See {recover}.
     */
    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
    }
}


contract Payment is Ownable {

    using SafeERC20
	for IERC20;

    address public treasury = 0xB4EEa665bdBB78e9448D5ed54A0063944D5b92Df;
    address public usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address public usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
	address public signer = 0x6067c9A3717A3c005bEfA2061934D74E29C97D57;
	uint256 referralPercentage = 100;

	mapping(string => bool) public usedNonce;

    event PaymentReceived(uint256 amount, address token,address user);
	event ReferralIncomeReceived(address referrer, address buyer, uint256 buyAmount, uint256 referralIncome, address token);

	constructor(){

	}

    function pay(uint256 amount, address token) external {
        require(token == usdt || token == usdc,"Invalid currency");
        IERC20(token).safeTransferFrom(msg.sender, treasury, amount);
        
        emit PaymentReceived(amount, token,msg.sender);
    }

	function hashTransaction(
        string memory nonce, address receiver, uint256 amount
    ) public pure returns (bytes32) {
        bytes32 hash = keccak256(abi.encodePacked(nonce, receiver, amount));
        return hash;
    }


    function matchSigner(bytes32 hash, bytes memory signature)
        public
        view
        returns (bool)
    {
        return signer == ECDSA.recover(hash, signature);
    }

	function getAddress(bytes32 hash, bytes memory signature)
        public
        pure
        returns (address)
    {
        return ECDSA.recover(hash, signature);
    }

	function payWithReferral(uint256 amount, address token, address referrer, 
	string memory nonce, bytes memory signerSignature ) external {

		require(!usedNonce[nonce], "Nonce used");
        bytes32 hash = hashTransaction(nonce, referrer, amount);
        require(
        matchSigner(
            hash,
            signerSignature
        ),
        "Signer signature mismatched"
        );
		usedNonce[nonce] = true;

		require(token == usdt || token == usdc,"Invalid currency");
		require(referrer!=address(0),"Invalid address");
		uint256 referralIncome = (amount*referralPercentage)/1000;
		IERC20(token).safeTransferFrom(msg.sender, referrer, referralIncome);
        emit ReferralIncomeReceived(referrer, msg.sender, amount, referralIncome, token);

        IERC20(token).safeTransferFrom(msg.sender, treasury, amount-referralIncome);
        emit PaymentReceived(amount, token, msg.sender);

	}

    function seTreasury(address _treasury) external onlyOwner{
        treasury = _treasury;
    }

	function updateReferralPercentage(uint256 percentage) external onlyOwner{
		referralPercentage = percentage;
	}

    function updateAddresses(address _treasury, address _usdt, address _usdc) external onlyOwner{
        treasury = _treasury;
        usdt = _usdt;
        usdc = _usdc;
    }


}
