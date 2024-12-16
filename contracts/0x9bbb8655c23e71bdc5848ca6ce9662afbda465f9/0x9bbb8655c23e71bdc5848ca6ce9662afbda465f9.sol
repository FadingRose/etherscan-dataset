// SPDX-License-Identifier: Unlicense

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: contracts/IERC721Minter.sol


pragma solidity 0.8.5;


interface IERC721Minter is IERC721 {
    /**
     * @dev Sets the address of media contract as the platform that can call functions in this contract
     *
     * Requirements:
     *
     * - The origin caller of this function must be `owner` i.e. the owner or deployer of this smart contract.
     * - `nftPlaform` cannot be the zero address.
     * - `platform` must not have been initialised. This should be zero address. Therefore this function can be called only once.
     */
    function setPlatform(address nftPlatform) external;

    /**
     * @dev Interface function for public variable tokenId which returns the token ID of last token minted.
     */
    function tokenId() external view returns (uint256);

    /**
     * @dev Returns the address of creator of the given token `id`.
     */
    function creators(uint256 id) external view returns (address);

    /**
     * @dev Returns the boolean if the given address of `creator` is the creator of the given token `id`.
     */
    function checkCreator(uint256 id, address creator)
        external
        view
        returns (bool);

    /**
     * @dev Returns if token `id` exists or not.
     */
    function exists(uint256 id) external view returns (bool);

    /**
     * @dev Mints new tokens.
     *      A new unique token is minted by `creator` with the token URI `tokenUri`.
     */
    function mint(address creator, string calldata tokenUri) external;

    /**
     * @dev Burns already minted tokens.
     *
     * Requirements:
     *
     * - Token `id` must exist.
     * - The caller must be the owner of the token `id`.
     */
    function burn(uint256 id) external;

       /**
     * @dev approve token for transfer.
     *
     * Requirements:
     *
     * - Token `id` must exist.
     * - The caller must be the media contract.
     */

    function approveToken(address to, uint256 id) external;
}

// File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)

pragma solidity ^0.8.0;


/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
        external
        view
        returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}

// File: contracts/IERC1155Minter.sol


pragma solidity 0.8.5;


interface IERC1155Minter is IERC1155 {
    /**
     * @dev Sets the address of media contract as the platform that can call functions in this contract
     *
     * Requirements:
     *
     * - The origin caller of this function must be `owner` i.e. the owner or deployer of this smart contract.
     * - `nftPlaform` cannot be the zero address.
     * - `platform` must not have been initialised. This should be zero address. Therefore this function can be called only once.
     */
    function setPlatform(address nftPlatform) external;

    /**
     * @dev Interface function for public variable tokenId which returns the token ID of last token minted.
     */
    function tokenId() external view returns (uint256);

    /**
     * @dev Returns the address of creator of the given token `id`.
     */
    function creators(uint256 id) external view returns (address);

    /**
     * @dev Returns the boolean if the given address of `creator` is the creator of the given token `id`.
     */
    function checkCreator(uint256 id, address creator)
        external
        view
        returns (bool);

    /**
     * @dev Mints new tokens.
     *      quantity `amount` of a token ID are minted by `creator` with the token URI `tokenUri`.
     */
    function mint(
        address creator,
        uint256 amount,
        string calldata tokenUri
    ) external;

    /**
     * @dev Burns already minted tokens.
     *
     * Requirements:
     *
     * - caller must have quantity of token `id` more or equal to `amount`.
     */
    function burn(uint256 id, uint256 amount) external;

    /**
     * @dev approve token for transfer
     *
     * Requirements:
     *
     * - caller must be media contract
     */
     function approveToken(address from, address to, bool approved) external;

}

// File: @openzeppelin/contracts/utils/math/Math.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1);

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator,
        Rounding rounding
    ) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10**64) {
                value /= 10**64;
                result += 64;
            }
            if (value >= 10**32) {
                value /= 10**32;
                result += 32;
            }
            if (value >= 10**16) {
                value /= 10**16;
                result += 16;
            }
            if (value >= 10**8) {
                value /= 10**8;
                result += 8;
            }
            if (value >= 10**4) {
                value /= 10**4;
                result += 4;
            }
            if (value >= 10**2) {
                value /= 10**2;
                result += 2;
            }
            if (value >= 10**1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
        }
    }
}

// File: @openzeppelin/contracts/utils/Strings.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)

pragma solidity ^0.8.0;


/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }
}

// File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)

pragma solidity ^0.8.0;


/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSA {
    enum RecoverError {
        NoError,
        InvalidSignature,
        InvalidSignatureLength,
        InvalidSignatureS,
        InvalidSignatureV // Deprecated in v4.8
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
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            /// @solidity memory-safe-assembly
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
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

// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
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
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
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

// File: @openzeppelin/contracts/interfaces/IERC1271.sol


// OpenZeppelin Contracts v4.4.1 (interfaces/IERC1271.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC1271 standard signature validation method for
 * contracts as defined in https://eips.ethereum.org/EIPS/eip-1271[ERC-1271].
 *
 * _Available since v4.1._
 */
interface IERC1271 {
    /**
     * @dev Should return whether the signature provided is valid for the provided data
     * @param hash      Hash of the data to be signed
     * @param signature Signature byte array associated with _data
     */
    function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
}

// File: @openzeppelin/contracts/utils/cryptography/SignatureChecker.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/SignatureChecker.sol)

pragma solidity ^0.8.0;




/**
 * @dev Signature verification helper that can be used instead of `ECDSA.recover` to seamlessly support both ECDSA
 * signatures from externally owned accounts (EOAs) as well as ERC1271 signatures from smart contract wallets like
 * Argent and Gnosis Safe.
 *
 * _Available since v4.1._
 */
library SignatureChecker {
    /**
     * @dev Checks if a signature is valid for a given signer and data hash. If the signer is a smart contract, the
     * signature is validated against that smart contract using ERC1271, otherwise it's validated using `ECDSA.recover`.
     *
     * NOTE: Unlike ECDSA signatures, contract signatures are revocable, and the outcome of this function can thus
     * change through time. It could return true at block N and false at block N+1 (or the opposite).
     */
    function isValidSignatureNow(
        address signer,
        bytes32 hash,
        bytes memory signature
    ) internal view returns (bool) {
        (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
        if (error == ECDSA.RecoverError.NoError && recovered == signer) {
            return true;
        }

        (bool success, bytes memory result) = signer.staticcall(
            abi.encodeWithSelector(IERC1271.isValidSignature.selector, hash, signature)
        );
        return (success &&
            result.length == 32 &&
            abi.decode(result, (bytes32)) == bytes32(IERC1271.isValidSignature.selector));
    }
}

// File: @openzeppelin/contracts/utils/cryptography/EIP712.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)

pragma solidity ^0.8.0;


/**
 * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
 *
 * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
 * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
 * they need in their contracts using a combination of `abi.encode` and `keccak256`.
 *
 * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
 * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
 * ({_hashTypedDataV4}).
 *
 * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
 * the chain id to protect against replay attacks on an eventual fork of the chain.
 *
 * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
 * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
 *
 * _Available since v3.4._
 */
abstract contract EIP712 {
    /* solhint-disable var-name-mixedcase */
    // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
    // invalidate the cached domain separator if the chain id changes.
    bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
    uint256 private immutable _CACHED_CHAIN_ID;
    address private immutable _CACHED_THIS;

    bytes32 private immutable _HASHED_NAME;
    bytes32 private immutable _HASHED_VERSION;
    bytes32 private immutable _TYPE_HASH;

    /* solhint-enable var-name-mixedcase */

    /**
     * @dev Initializes the domain separator and parameter caches.
     *
     * The meaning of `name` and `version` is specified in
     * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
     *
     * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
     * - `version`: the current major version of the signing domain.
     *
     * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
     * contract upgrade].
     */
    constructor(string memory name, string memory version) {
        bytes32 hashedName = keccak256(bytes(name));
        bytes32 hashedVersion = keccak256(bytes(version));
        bytes32 typeHash = keccak256(
            "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
        );
        _HASHED_NAME = hashedName;
        _HASHED_VERSION = hashedVersion;
        _CACHED_CHAIN_ID = block.chainid;
        _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
        _CACHED_THIS = address(this);
        _TYPE_HASH = typeHash;
    }

    /**
     * @dev Returns the domain separator for the current chain.
     */
    function _domainSeparatorV4() internal view returns (bytes32) {
        if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
            return _CACHED_DOMAIN_SEPARATOR;
        } else {
            return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
        }
    }

    function _buildDomainSeparator(
        bytes32 typeHash,
        bytes32 nameHash,
        bytes32 versionHash
    ) private view returns (bytes32) {
        return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
    }

    /**
     * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
     * function returns the hash of the fully encoded EIP712 message for this domain.
     *
     * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
     *
     * ```solidity
     * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
     *     keccak256("Mail(address to,string contents)"),
     *     mailTo,
     *     keccak256(bytes(mailContents))
     * )));
     * address signer = ECDSA.recover(digest, signature);
     * ```
     */
    function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
        return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
    }
}

// File: @openzeppelin/contracts/utils/Context.sol


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
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

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

// File: contracts/IMarket.sol


pragma solidity 0.8.5;

interface IMarket {
    //Struct for maintaining collaborators of a token
    struct Collaborators {
        address[] collaborators;
        uint256[] percentages;
    }

    //Struct for maintainig refer details
    struct Refer {
        address referee;
        address referal;
    }

    //Struct for maintaining details of tokens on auction
    struct OnAuction {
        address seller;
        uint256 basePrice;
        uint256 quantity;
        uint256 lastBidPrice;
        uint256 startTime;
        uint256 endTime;
        address[] bidders;
        uint256[] bidPrices;
    }

    //Struct for maintaining details of tokens on sale
    struct OnSale {
        address seller;
        uint256 tokenPrice;
        uint256 quantity;
    }

    //Event emitted when a token is put for sale
    event ForSale(
        address indexed token,
        address indexed owner,
        uint256 indexed id,
        uint256 quantity,
        uint256 salePrice
    );
    //Event emitted when a token is sold
    event Sold(
        address token,
        address indexed seller,
        address indexed buyer,
        uint256 indexed id,
        uint256 quantity,
        uint256 price,
        uint256 adminCommission
    );
    //Event emitted when the owner of the withdraws a token from sale
    event WithdrawSale(
        address indexed token,
        address indexed seller,
        uint256 indexed id
    );
    //Event emitted when a token is put on auction
    event ForAuction(
        address indexed token,
        address indexed owner,
        uint256 indexed id,
        uint256 quantity,
        uint256 basePrice,
        uint256 startTime,
        uint256 endTime
    );
    //Event emitted when there is a bid on a token
    event Bid(
        address token,
        address indexed bidder,
        address indexed owner,
        uint256 indexed id,
        uint256 bid
    );
    //Event emitted when a bid is rejected by the token owner or withdrawn by the bidder
    event CancelBid(
        address token,
        address indexed bidder,
        address indexed owner,
        uint256 indexed id
    );
    //Event emitted when the token owner accepts the bid of a bidder
    event AcceptBid(
        address token,
        address indexed bidder,
        address indexed owner,
        uint256 indexed id,
        uint256 adminCommission
    );
    //Event emitted when the token owner withdraws a token on auction
    event WithdrawAuction(
        address indexed token,
        address indexed owner,
        uint256 indexed id
    );
    //Event emitted when the highest bidder claims a token on timed auction after the auction ends
    event Claim(
        address token,
        address indexed bidder,
        address indexed owner,
        uint256 indexed id,
        uint256 adminCommission
    );
    //Event emitted when a user redeems his points to their wallet
    event Redeem(address indexed owner, uint256 indexed pointsRedeemed);

    event Earning(
        address indexed referal,
        address indexed referee,
        uint256 referalAmount,
        uint256 refereeAmount
    );
}

// File: contracts/Market.sol


pragma solidity 0.8.5;





contract Market is IMarket, EIP712, Ownable {
    //Address of Media platform
    address private _platform;
    //Relayer Address
    address private relayer;
    //Admin Commision percentage
    uint256 public commission; //percentage * 100
    //Referee reward percentage
    uint256 public refereeReward; //percentage * 100
    //Referal reward percentage
    uint256 public referalReward; //percentage * 100

    //TokenContractAddress=>OwnerAddress=>TokenId=>`onAuction`
    mapping(address => mapping(address => mapping(uint256 => OnAuction)))
        public onAuctions;
    //TokenAddress=>OwnerAddress=>TokenId=>BidderAddress=>Boolean
    mapping(address => mapping(address => mapping(uint256 => mapping(address => bool))))
        private _isBidder;
    //TokenAddress=>OwnerAddress=>TokenId=>`onSale`
    mapping(address => mapping(address => mapping(uint256 => OnSale)))
        public onSales;
    //TokenAddress=>TokenId=>`Collaborators`
    mapping(address => mapping(uint256 => Collaborators))
        private _tokenCollaborators;
    //UserAddress=>Balance
    mapping(address => uint256) private _redeemablePoints;
    //TokenAddress=>TokenId=>RoyaltyPercentage
    mapping(address => mapping(uint256 => uint256)) private _royalty;
    // adress => Boolean
    mapping(address => bool) private _isFirstBuy; // returns false if is first buy

    constructor() EIP712("NFTTalent", "1") {
    }

    //Modifier to check only media contract can call the functions
    modifier onlyPlatform() {
        require(
            msg.sender == _platform,
            "Market: can only be called from platform"
        );
        _;
    }

    //receive function to receive ETH to the contract
    receive() external payable {}

    /**
     * @dev Sets the address of media contract as the platform that can call functions in this contract
     *
     * Requirements:
     *
     * - The origin caller of this function must be `owner` i.e. the owner or deployer of this smart contract.
     * - `nftPlaform` cannot be the zero address.
     * - `platform` must not have been initialised. This should be zero address. Therefore this function can be called only once.
     */
    function setPlatform(address nftPlatform) external {
        require(
            tx.origin == owner(),
            "Market: only contract owner can set platform"
        );
        require(nftPlatform != address(0), "Market: invalid platform address");
        require(
            _platform == address(0),
            "Market: platform already initialised"
        );
        _platform = nftPlatform;
    }

    /**
     * @dev Puts `quantity` quantity of `id` token of contract address `tokenAddress` from `tokenOwner` on auction at a price of `price`.
     *
     *      If the `endTime` is not equal to zero then the auction is a timed auction.
     *
     * Requirements:
     *
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must not be on auction already.
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must not be on sale already.
     * - If on timed auction the timestamp at which the auction starts `startTime` must be more than the current block timestamp.
     * - If `startTime` is zero in a timed auction it is assigned the timestamp of current block.
     * - If on timed auction the timestamp at which the auction ends `endTime` must be more than the `startTime`.
     *
     * Emits a {ForAuction} event.
     */
    function putOnAuction(
        address tokenAddress,
        uint256 id,
        address tokenOwner,
        uint256 price,
        uint256 quantity,
        uint256 startTime,
        uint256 endTime
    ) external onlyPlatform {
        require(
            onAuctions[tokenAddress][tokenOwner][id].seller == address(0),
            "Market: token already on auction"
        );
        require(
            onSales[tokenAddress][tokenOwner][id].seller == address(0),
            "Market: already on sale"
        );
        if (endTime != 0) {
            if (startTime != 0)
                require(
                    startTime > block.timestamp,
                    "Market: auction start time already passed"
                );
            else startTime = block.timestamp;
            require(
                endTime > startTime,
                "Market: auction end time must be more than start time"
            );
            onAuctions[tokenAddress][tokenOwner][id].startTime = startTime;
            onAuctions[tokenAddress][tokenOwner][id].endTime = endTime;
            onAuctions[tokenAddress][tokenOwner][id].bidders.push(address(0));
            onAuctions[tokenAddress][tokenOwner][id].bidPrices.push(0);
        }
        onAuctions[tokenAddress][tokenOwner][id].seller = tokenOwner;
        onAuctions[tokenAddress][tokenOwner][id].basePrice = price;
        onAuctions[tokenAddress][tokenOwner][id].quantity = quantity;
        onAuctions[tokenAddress][tokenOwner][id].lastBidPrice = price;
        emit ForAuction(
            tokenAddress,
            tokenOwner,
            id,
            quantity,
            price,
            startTime,
            endTime
        );
    }

    /**
     * @dev a bid by `bidder` of `bidAmount` on `id` token of contract address `tokenAddress` from `tokenOwner`
     *
     * Requirements:
     *
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must be on auction.
     * - `bidder` must not be owner of the token.
     * - `bidAmount` must be more than the last bid on the token.
     * - If timed auction first check if the current time is more than or equal to the start time. If true, the auction has started.
     * - If timed auction first check if the current time is less than the end time. If false, the auction has ended.
     *
     * Emits a {Bid} event.
     */
    function bid(
        address tokenAddress,
        uint256 id,
        address from,
        address bidder,
        uint256 bidAmount
    ) external onlyPlatform {
        OnAuction memory auctions = onAuctions[tokenAddress][from][id];
        require(auctions.seller != address(0), "Market: token not on auction");
        require(
            auctions.seller != bidder,
            "Market: owner cannot bid on his token"
        );
        require(
            bidAmount > auctions.lastBidPrice,
            "Market: bid must be more than the last bid"
        );
        if (auctions.endTime == 0) {
            if (_isBidder[tokenAddress][from][id][bidder])
                _updateBid(tokenAddress, from, id, bidder, bidAmount);
            else {
                onAuctions[tokenAddress][from][id].bidders.push(bidder);
                onAuctions[tokenAddress][from][id].bidPrices.push(bidAmount);
            }
            _isBidder[tokenAddress][from][id][bidder] = true;
        } else {
            require(
                auctions.startTime <= block.timestamp,
                "Market: auction has not started"
            );
            require(
                auctions.endTime > block.timestamp,
                "Market: auction has ended"
            );
            _redeemablePoints[auctions.bidders[0]] += auctions.bidPrices[0];
            onAuctions[tokenAddress][from][id].bidders[0] = bidder;
            onAuctions[tokenAddress][from][id].bidPrices[0] = bidAmount;
        }
        onAuctions[tokenAddress][from][id].lastBidPrice = bidAmount;
        emit Bid(tokenAddress, bidder, from, id, bidAmount);
    }

    /**
     * @dev a bid from `bidder` on `id` token of contract address `tokenAddress` accepted by `tokenOwner`
     *
     *      Once accepted, royalty is calculated on the final bid amount. This royalty is then divided
     *      among the creator and collaborators (if any) of the token.
     *
     *      After removing the royalty the remaining amount is added to the points of the `tokenOwner`
     *
     * Requirements:
     *
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must be on auction.
     * - It must not be on timed auction.
     * - `quantity` must be equal to the quantity of tokens on sale.
     * - `bidder` must actually have a bid on the said token.
     *
     * Emits a {AcceptBid} event.
     */
    function acceptBid(
        address tokenAddress,
        uint256 id,
        address creator,
        address tokenOwner,
        address bidder,
        uint256 quantity,
        Refer calldata refer,
        bytes memory signature
    ) external onlyPlatform {
        OnAuction memory auctions = onAuctions[tokenAddress][tokenOwner][id];
        require(auctions.seller != address(0), "Market: token not on auction");
        require(auctions.endTime == 0, "Market: token is on timed auction");
        require(
            auctions.quantity == quantity,
            "Market: quantity should be equal to total tokens on auction"
        );
        require(
            _isBidder[tokenAddress][tokenOwner][id][bidder],
            "Market: bidder did not bid for this token"
        );
        uint256 bidNumber;
        uint256 totalBids = auctions.bidders.length;
        uint256 _adminCommission;
        for (bidNumber = 0; bidNumber < totalBids; bidNumber++) {
            if (auctions.bidders[bidNumber] == bidder) {
                if (creator == address(0)) {
                    _redeemablePoints[tokenOwner] += auctions.bidPrices[
                        bidNumber
                    ];
                } else {
                    uint256 royalty = _calculateRoyalty(
                        auctions.bidPrices[bidNumber],
                        tokenAddress,
                        id
                    );

                    _adminCommission = _calculatePercentage(
                        auctions.bidPrices[bidNumber],
                        commission
                    );
                    _redeemablePoints[tokenOwner] += (auctions.bidPrices[
                        bidNumber
                    ] -
                        royalty -
                        _adminCommission);

                    if (
                        !_isFirstBuy[bidder] &&
                        signature.length > 0 &&
                        _verifySignature(refer, signature)
                    ) {
                        _adminCommission = _divideCommission(
                            _adminCommission,
                            refer
                        );
                        _isFirstBuy[bidder] = true;
                    } else {
                        _redeemablePoints[owner()] += (_adminCommission);
                    }

                    _divideRoyalty(creator, tokenAddress, id, royalty);
                }
            } else {
                _redeemablePoints[auctions.bidders[bidNumber]] += auctions
                    .bidPrices[bidNumber];
                _isBidder[tokenAddress][tokenOwner][id][
                    auctions.bidders[bidNumber]
                ] = false;
            }
        }
        delete onAuctions[tokenAddress][tokenOwner][id];
        emit AcceptBid(tokenAddress, bidder, tokenOwner, id, _adminCommission);
    }

    /**
     * @dev the `bidder` on `id` token of contract address `tokenAddress` claims the token after the timed auction ends.
     *
     *      Once claimed, royalty is calculated on the final bid amount. This royalty is then divided
     *      among the `creator` and collaborators (if any) of the token.
     *
     *      After removing the royalty the remaining amount is added to the points of the seller `from`.
     *
     * Requirements:
     *
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must be on auction.
     * - It must be on timed auction.
     * - `quantity` must be equal to the quantity of tokens on sale.
     * - The auction should have ended i.e. the current time must be more than the end time of the auction.
     * - `bidder` must be the highest bidder before the auction ended.
     *
     * Emits a {Claim} event.
     */
    function claim(
        address tokenAddress,
        address from,
        address creator,
        address bidder,
        uint256 id,
        uint256 quantity,
        Refer calldata refer,
        bytes memory signature
    ) external onlyPlatform {
        OnAuction memory auctions = onAuctions[tokenAddress][from][id];
        require(auctions.seller != address(0), "Market: token not on auction");
        require(auctions.endTime != 0, "Market: token is not on timed auction");
        require(
            auctions.endTime < block.timestamp,
            "Market: auction is not over"
        );
        require(
            auctions.bidders[0] == bidder,
            "Market: not the winning bidder"
        );
        require(
            auctions.quantity == quantity,
            "Market: quantity should be equal to total tokens on auction"
        );
        uint256 _adminCommission;
        if (creator == address(0)) {
            _redeemablePoints[from] += auctions.bidPrices[0];
        } else {
            uint256 royalty = _calculateRoyalty(
                auctions.bidPrices[0],
                tokenAddress,
                id
            );
            _adminCommission = _calculatePercentage(
                auctions.bidPrices[0],
                commission
            );
            _redeemablePoints[from] += (auctions.bidPrices[0] -
                royalty -
                _adminCommission);

            if (
                !_isFirstBuy[bidder] &&
                signature.length > 0 &&
                _verifySignature(refer, signature)
            ) {
                _adminCommission = _divideCommission(_adminCommission, refer);
                _isFirstBuy[bidder] = true;
            } else {
                _redeemablePoints[owner()] += (_adminCommission);
            }
            _divideRoyalty(creator, tokenAddress, id, royalty);
        }
        delete onAuctions[tokenAddress][from][id];
        emit Claim(tokenAddress, bidder, from, id, _adminCommission);
    }

    /**
     * @dev the auction on `id` token of contract address `tokenAddress` by `tokenOwner` was withdrawn.
     *
     *      If timed auction then there must be no bids on the token for it to be withdrawn.
     *      If normal auction then all the bids on the token are added back to the points of respective
     *      bidders before it is withdrawn.
     *
     * Requirements:
     *
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must be on auction.
     * - `tokenOwner` must be the auctioner.
     * - If timed auction there must be no bidders.
     *
     * Emits a {WithdrawAuction} event.
     */
    function withdrawAuction(
        address tokenAddress,
        uint256 id,
        address tokenOwner
    ) external onlyPlatform {
        OnAuction memory auctions = onAuctions[tokenAddress][tokenOwner][id];
        require(
            auctions.seller == tokenOwner,
            "Market: you did not put the token on auction"
        );
        if (auctions.endTime != 0)
            require(
                auctions.bidders[0] == address(0),
                "Market: already bid on timed auction exists"
            );
        else {
            uint256 bidNumber;
            uint256 totalBids = auctions.bidders.length;
            for (bidNumber = 0; bidNumber < totalBids; bidNumber++) {
                _redeemablePoints[auctions.bidders[bidNumber]] += auctions
                    .bidPrices[bidNumber];
                _isBidder[tokenAddress][tokenOwner][id][
                    auctions.bidders[bidNumber]
                ] = false;
            }
        }
        delete onAuctions[tokenAddress][tokenOwner][id];
        emit WithdrawAuction(tokenAddress, tokenOwner, id);
    }

    /**
     * @dev the bid of `bidder` on `id` token of contract address `tokenAddress` is removed.
     *
     *
     * Requirements:
     *
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must be on auction.
     * - It must not be on timed auction.
     * - `bidder` must actually have a bid on the said token.
     *
     * Emits a {CancelBid} event.
     */
    function removeBid(
        address tokenAddress,
        address from,
        uint256 id,
        address bidder
    ) public onlyPlatform {
        OnAuction memory auctions = onAuctions[tokenAddress][from][id];
        require(auctions.endTime == 0, "Market: token is on timed auction");
        require(
            auctions.seller == from,
            "Market: this seller did not put this token on auction"
        );
        require(
            _isBidder[tokenAddress][from][id][bidder],
            "Market: no bids from bidder for this token"
        );
        uint256 bidNumber;
        uint256 totalBids = auctions.bidders.length;
        for (bidNumber = 0; bidNumber < totalBids; bidNumber++) {
            if (auctions.bidders[bidNumber] == bidder) {
                _redeemablePoints[bidder] += auctions.bidPrices[bidNumber];
                onAuctions[tokenAddress][from][id].bidders[bidNumber] = auctions
                    .bidders[totalBids - 1];
                onAuctions[tokenAddress][from][id].bidders.pop();
                onAuctions[tokenAddress][from][id].bidPrices[
                    bidNumber
                ] = auctions.bidPrices[totalBids - 1];
                onAuctions[tokenAddress][from][id].bidPrices.pop();
                _isBidder[tokenAddress][from][id][bidder] = false;
                break;
            }
        }
        emit CancelBid(tokenAddress, bidder, from, id);
    }

    /**
     * @dev Puts `quantity` quantity of `id` token of contract address `tokenAddress` from `tokenOwner` on fixed sale at a price of `price`.
     *
     * Requirements:
     *
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must not be on sale already.
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must not be on auction already.
     *
     * Emits a {ForSale} event.
     */
    function listOnSale(
        address tokenAddress,
        uint256 id,
        address tokenOwner,
        uint256 price,
        uint256 quantity
    ) external onlyPlatform {
        require(
            onSales[tokenAddress][tokenOwner][id].seller == address(0),
            "Market: already on sale"
        );
        require(
            onAuctions[tokenAddress][tokenOwner][id].seller == address(0),
            "Market: token already on auction"
        );
        onSales[tokenAddress][tokenOwner][id] = OnSale({
            seller: tokenOwner,
            tokenPrice: price,
            quantity: quantity
        });
        emit ForSale(tokenAddress, tokenOwner, id, quantity, price);
    }

    /**
     * @dev `buyer` pays `price` for `id` token of contract address `tokenAddress` which was put on sale by `from`.
     *
     *      `price` is the total sale price depending on the quantity of tokens to be bought.
     *
     *      Once bought, royalty is calculated on the total sale price. This royalty is then divided
     *      among the `creator` and collaborators (if any) of the token.
     *
     *      After removing the royalty the remaining amount is added to the points of the seller `from`.
     *
     * Requirements:
     *
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must be on sale.
     * - `price` must be equal to the `quantity` multiplied by price of each token.
     * - `quantity` must be less than or equal to the quantity of token put on sale.
     *
     * Emits a {Sold} event.
     */
    function directBuy(
        address tokenAddress,
        uint256 id,
        address creator,
        address from,
        address buyer,
        uint256 price,
        uint256 quantity,
        Refer calldata refer,
        bytes memory signature
    ) external onlyPlatform {
        OnSale memory sale = onSales[tokenAddress][from][id];
        require(sale.seller != address(0), "Market: token not on sale");
        require(sale.seller != buyer, "Market: can not buy own nft");
        require(
            price == sale.tokenPrice * quantity,
            "Market: amount either more or less than token price"
        );
        require(
            quantity <= sale.quantity,
            "Market: not sufficient token on sale"
        );
        uint256 _adminCommission;
        if (creator == address(0)) {
            _redeemablePoints[from] += price;
        } else {
            uint256 royalty = _calculateRoyalty(price, tokenAddress, id);
            _adminCommission = _calculatePercentage(price, commission);

            _redeemablePoints[from] += (price - _adminCommission - royalty);
            if (
                !_isFirstBuy[buyer] &&
                signature.length > 0 &&
                _verifySignature(refer, signature)
            ) {
                _adminCommission = _divideCommission(_adminCommission, refer);
            } else {
                _redeemablePoints[owner()] += (_adminCommission);
            }

            _divideRoyalty(creator, tokenAddress, id, royalty);
        }
        onSales[tokenAddress][from][id].quantity -= quantity;
        _isFirstBuy[buyer] = true;
        if (onSales[tokenAddress][from][id].quantity == 0)
            delete onSales[tokenAddress][from][id];
        emit Sold(
            tokenAddress,
            from,
            buyer,
            id,
            quantity,
            price,
            _adminCommission
        );
    }

    /**
     * @dev the sale on `id` token of contract address `tokenAddress` by `tokenOwner` was withdrawn.
     *
     * Requirements:
     *
     * - `id` token of contract address `tokenAddress` from `tokenOwner` must be on sale.
     * - `tokenOwner` must be the auctioner.
     *
     * Emits a {WithdrawSale} event.
     */
    function withdrawSale(
        address tokenAddress,
        uint256 id,
        address tokenOwner
    ) external {
        require(
            onSales[tokenAddress][tokenOwner][id].seller == tokenOwner,
            "Media: you are not selling the token"
        );
        delete onSales[tokenAddress][tokenOwner][id];
        emit WithdrawSale(tokenAddress, tokenOwner, id);
    }

    /**
     * @dev Sets the collaborators of `tokenID` token of contract address `tokenAddress`.
     *      Also sets the percentage of royalty each collaborator will receive.
     *
     * Requirements:
     *
     * - The total collaborator percentage must not be more than 100%.
     *
     */
    function setCollaborators(
        address tokenAddress,
        uint256 tokenID,
        address[] calldata collaborator,
        uint256[] calldata percentage
    ) external onlyPlatform {
        uint256 totalPercentage;
        for (uint256 index = 0; index < percentage.length; index++) {
            totalPercentage += percentage[index];
        }
        require(
            totalPercentage <= 10000,
            "Market: percentage cannot be more than 10000"
        );
        Collaborators memory collaborators = Collaborators(
            collaborator,
            percentage
        );
        _tokenCollaborators[tokenAddress][tokenID] = collaborators;
    }

    /**
     * @dev Sets the royalty percentage of `id` token of contract address `tokenAddress`.
     *
     * Requirements:
     *
     * - The royalty percentage `royaltyPoints` must not be more than 100%.
     *
     */
    function setRoyaltyPoints(
        address tokenAddress,
        uint256 id,
        uint256 royaltyPoints
    ) external onlyPlatform {
        require(
            royaltyPoints <= 10000,
            "Market: percentage cannot be more than 10000"
        );
        _royalty[tokenAddress][id] = royaltyPoints;
    }

    /**
     * @dev Redeems `points` to the `user` wallet.
     *
     * Requirements:
     *
     * - The redeemable points of the `user` must be more than or equal to the requested `points`.
     *
     */
    function redeemPoints(address user, uint256 points) external onlyPlatform {
        require(
            points <= _redeemablePoints[user],
            "Market: not sufficient balance to withdraw"
        );
        payable(user).transfer(points);
        _redeemablePoints[user] -= points;
        emit Redeem(user, points);
    }

    /**
     * @dev Shows the total available redeemable points of the `user`.
     *
     */
    function viewPoints(
        address user
    ) external view onlyPlatform returns (uint256) {
        return _redeemablePoints[user];
    }

    function addPoints(address to, uint256 points) external onlyPlatform {
        _redeemablePoints[to] += points;
    }

    function setCommisionAndReferReward(
        uint256 _commission,
        uint256 _refereeReward,
        uint256 _referalReward
    ) external onlyPlatform {
        if (commission != _commission) commission = _commission;
        if (refereeReward != _refereeReward) refereeReward = _refereeReward;
        if (referalReward != _referalReward) referalReward = _referalReward;
    }

    function setRelayer(address _relayer) external onlyPlatform {
        require(_relayer != address(0), "Market: address zero provided");
        require(relayer == address(0), "Market: address already set");
        relayer = _relayer;
    }

    //PRIVATE FUNCTIONS

    function _updateBid(
        address tokenAddress,
        address from,
        uint256 id,
        address bidder,
        uint256 bidAmount
    ) private {
        OnAuction memory auctions = onAuctions[tokenAddress][from][id];
        uint256 bidNumber;
        uint256 totalBids = auctions.bidders.length;
        for (bidNumber = 0; bidNumber < totalBids; bidNumber++) {
            if (auctions.bidders[bidNumber] == bidder) {
                _redeemablePoints[bidder] += auctions.bidPrices[bidNumber];
                onAuctions[tokenAddress][from][id].bidPrices[
                    bidNumber
                ] = bidAmount;
            }
        }
    }

    function _calculateRoyalty(
        uint256 salePrice,
        address tokenAddress,
        uint256 id
    ) private view onlyPlatform returns (uint256) {
        return (salePrice * _royalty[tokenAddress][id]) / 10000;
    }

    function _divideRoyalty(
        address creator,
        address tokenAddress,
        uint256 tokenId,
        uint256 royalty
    ) private onlyPlatform {
        uint256 totalCollaborators = _tokenCollaborators[tokenAddress][tokenId]
            .collaborators
            .length;
        uint256 royaltySpent;
        for (
            uint256 collaboratorsCounter = 0;
            collaboratorsCounter < totalCollaborators;
            collaboratorsCounter++
        ) {
            uint256 royaltyShare = (royalty *
                _tokenCollaborators[tokenAddress][tokenId].percentages[
                    collaboratorsCounter
                ]) / 10000;
            _redeemablePoints[
                _tokenCollaborators[tokenAddress][tokenId].collaborators[
                    collaboratorsCounter
                ]
            ] += royaltyShare;
            royaltySpent += royaltyShare;
        }
        _redeemablePoints[creator] += (royalty - royaltySpent);
    }

    function _divideCommission(
        uint256 _adminCommission,
        Refer memory refer
    ) private returns (uint256) {
        //
        uint256 _refereeReward;
        uint256 _referalReward;
        uint256 _adminReward;
        _refereeReward = _calculatePercentage(_adminCommission, refereeReward);
        _referalReward = _calculatePercentage(_adminCommission, referalReward);
        _redeemablePoints[refer.referee] += _refereeReward;
        _redeemablePoints[refer.referal] += _referalReward;
        _adminReward = _adminCommission - _refereeReward - _referalReward;
        _redeemablePoints[owner()] += _adminReward;

        emit Earning(
            refer.referal,
            refer.referee,
            _referalReward,
            _refereeReward
        );
        return _adminReward;
    }

    function _calculatePercentage(
        uint256 price,
        uint256 percentage
    ) private pure returns (uint256) {
        if (price == 0) return 0;
        return (price * percentage) / 10000;
    }

    function _verifySignature(
        Refer calldata refer,
        bytes memory signature
    ) private view returns (bool) {
        //
        bytes32 hash = _hashTypedDataV4(
            keccak256(
                abi.encode(
                    keccak256("Refer(address referee,address referal)"),
                    refer.referee,
                    refer.referal
                )
            )
        );
        require(
            SignatureChecker.isValidSignatureNow(relayer, hash, signature),
            "Market: invalid signature"
        );
        return true;
    }
}

// File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)

pragma solidity ^0.8.0;


/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// File: @openzeppelin/contracts/utils/introspection/ERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;


/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File: @openzeppelin/contracts/token/ERC721/ERC721.sol


// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)

pragma solidity ^0.8.0;








/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _ownerOf(tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not token owner or approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        _requireMinted(tokenId);

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
        _safeTransfer(from, to, tokenId, data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
     */
    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId, 1);

        // Check that tokenId was not minted by `_beforeTokenTransfer` hook
        require(!_exists(tokenId), "ERC721: token already minted");

        unchecked {
            // Will not overflow unless all 2**256 token ids are minted to the same owner.
            // Given that tokens are minted one by one, it is impossible in practice that
            // this ever happens. Might change if we allow batch minting.
            // The ERC fails to describe this case.
            _balances[to] += 1;
        }

        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId, 1);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     * This is an internal function that does not check if the sender is authorized to operate on the token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId, 1);

        // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
        owner = ERC721.ownerOf(tokenId);

        // Clear approvals
        delete _tokenApprovals[tokenId];

        unchecked {
            // Cannot overflow, as that would require more tokens to be burned/transferred
            // out than the owner initially received through minting and transferring in.
            _balances[owner] -= 1;
        }
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId, 1);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId, 1);

        // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");

        // Clear approvals from the previous owner
        delete _tokenApprovals[tokenId];

        unchecked {
            // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
            // `from`'s balance is the number of token held, which is at least one before the current
            // transfer.
            // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
            // all 2**256 token ids to be minted, which in practice is impossible.
            _balances[from] -= 1;
            _balances[to] += 1;
        }
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId, 1);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits an {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits an {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Reverts if the `tokenId` has not been minted yet.
     */
    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
     * - When `from` is zero, the tokens will be minted for `to`.
     * - When `to` is zero, ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256, /* firstTokenId */
        uint256 batchSize
    ) internal virtual {
        if (batchSize > 1) {
            if (from != address(0)) {
                _balances[from] -= batchSize;
            }
            if (to != address(0)) {
                _balances[to] += batchSize;
            }
        }
    }

    /**
     * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
     * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
     * - When `from` is zero, the tokens were minted for `to`.
     * - When `to` is zero, ``from``'s tokens were burned.
     * - `from` and `to` are never both zero.
     * - `batchSize` is non-zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual {}
}

// File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)

pragma solidity ^0.8.0;


/**
 * @dev ERC721 token with storage based token URI management.
 */
abstract contract ERC721URIStorage is ERC721 {
    using Strings for uint256;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    /**
     * @dev See {ERC721-_burn}. This override additionally checks to see if a
     * token-specific URI was set for the token, and if so, it deletes the token URI from
     * the storage mapping.
     */
    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}

// File: contracts/ERC721Minter.sol


pragma solidity 0.8.5;




contract ERC721Minter is IERC721Minter, ERC721URIStorage, Ownable {
    //Last token id minted in this contract.
    uint256 private _tokenId;
    //Address of the media contract.
    address private _platform;
    //Address of contract admin.
    address public admin;

    //Token ID=>Creator Address
    mapping(uint256 => address) private _creators;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        admin = tx.origin;
    }

    modifier onlyPlatform() {
        require(
            msg.sender == _platform,
            "ERC721Minter: can only be called from platform"
        );
        _;
    }

    function setPlatform(address nftPlatform) external override {
        require(
            _platform == address(0),
            "ERC721Minter: platform already initialised"
        );
        require(
            tx.origin == admin,
            "ERC721Minter: only admin can set platform"
        );
        require(
            nftPlatform != address(0),
            "ERC721Minter: invalid platform address"
        );
        _platform = nftPlatform;
    }

    function tokenId() external view override onlyPlatform returns (uint256) {
        return _tokenId;
    }

    function creators(uint256 id)
        external
        view
        override
        onlyPlatform
        returns (address)
    {
        return _creators[id];
    }

    function checkCreator(uint256 id, address creator)
        external
        view
        override
        onlyPlatform
        returns (bool)
    {
        return creator == _creators[id];
    }

    function exists(uint256 id)
        external
        view
        override
        onlyPlatform
        returns (bool)
    {
        return _exists(id);
    }

    function mint(address creator, string calldata tokenUri)
        external
        override
        onlyPlatform
    {
        _tokenId++;
        _safeMint(creator, _tokenId);
        _creators[_tokenId] = creator;
        _setTokenURI(_tokenId, tokenUri);
    }

    function burn(uint256 id) external override {
        _requireMinted(id);
        require(
            msg.sender == ownerOf(id),
            "ERC721Minter: Only Owner can burn the token"
        );
        _burn(id);
    }
    
    function approveToken(address to, uint256 id) external override onlyPlatform{
        _approve(to,id);
    }
}

// File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol


// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)

pragma solidity ^0.8.0;


/**
 * @dev _Available since v3.1._
 */
interface IERC1155Receiver is IERC165 {
    /**
     * @dev Handles the receipt of a single ERC1155 token type. This function is
     * called at the end of a `safeTransferFrom` after the balance has been updated.
     *
     * NOTE: To accept the transfer, this must return
     * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     * (i.e. 0xf23a6e61, or its own function selector).
     *
     * @param operator The address which initiated the transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param id The ID of the token being transferred
     * @param value The amount of tokens being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
     */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @dev Handles the receipt of a multiple ERC1155 token types. This function
     * is called at the end of a `safeBatchTransferFrom` after the balances have
     * been updated.
     *
     * NOTE: To accept the transfer(s), this must return
     * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     * (i.e. 0xbc197c81, or its own function selector).
     *
     * @param operator The address which initiated the batch transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param ids An array containing ids of each token being transferred (order and length must match values array)
     * @param values An array containing amounts of each token being transferred (order and length must match ids array)
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

// File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)

pragma solidity ^0.8.0;


/**
 * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
 * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155MetadataURI is IERC1155 {
    /**
     * @dev Returns the URI for token type `id`.
     *
     * If the `\{id\}` substring is present in the URI, it must be replaced by
     * clients with the actual token type ID.
     */
    function uri(uint256 id) external view returns (string memory);
}

// File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol


// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)

pragma solidity ^0.8.0;







/**
 * @dev Implementation of the basic standard multi-token.
 * See https://eips.ethereum.org/EIPS/eip-1155
 * Originally based on code by Enjin: https://github.com/enjin/erc-1155
 *
 * _Available since v3.1._
 */
contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
    using Address for address;

    // Mapping from token ID to account balances
    mapping(uint256 => mapping(address => uint256)) private _balances;

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
    string private _uri;

    /**
     * @dev See {_setURI}.
     */
    constructor(string memory uri_) {
        _setURI(uri_);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the same URI for *all* token types. It relies
     * on the token type ID substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * Clients calling this function must replace the `\{id\}` substring with the
     * actual token type ID.
     */
    function uri(uint256) public view virtual override returns (string memory) {
        return _uri;
    }

    /**
     * @dev See {IERC1155-balanceOf}.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
        require(account != address(0), "ERC1155: address zero is not a valid owner");
        return _balances[id][account];
    }

    /**
     * @dev See {IERC1155-balanceOfBatch}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        public
        view
        virtual
        override
        returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];
    }

    /**
     * @dev See {IERC1155-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );
        _safeTransferFrom(from, to, id, amount, data);
    }

    /**
     * @dev See {IERC1155-safeBatchTransferFrom}.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner or approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }
        _balances[id][to] += amount;

        emit TransferSingle(operator, from, to, id, amount);

        _afterTokenTransfer(operator, from, to, ids, amounts, data);

        _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
        require(to != address(0), "ERC1155: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
            _balances[id][to] += amount;
        }

        emit TransferBatch(operator, from, to, ids, amounts);

        _afterTokenTransfer(operator, from, to, ids, amounts, data);

        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
    }

    /**
     * @dev Sets a new URI for all token types, by relying on the token type ID
     * substitution mechanism
     * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
     *
     * By this mechanism, any occurrence of the `\{id\}` substring in either the
     * URI or any of the amounts in the JSON file at said URI will be replaced by
     * clients with the token type ID.
     *
     * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
     * interpreted by clients as
     * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
     * for token type ID 0x4cce0.
     *
     * See {uri}.
     *
     * Because these URIs cannot be meaningfully represented by the {URI} event,
     * this function emits no events.
     */
    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }

    /**
     * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function _mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        _balances[id][to] += amount;
        emit TransferSingle(operator, address(0), to, id, amount);

        _afterTokenTransfer(operator, address(0), to, ids, amounts, data);

        _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function _mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "ERC1155: mint to the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);

        for (uint256 i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] += amounts[i];
        }

        emit TransferBatch(operator, address(0), to, ids, amounts);

        _afterTokenTransfer(operator, address(0), to, ids, amounts, data);

        _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
    }

    /**
     * @dev Destroys `amount` tokens of token type `id` from `from`
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `from` must have at least `amount` tokens of token type `id`.
     */
    function _burn(
        address from,
        uint256 id,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");

        address operator = _msgSender();
        uint256[] memory ids = _asSingletonArray(id);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
        unchecked {
            _balances[id][from] = fromBalance - amount;
        }

        emit TransferSingle(operator, from, address(0), id, amount);

        _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
    }

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     */
    function _burnBatch(
        address from,
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal virtual {
        require(from != address(0), "ERC1155: burn from the zero address");
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");

        for (uint256 i = 0; i < ids.length; i++) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
        }

        emit TransferBatch(operator, from, address(0), ids, amounts);

        _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits an {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC1155: setting approval status for self");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning, as well as batched variants.
     *
     * The same hook is called on both single and batched variants. For single
     * transfers, the length of the `ids` and `amounts` arrays will be 1.
     *
     * Calling conditions (for each `id` and `amount` pair):
     *
     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * of token type `id` will be  transferred to `to`.
     * - When `from` is zero, `amount` tokens of token type `id` will be minted
     * for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
     * will be burned.
     * - `from` and `to` are never both zero.
     * - `ids` and `amounts` have the same, non-zero length.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {}

    /**
     * @dev Hook that is called after any token transfer. This includes minting
     * and burning, as well as batched variants.
     *
     * The same hook is called on both single and batched variants. For single
     * transfers, the length of the `id` and `amount` arrays will be 1.
     *
     * Calling conditions (for each `id` and `amount` pair):
     *
     * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * of token type `id` will be  transferred to `to`.
     * - When `from` is zero, `amount` tokens of token type `id` will be minted
     * for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
     * will be burned.
     * - `from` and `to` are never both zero.
     * - `ids` and `amounts` have the same, non-zero length.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {}

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
                if (response != IERC1155Receiver.onERC1155Received.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non-ERC1155Receiver implementer");
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
                bytes4 response
            ) {
                if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non-ERC1155Receiver implementer");
            }
        }
    }

    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}

// File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155URIStorage.sol)

pragma solidity ^0.8.0;



/**
 * @dev ERC1155 token with storage based token URI management.
 * Inspired by the ERC721URIStorage extension
 *
 * _Available since v4.6._
 */
abstract contract ERC1155URIStorage is ERC1155 {
    using Strings for uint256;

    // Optional base URI
    string private _baseURI = "";

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    /**
     * @dev See {IERC1155MetadataURI-uri}.
     *
     * This implementation returns the concatenation of the `_baseURI`
     * and the token-specific uri if the latter is set
     *
     * This enables the following behaviors:
     *
     * - if `_tokenURIs[tokenId]` is set, then the result is the concatenation
     *   of `_baseURI` and `_tokenURIs[tokenId]` (keep in mind that `_baseURI`
     *   is empty per default);
     *
     * - if `_tokenURIs[tokenId]` is NOT set then we fallback to `super.uri()`
     *   which in most cases will contain `ERC1155._uri`;
     *
     * - if `_tokenURIs[tokenId]` is NOT set, and if the parents do not have a
     *   uri value set, then the result is empty.
     */
    function uri(uint256 tokenId) public view virtual override returns (string memory) {
        string memory tokenURI = _tokenURIs[tokenId];

        // If token URI is set, concatenate base URI and tokenURI (via abi.encodePacked).
        return bytes(tokenURI).length > 0 ? string(abi.encodePacked(_baseURI, tokenURI)) : super.uri(tokenId);
    }

    /**
     * @dev Sets `tokenURI` as the tokenURI of `tokenId`.
     */
    function _setURI(uint256 tokenId, string memory tokenURI) internal virtual {
        _tokenURIs[tokenId] = tokenURI;
        emit URI(uri(tokenId), tokenId);
    }

    /**
     * @dev Sets `baseURI` as the `_baseURI` for all tokens
     */
    function _setBaseURI(string memory baseURI) internal virtual {
        _baseURI = baseURI;
    }
}

// File: contracts/ERC1155Minter.sol


pragma solidity 0.8.5;




contract ERC1155Minter is IERC1155Minter, ERC1155URIStorage, Ownable {
    //Address of admin of the contract.
    address public admin;
    //Name of the ERC1155 tokens collection.
    string public name;
    //Symbol of the ERC1155 tokens collection.
    string public symbol;

    //Token ID of the last token minted in the contract.
    uint256 private _tokenId;
    //Address of the media contract.
    address private _platform;

    //Token ID=>Creator Address
    mapping(uint256 => address) private _creators;

    constructor(string memory _name, string memory _symbol) ERC1155("") {
        name = _name;
        symbol = _symbol;
        admin = tx.origin;
    }


    modifier onlyPlatform() {
        require(
            msg.sender == _platform,
            "ERC1155Minter: can only be called from platform"
        );
        _;
    }

    function setPlatform(address nftPlatform) external override {
        require(
            tx.origin == admin,
            "ERC1155Minter: only admin can set platform"
        );
        require(
            nftPlatform != address(0),
            "ERC1155Minter: invalid platform address"
        );
        require(
            _platform == address(0),
            "ERC1155Minter: platform already initialised"
        );
        _platform = nftPlatform;
    }

    function tokenId() external view override onlyPlatform returns (uint256) {
        return _tokenId;
    }

    function creators(uint256 id)
        external
        view
        override
        onlyPlatform
        returns (address)
    {
        return _creators[id];
    }

    function checkCreator(uint256 id, address creator)
        external
        view
        override
        onlyPlatform
        returns (bool)
    {
        return creator == _creators[id];
    }

    function mint(
        address creator,
        uint256 amount,
        string calldata tokenUri
    ) external override onlyPlatform {
        _tokenId++;
        _mint(creator, _tokenId, amount, "");
        _creators[_tokenId] = creator;
        _setURI(_tokenId, tokenUri);
    }

    function burn(uint256 id, uint256 amount) external override {
        require(
            amount <= balanceOf(msg.sender, id),
            "ERC1155Minter: insufficient amount"
        );
        _burn(msg.sender, id, amount);
    }

    function approveToken(address from, address to, bool approved) external override onlyPlatform {
        _setApprovalForAll(from, to, approved);
    }
}

// File: contracts/Collections.sol


pragma solidity 0.8.5;




contract Collections is Ownable {
    //Address of the media contract
    address private _platform;

    //TokenContractAddress=>bool
    mapping(address => bool) public isDeployedMinters;

    constructor() {}

    modifier onlyPlatform() {
        require(
            msg.sender == _platform,
            "Collections: can only be called from platform"
        );
        _;
    }

    function setPlatform(address nftPlatform) external {
        require(
            _platform == address(0),
            "Collections: platform already initialised"
        );
        require(
            tx.origin == owner(),
            "Collections: only owner can set platform"
        );
        require(
            nftPlatform != address(0),
            "Collections: invalid platform address"
        );
        _platform = nftPlatform;
    }

    function createERC721(
        string memory name,
        string memory symbol
    ) external onlyPlatform returns (address) {
        ERC721Minter newERC721Minter = new ERC721Minter(name, symbol);
        ERC721Minter(newERC721Minter).setPlatform(_platform);
        isDeployedMinters[address(newERC721Minter)] = true;
        return address(newERC721Minter);
    }

    function createERC1155(
        string memory name,
        string memory symbol
    ) external onlyPlatform returns (address) {
        ERC1155Minter newERC1155Minter = new ERC1155Minter(name, symbol);
        ERC1155Minter(newERC1155Minter).setPlatform(_platform);
        isDeployedMinters[address(newERC1155Minter)] = true;
        return address(newERC1155Minter);
    }

    function checkDeployedMinters(
        address tokenAddress
    ) public view onlyPlatform returns (bool) {
        return isDeployedMinters[tokenAddress];
    }
}

// File: contracts/Media.sol


pragma solidity 0.8.5;







contract Media is IMarket, Ownable {
    //Enum for choosing what to do with the tokens after minting.
    enum AfterMint {
        AUCTION,
        FIXED_SALE,
        ON_HOLD,
        TIMED_AUCTION
    }

    //Address of the market contract.
    address payable private _marketAddress;
    //Address of the collection creation contract.
    address private _collectionsAddress;
    // address private _dropsAddress;
    //Address of the nominated owner. This address is nominated by the current contract owner to transfer ownership to.
    address private _ownerNominee;

    //Address of the initially deployed ERC721Minter contract.
    address public immutable defaultERC721Address;
    //Address of the initially deployed ERC1155Minter contract.
    address public immutable defaultERC1155Address;

    //URI string=>Boolean
    mapping(string => bool) private _uriExists;

    constructor(address collections, address market) {

        _marketAddress = payable(market);
        _collectionsAddress = collections;

        Market(_marketAddress).setPlatform(address(this));
        Collections(_collectionsAddress).setPlatform(address(this));

        defaultERC721Address = Collections(_collectionsAddress).createERC721(
            "NFTTALENT",
            "NFTT"
        );
        defaultERC1155Address = Collections(_collectionsAddress).createERC1155(
            "NFTTALENT",
            "NFTT"
        );
    }


    /**
     * @dev Owner of the smart contract nominates another address to transfer ownership to.
     *
     * Requirements:
     *
     * - The caller of this function must be `owner` i.e. the owner of this smart contract.
     * - `nominee` cannot be the zero address.
     */
    function nominateOwner(address nominee) external onlyOwner {
        require(nominee != address(0), "Media: invalid address");
        _ownerNominee = nominee;
    }

    /**
     * @dev Crea.
     *
     * Requirements:
     *
     * - The caller of this function must be `_ownerNominee` i.e. the address nominated to be the
     *   owner of this smart contract.
     */
    function createNewCollection(
        bool isFungible,
        string calldata name,
        string calldata symbol
    ) external returns (address) {
        require(bytes(name).length > 0, "Media: name cannot be empty");
        require(bytes(symbol).length > 0, "Media: symbol cannot be empty");
        if (isFungible) {
            return Collections(_collectionsAddress).createERC1155(name, symbol);
        } else {
            return Collections(_collectionsAddress).createERC721(name, symbol);
        }
    }

    function mintToken(
        address tokenAddress,
        string memory tokenUri,
        uint256 supply,
        address[] memory collaborator,
        uint256[] memory percentage,
        uint256 royalty,
        uint256 price,
        AfterMint afterMint,
        uint256 startTime,
        uint256 endTime
    ) external {
        require(supply != 0, "Media: supply cannot be zero");
        require(
            !_uriExists[tokenUri],
            "Media: token already exists with the given URI"
        );
        require(
            collaborator.length == percentage.length,
            "Media: array length mismatch"
        );
        uint256 tokenId;
        if (IERC1155(tokenAddress).supportsInterface(0xd9b67a26)) {
            IERC1155Minter(tokenAddress).mint(msg.sender, supply, tokenUri);
            tokenId = IERC1155Minter(tokenAddress).tokenId();
            IERC1155Minter(tokenAddress).approveToken(
                msg.sender,
                address(this),
                true
            );
        } else if (IERC721(tokenAddress).supportsInterface(0x80ac58cd)) {
            require(
                supply == 1,
                "Media: only one erc721 non-fungible token can be minted"
            );
            IERC721Minter(tokenAddress).mint(msg.sender, tokenUri);
            tokenId = IERC721Minter(tokenAddress).tokenId();
            IERC721Minter(tokenAddress).approveToken(address(this), tokenId);
        } else {
            revert("Media: invalid token address for minting");
        }
        Market(_marketAddress).setCollaborators(
            tokenAddress,
            tokenId,
            collaborator,
            percentage
        );
        Market(_marketAddress).setRoyaltyPoints(tokenAddress, tokenId, royalty);
        _uriExists[tokenUri] = true;

        if (afterMint == AfterMint.AUCTION) {
            Market(_marketAddress).putOnAuction(
                tokenAddress,
                tokenId,
                msg.sender,
                price * supply,
                supply,
                0,
                0
            );
        } else if (afterMint == AfterMint.FIXED_SALE) {
            Market(_marketAddress).listOnSale(
                tokenAddress,
                tokenId,
                msg.sender,
                price,
                supply
            );
        } else if (afterMint == AfterMint.TIMED_AUCTION) {
            Market(_marketAddress).putOnAuction(
                tokenAddress,
                tokenId,
                msg.sender,
                price * supply,
                supply,
                startTime,
                endTime
            );
        }
    }

    //TODO: call the approve functions for the tokens put on auction
    function putOnSell(
        address tokenAddress,
        uint256 tokenId,
        uint256 price,
        uint256 quantityOftoken
    ) external {
        require(quantityOftoken > 0, "Media: quantity can not be zero or less");
        if (IERC721(tokenAddress).supportsInterface(0x80ac58cd)) {
            require(
                IERC721(tokenAddress).ownerOf(tokenId) == msg.sender,
                "Media: you are not the owner"
            );
            require(
                quantityOftoken == 1,
                "Media: quantity can not be more than 1"
            );
            require(
                IERC721(tokenAddress).getApproved(tokenId) == address(this) ||
                    IERC721(tokenAddress).isApprovedForAll(
                        msg.sender,
                        address(this)
                    ),
                "Media: not approved"
            );
            Market(_marketAddress).listOnSale(
                tokenAddress,
                tokenId,
                msg.sender,
                price,
                1
            );
        } else if (IERC1155(tokenAddress).supportsInterface(0xd9b67a26)) {
            require(
                IERC1155(tokenAddress).balanceOf(msg.sender, tokenId) >=
                    quantityOftoken,
                "Media: not sufficient tokens available"
            );
            require(
                IERC1155(tokenAddress).isApprovedForAll(
                    msg.sender,
                    address(this)
                ),
                "Media: not approved"
            );
            Market(_marketAddress).listOnSale(
                tokenAddress,
                tokenId,
                msg.sender,
                price,
                quantityOftoken
            );
        } else {
            revert("Media: invalid token address");
        }
    }

    function directBuy(
        address tokenAddress,
        uint256 id,
        address from,
        uint256 quantity,
        Refer memory refer,
        bytes memory signature
    ) external payable {
        address creator;
        if (IERC721(tokenAddress).supportsInterface(0x80ac58cd)) {
            require(quantity == 1, "Media: quantity can not be more than 1");
            if (
                Collections(_collectionsAddress).checkDeployedMinters(
                    tokenAddress
                )
            ) creator = IERC721Minter(tokenAddress).creators(id);
            Market(_marketAddress).directBuy(
                tokenAddress,
                id,
                creator,
                from,
                msg.sender,
                msg.value,
                1,
                refer,
                signature
            );
            IERC721(tokenAddress).safeTransferFrom(from, msg.sender, id);
        } else if (IERC1155(tokenAddress).supportsInterface(0xd9b67a26)) {
            if (
                Collections(_collectionsAddress).checkDeployedMinters(
                    tokenAddress
                )
            ) creator = IERC1155Minter(tokenAddress).creators(id);
            Market(_marketAddress).directBuy(
                tokenAddress,
                id,
                creator,
                from,
                msg.sender,
                msg.value,
                quantity,
                refer,
                signature
            );
            IERC1155(tokenAddress).safeTransferFrom(
                from,
                msg.sender,
                id,
                quantity,
                ""
            );
        } else {
            revert("Media: invalid token address");
        }
        _marketAddress.transfer(msg.value);
    }

    function withdrawSale(address tokenAddress, uint256 id) external {
        Market(_marketAddress).withdrawSale(tokenAddress, id, msg.sender);
    }

    function putOnAuction(
        address tokenAddress,
        uint256 id,
        uint256 price,
        uint256 quantity,
        uint256 startTime,
        uint256 endTime
    ) external {
        if (IERC721(tokenAddress).supportsInterface(0x80ac58cd)) {
            require(
                IERC721(tokenAddress).ownerOf(id) == msg.sender,
                "Media: you are not the owner"
            );
            require(quantity == 1, "Media: quantity can not be more than 1");
            Market(_marketAddress).putOnAuction(
                tokenAddress,
                id,
                msg.sender,
                price,
                1,
                startTime,
                endTime
            );
        } else if (IERC1155(tokenAddress).supportsInterface(0xd9b67a26)) {
            require(
                IERC1155(tokenAddress).balanceOf(msg.sender, id) >= quantity,
                "Media: not sufficient tokens available"
            );
            Market(_marketAddress).putOnAuction(
                tokenAddress,
                id,
                msg.sender,
                price,
                quantity,
                startTime,
                endTime
            );
        } else {
            revert("Media: invalid token address address");
        }
    }

    function bid(
        address tokenAddress,
        uint256 id,
        address from
    ) external payable {
        if (IERC721(tokenAddress).supportsInterface(0x80ac58cd)) {
            Market(_marketAddress).bid(
                tokenAddress,
                id,
                from,
                msg.sender,
                msg.value
            );
        } else if (IERC1155(tokenAddress).supportsInterface(0xd9b67a26)) {
            Market(_marketAddress).bid(
                tokenAddress,
                id,
                from,
                msg.sender,
                msg.value
            );
        } else {
            revert("Media: invalid token address");
        }
        _marketAddress.transfer(msg.value);
    }

    //TODO: approve media contract for transfer
    function acceptBid(
        address tokenAddress,
        uint256 id,
        address bidder,
        uint256 quantity,
        Refer memory refer,
        bytes memory signature
    ) external {
        address creator;
        if (IERC721(tokenAddress).supportsInterface(0x80ac58cd)) {
            require(
                IERC721(tokenAddress).ownerOf(id) == msg.sender,
                "Media: you are not the owner of the token"
            );
            require(quantity == 1, "Media: quantity can not be more than 1");
            if (
                Collections(_collectionsAddress).checkDeployedMinters(
                    tokenAddress
                )
            ) creator = IERC721Minter(tokenAddress).creators(id);
            Market(_marketAddress).acceptBid(
                tokenAddress,
                id,
                creator,
                msg.sender,
                bidder,
                1,
                refer,
                signature
            );
            IERC721(tokenAddress).safeTransferFrom(msg.sender, bidder, id);
        } else if (IERC1155(tokenAddress).supportsInterface(0xd9b67a26)) {
            require(
                IERC1155(tokenAddress).balanceOf(msg.sender, id) >= quantity,
                "Media: not sufficient tokens available"
            );
            if (
                Collections(_collectionsAddress).checkDeployedMinters(
                    tokenAddress
                )
            ) creator = IERC1155Minter(tokenAddress).creators(id);
            Market(_marketAddress).acceptBid(
                tokenAddress,
                id,
                creator,
                msg.sender,
                bidder,
                quantity,
                refer,
                signature
            );
            IERC1155(tokenAddress).safeTransferFrom(
                msg.sender,
                bidder,
                id,
                quantity,
                ""
            );
        } else {
            revert("Media: invalid token address");
        }
    }

    function claim(
        address tokenAddress,
        uint256 id,
        address from,
        uint256 quantity,
        Refer memory refer,
        bytes memory signature
    ) external {
        address creator;
        if (IERC721(tokenAddress).supportsInterface(0x80ac58cd)) {
            require(
                IERC721(tokenAddress).ownerOf(id) == from,
                "Media: wrong owner address"
            );
            require(quantity == 1, "Media: quantity can not be more than 1");
            if (
                Collections(_collectionsAddress).checkDeployedMinters(
                    tokenAddress
                )
            ) creator = IERC721Minter(tokenAddress).creators(id);
            Market(_marketAddress).claim(
                tokenAddress,
                from,
                creator,
                msg.sender,
                id,
                1,
                refer,
                signature
            );
            IERC721(tokenAddress).safeTransferFrom(from, msg.sender, id);
        } else if (IERC1155(tokenAddress).supportsInterface(0xd9b67a26)) {
            require(
                IERC1155(tokenAddress).balanceOf(from, id) >= quantity,
                "Media: owner does not have sufficient tokens"
            );
            if (
                Collections(_collectionsAddress).checkDeployedMinters(
                    tokenAddress
                )
            ) creator = IERC1155Minter(tokenAddress).creators(id);
            Market(_marketAddress).claim(
                tokenAddress,
                from,
                creator,
                msg.sender,
                id,
                quantity,
                refer,
                signature
            );
            IERC1155(tokenAddress).safeTransferFrom(
                from,
                msg.sender,
                id,
                quantity,
                ""
            );
        } else {
            revert("Media: invalid token address");
        }
    }

    function rejectBid(
        address tokenAddress,
        uint256 id,
        address bidder
    ) external {
        Market(_marketAddress).removeBid(tokenAddress, msg.sender, id, bidder);
    }

    function withdrawBid(
        address tokenAddress,
        uint256 id,
        address from
    ) external {
        Market(_marketAddress).removeBid(tokenAddress, from, id, msg.sender);
    }

    function withdrawAuction(address tokenAddress, uint256 id) external {
        Market(_marketAddress).withdrawAuction(tokenAddress, id, msg.sender);
    }

    function redeem(uint256 points) external {
        Market(_marketAddress).redeemPoints(msg.sender, points);
    }

    function setCommisionAndReferReward(
        uint256 _commission,
        uint256 _refereeReward,
        uint256 _referalReward
    ) external onlyOwner {
        Market(_marketAddress).setCommisionAndReferReward(
            _commission,
            _refereeReward,
            _referalReward
        );
    }

    function setRelayer(address _relayer) external onlyOwner {
        Market(_marketAddress).setRelayer(_relayer);
    }

    function viewMyPoints() external view returns (uint256) {
        return Market(_marketAddress).viewPoints(msg.sender);
    }
}
