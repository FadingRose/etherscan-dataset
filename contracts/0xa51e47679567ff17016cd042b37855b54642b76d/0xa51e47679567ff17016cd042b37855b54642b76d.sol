// SPDX-License-Identifier: MIT
    pragma solidity ^0.8.4;

    
    //  https://btctradecat.org

    //  https://x.com/btctradecat  

    //  Writing a smart contract is a unique form of art that will live ∞ forever ∞ on the blockchain   

    // The BTC Trade Cat collection, consisting of 10,000 PFPs, blends old-school charm with blockchain technology, 
    // creating unique NFTs that leave a mark in digital art. 
    // Each cat, dressed in vibrant cyberpunk attire with neon accents, reflects a deep connection to cryptocurrency.
    // These cats are not just traders but also collectors of history, adorned with retro items and iconic Bitcoin symbols.
    
    // Their leather gloves and robotic limbs represent a harmony of past and future, creating a sense of timelessness. 
    // The comic book style evokes warm memories, resonating with both eyes and heart. 
    // A golden Bitcoin pendant around each cat's neck highlights their dedication to the crypto world.
    
    // The BTC Trade Cat collection is a celebration of the unique and enduring value of digital assets,
    // capturing the essence of history and modernity in a way that deeply resonates with collectors.
    // It aims to create lasting value and a sense of nostalgia while pushing the boundaries of innovation in the digital art world.


    //____₿₿________________₿______________________
    //___₿₿₿₿_____________₿₿₿₿______________________
    //___₿₿₿₿₿₿₿_______₿₿₿₿₿₿₿______________________
    //___₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿________________________
    //___₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿________________________
    //____₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿_______________________
    //____₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿__________________________
    //____₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿___________________________
    //____₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿__________________________
    //_____₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿_________________________
    //____₿₿_₿₿₿₿₿₿₿₿₿₿₿₿₿_₿₿₿________________________
    //____₿₿______BTC________₿₿₿₿______________________
    //____₿₿_____TRADE________₿₿₿₿₿___________________
    //____₿₿______CAT_________₿₿₿₿₿₿₿__________________
    //____₿₿₿______₿__________₿₿₿₿₿₿₿₿________________
    //_____₿₿________________₿₿₿₿₿₿₿₿₿₿₿_____________
    //______₿₿_____________₿₿₿₿₿₿₿₿₿₿₿₿₿₿___________
    //_______₿₿₿________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿__________
    //_________₿₿_____₿ ₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿_________
    //_________₿₿₿__₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿________
    //_________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿________
    //_________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿______
    //________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿______
    //________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿_____
    //________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿_____
    //________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿____
    //_____₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿____
    //_____₿_₿_₿_₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿____
    //_____________________________________₿₿₿₿₿₿₿₿₿₿____
    //______________________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿_____
    //___________________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿______
    //_________________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿________
    //_________________₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿₿_____________
    //____________________₿₿₿₿₿₿₿₿₿₿₿______________________________    


    library Address {
    /**
     * @dev Checks if the address is a contract.
     * It uses the extcodesize assembly instruction to check for the presence of contract code.
     * This is useful to ensure certain operations are performed only by contracts.
     */
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    /**
     * @dev Sends `amount` wei to `recipient`, forwarding all gas and reverting on errors.
     * This function is designed to replace Solidity's `transfer` method, which imposes a 2300 gas limit.
     * By forwarding all gas, it removes this limit, enabling interaction with certain contracts.
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a low-level call to the target address with the provided data.
     * If the call fails, it reverts with a default error message.
     * This is a safer replacement for a low-level call.
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as `functionCall`, but with a custom error message when the call fails.
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as `functionCall`, but also transferring `value` wei to the target address.
     * This is useful for calls that need to send Ether along with the function call.
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as `functionCallWithValue`, but with a custom error message when the call fails.
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    /**
     * @dev Internal function to perform a call with `value` wei and handle potential revert reasons.
     * It ensures the target address is a contract and attempts the call.
     * If the call fails, it bubbles up the revert reason.
     */
    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
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

    library Counters {
    /**
     * @dev A counter that can only be incremented, decremented, or reset.
     * This is useful for tracking the number of elements in a mapping or the issuance of IDs.
     */
    struct Counter {
        uint256 _value; // Default: 0
    }

    /**
     * @dev Returns the current value of the counter.
     * This function is read-only and does not modify the state.
     */
    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    /**
     * @dev Increments the counter by 1.
     * This is useful for generating new IDs or counting events.
     */
    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    /**
     * @dev Decrements the counter by 1.
     * This reverts if the counter is already at 0, preventing underflow.
     */
    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    /**
     * @dev Resets the counter back to 0.
     * This is useful for reinitializing counters.
     */
    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

    library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     * This function is useful for converting numerical values to their string equivalents.
     */
    function toString(uint256 value) internal pure returns (string memory) {
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
     * This is useful for displaying values in a more compact, hexadecimal format.
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
     * This is useful for creating fixed-length hexadecimal strings.
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

    /**
     * @dev Converts an `address` to its ASCII `string` hexadecimal representation.
     * This is useful for displaying addresses in a readable format.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), 20);
    }
}

    interface IERC165 {
    /**
     * @dev Checks if the contract implements the interface defined by `interfaceId`.
     * This is important for ensuring compatibility and interoperability between contracts.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

    interface IERC2981 is IERC165 {
    /**
     * @dev Provides royalty information for a specific token ID and sale price.
     * This is useful for ensuring artists and creators receive royalties on secondary sales.
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice) external view returns (address receiver, uint256 royaltyAmount);
}

    interface IContractMetadata {
    /**
     * @dev Retrieves the contract metadata, including name, description, and other details.
     * This is useful for providing detailed information about the contract.
     */
    function getContractMetadata() external view returns (string memory, string memory, string memory, string memory);
}

    abstract contract ERC165 is IERC165 {
    /**
     * @dev Implements the `supportsInterface` function to check for supported interfaces.
     * This contract allows other contracts to verify what interfaces this contract implements.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

    interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens owned by `owner`.
     * This is useful for tracking token ownership.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     * This is crucial for ensuring only the rightful owner can transfer or manage the token.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     * This ensures the recipient is capable of receiving ERC721 tokens.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     * This is a non-safe transfer and should be used with caution.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Approves `to` to transfer `tokenId` token.
     * This allows the approved address to transfer the token on behalf of the owner.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     * This is useful for checking who can transfer the token.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approves or revokes `operator` to transfer all tokens owned by the caller.
     * This allows for bulk management of token approvals.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Checks if `operator` is approved to manage all of the assets of `owner`.
     * This is useful for bulk management of token transfers.
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to` with additional data.
     * This ensures the recipient can handle ERC721 tokens and processes additional data.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

    interface IERC721Receiver {
    /**
     * @dev Whenever an ERC721 token is transferred to this contract via `safeTransferFrom`
     * by `operator` from `from`, this function is called.
     * It must return its Solidity selector to confirm the token transfer.
     */
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

    interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the name of the token collection.
     * This is useful for displaying the collection name in interfaces.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token collection.
     * This is useful for displaying the token symbol in interfaces.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     * This is useful for linking to off-chain metadata associated with the token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

    abstract contract Context {
    /**
     * @dev Provides information about the current execution context, including the sender of the transaction and its data.
     * This is useful for contracts that operate in a context-sensitive manner, such as those using meta-transactions.
     */
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
     * @dev Initializes the contract by setting the deployer as the initial owner.
     * This provides an ownership mechanism for the contract.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     * This allows for ownership verification.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     * This ensures only the owner can call certain functions.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Renounces ownership of the contract.
     * This leaves the contract without an owner, making all `onlyOwner` functions inaccessible.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * This provides a mechanism for transferring ownership.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Internal function to transfer ownership of the contract to a new account (`newOwner`).
     * This function does not have access restrictions.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

    library BitMaps {
    struct BitMap {
        mapping(uint256 => uint256) map;
    }

    /**
     * @dev Returns whether the bit at `index` is set.
     * This is useful for tracking whether certain bits are set in a large bit array.
     */
    function getBit(BitMap storage bitmap, uint256 index) internal view returns (bool) {
        uint256 bucket = index >> 8;
        uint256 mask = 1 << (index & 0xff);
        return bitmap.map[bucket] & mask != 0;
    }

    /**
     * @dev Sets the bit at `index`.
     * This is useful for marking bits as set in a large bit array.
     */
    function setBit(BitMap storage bitmap, uint256 index) internal {
        uint256 bucket = index >> 8;
        uint256 mask = 1 << (index & 0xff);
        bitmap.map[bucket] |= mask;
    }

    /**
     * @dev Unsets the bit at `index`.
     * This is useful for marking bits as unset in a large bit array.
     */
    function unsetBit(BitMap storage bitmap, uint256 index) internal {
        uint256 bucket = index >> 8;
        uint256 mask = 1 << (index & 0xff);
        bitmap.map[bucket] &= ~mask;
    }
}

    abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * This is useful for protecting against reentrancy attacks.
     */
    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * This modifier ensures that a function cannot be re-entered while it is still executing.
     */
    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        _status = _ENTERED;

        _;

        _status = _NOT_ENTERED;
    }
}

    abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, Ownable, ReentrancyGuard {
    using Address for address;
    using Counters for Counters.Counter;
    using Strings for uint256;
    using BitMaps for BitMaps.BitMap;

    struct TokenOwnership {
        address addr;
        uint64 startTimestamp;
        bool burned;
    }

    struct AddressData {
        uint64 balance;
        uint64 numberMinted;
        uint64 numberBurned;
        uint64 aux;
    }

    Counters.Counter private _tokenIdTracker;
    uint256 private _burnCounter;
    uint256 private _totalMintedTokens;

    string private _name;
    string private _symbol;
    string internal _baseTokenURI;
    bool internal _useBaseURI;

    mapping(uint256 => TokenOwnership) private _ownerships;
    mapping(address => AddressData) private _addressData;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    mapping(uint256 => address) private _royaltyReceivers;
    mapping(uint256 => uint256) private _royaltyAmounts;
    BitMaps.BitMap private _mintedTokens;
    address public proxyRegistryAddress;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     * Also sets the proxy registry address for OpenSea compatibility.
     */
    constructor(string memory name_, string memory symbol_, address _proxyRegistryAddress) {
        _name = name_;
        _symbol = symbol_;
        proxyRegistryAddress = _proxyRegistryAddress;
    }

    /**
     * @dev Returns the starting token ID. Default is 0.
     * This allows customization of the starting token ID.
     */
    function _startTokenId() internal view virtual returns (uint256) {
        return 0; // Start minting from 0 instead of 1
    }

    /**
     * @dev Returns the total amount of tokens stored by the contract.
     * This includes both minted and burned tokens.
     */
    function totalSupply() public view virtual returns (uint256) {
        return _totalMintedTokens - _burnCounter;
    }

    /**
     * @dev Returns the owner of the `tokenId` token.
     * This is essential for managing token ownership and transfers.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        return _ownershipOf(tokenId).addr;
    }

    /**
     * @dev Returns the ownership details of the `tokenId` token.
     * This includes the address of the owner, the start timestamp, and whether the token is burned.
     */
    function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
        uint256 curr = tokenId;

        unchecked {
            if (_startTokenId() <= curr && curr < _tokenIdTracker.current()) {
                TokenOwnership memory ownership = _ownerships[curr];
                if (!ownership.burned) {
                    if (ownership.addr != address(0)) {
                        return ownership;
                    }
                    while (true) {
                        curr--;
                        ownership = _ownerships[curr];
                        if (ownership.addr != address(0)) {
                            return ownership;
                        }
                    }
                }
            }
        }
        revert("ERC721: owner query for nonexistent token");
    }

    /**
     * @dev Returns the number of tokens in `owner`'s account.
     * This function is useful for checking token balances.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "Balance query for the zero address");
        return _addressData[owner].balance;
    }

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     * This is a non-safe transfer and should be used with caution.
     * The caller must be the owner, an approved operator, or an approved address.
     */
    function transferFrom(address from, address to, uint256 tokenId) public virtual override nonReentrant {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }

    /**
     * @dev Approves `to` to transfer `tokenId` token to another account.
     * This function is useful for setting an approved address for a specific token.
     */
    function approve(address to, uint256 tokenId) public virtual override nonReentrant {
        address owner = ownerOf(tokenId);
        require(to != owner, "Approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "Approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev Returns the account approved for `tokenId` token.
     * This function is useful for checking the approved address for a specific token.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "Approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev Approves or revokes `operator` to transfer all tokens owned by the caller.
     * This is useful for bulk management of token approvals.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override nonReentrant {
        require(operator != _msgSender(), "Approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev Checks if `operator` is approved to manage all of the assets of `owner`.
     * This function is useful for bulk management of token transfers.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        if (address(proxyRegistry.proxies(owner)) == operator) {
            return true;
        }

        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     * This ensures the recipient is capable of receiving ERC721 tokens.
     * The caller must be the owner, an approved operator, or an approved address.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override nonReentrant {
        _safeTransfer(from, to, tokenId, "");
    }

    /**
     * @dev Same as `safeTransferFrom`, but with additional data.
     * This ensures the recipient can handle ERC721 tokens and processes additional data.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) public virtual override nonReentrant {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, data);
    }

    /**
     * @dev Internal function to safely transfer `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     * This ensures the recipient is capable of receiving ERC721 tokens.
     */
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "Transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     * This function is useful for checking the existence of a token.
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownershipOf(tokenId).addr != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     * This function is useful for checking if an address is approved to transfer a token.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "Operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Mints `quantity` tokens and transfers them to `to`.
     * The caller must be the owner.
     * This function is useful for creating new tokens.
     */
    function _mint(address to, uint256 quantity) internal virtual nonReentrant {
        uint256 startTokenId = _tokenIdTracker.current();
        require(to != address(0), "Mint to the zero address");
        require(quantity != 0, "Mint zero quantity");

        _beforeTokenTransfers(address(0), to, startTokenId, quantity);

        unchecked {
            _addressData[to].balance += uint64(quantity);
            _addressData[to].numberMinted += uint64(quantity);

            _ownerships[startTokenId] = TokenOwnership({
                addr: to,
                startTimestamp: uint64(block.timestamp),
                burned: false
            });

            uint256 updatedIndex = startTokenId;

            for (uint256 i = 0; i < quantity; i++) {
                require(!_mintedTokens.getBit(updatedIndex), "Token already minted");
                _mintedTokens.setBit(updatedIndex); // Marking the token as minted
                emit Transfer(address(0), to, updatedIndex);
                updatedIndex++;
                _tokenIdTracker.increment();
            }

            _totalMintedTokens += quantity; // Update total minted tokens
        }

        _afterTokenTransfers(address(0), to, startTokenId, quantity);
    }

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     * This function is used for token transfers and should be called by the owner or an approved operator.
     */
    function _transfer(address from, address to, uint256 tokenId) internal virtual nonReentrant {
        require(ownerOf(tokenId) == from, "Transfer of token that is not own");
        require(to != address(0), "Transfer to the zero address");

        _beforeTokenTransfers(from, to, tokenId, 1);

        _approve(address(0), tokenId);

        _addressData[from].balance -= 1;
        _addressData[to].balance += 1;

        _ownerships[tokenId] = TokenOwnership({
            addr: to,
            startTimestamp: uint64(block.timestamp),
            burned: false
        });

        emit Transfer(from, to, tokenId);

        _afterTokenTransfers(from, to, tokenId, 1);
    }

    /**
     * @dev Approves `to` to transfer `tokenId` token.
     * This function is useful for setting an approved address for a specific token.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     * This ensures the recipient is capable of receiving ERC721 tokens.
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("Transfer to non ERC721Receiver implementer");
                } else {
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
     * @dev Hook that is called before any token transfer. This includes minting and burning.
     * This function allows for custom logic to be executed before transfers.
     */
    function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}

    /**
     * @dev Hook that is called after any token transfer. This includes minting and burning.
     * This function allows for custom logic to be executed after transfers.
     */
    function _afterTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual {}

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     * This function is useful for linking to off-chain metadata associated with the token.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");

        if (_useBaseURI) {
            string memory baseURI = _baseURI();
            return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
        } else {
            return "";
        }
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev Returns the name of the token collection.
     * This function is useful for displaying the collection name in interfaces.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token collection.
     * This function is useful for displaying the token symbol in interfaces.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns true if this contract implements the interface defined by `interfaceId`.
     * This function is useful for checking compatibility and interoperability between contracts.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
        return
            interfaceId == type(IERC2981).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    /**
     * @dev Provides royalty information for a specific token ID and sale price.
     * This is useful for ensuring artists and creators receive royalties on secondary sales.
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice) virtual external view returns (address receiver, uint256 royaltyAmount) {
        receiver = _royaltyReceivers[tokenId];
        royaltyAmount = (salePrice * _royaltyAmounts[tokenId]) / 10000;
    }

    /**
     * @dev Sets the royalty information for a specific token ID.
     * This function allows the contract owner to specify the recipient and the royalty percentage.
     */
    function setTokenRoyalty(uint256 tokenId, address receiver, uint256 feeNumerator) external onlyOwner {
        require(feeNumerator <= 10000, "ERC2981: royalty fee will exceed salePrice");
        _royaltyReceivers[tokenId] = receiver;
        _royaltyAmounts[tokenId] = feeNumerator;
    }

    /**
     * @dev Batch transfers multiple tokens from `from` to `to`.
     * This function allows for efficient transfer of multiple tokens in a single transaction.
     */
    function batchTransferFrom(address from, address to, uint256[] calldata tokenIds) external nonReentrant {
        require(to != address(0), "Transfer to the zero address");

        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(_isApprovedOrOwner(_msgSender(), tokenIds[i]), "Transfer caller is not owner nor approved");
            _transfer(from, to, tokenIds[i]);
        }
    }

    /**
     * @dev Sets the base URI for the tokens.
     * This function allows the contract owner to specify a base URI for metadata.
     */
    function setBaseURI(string memory baseURI_) virtual external onlyOwner {
        _baseTokenURI = baseURI_;
        _useBaseURI = true;
        emit BaseURISet(baseURI_);
    }

    event BaseURISet(string baseURI);
}

    contract BtcTradeCat is ERC721 {
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 private _royaltyBps;
    address private _royaltyRecipient;
    string public COLLECTION;
    string public WEBSITE;

    /**
     * @dev Initializes the contract with a name, symbol, maximum supply, royalty basis points, and various addresses.
     * This includes setting up the collection name and website.
     */
    constructor(
        string memory NAME,
        string memory SYMBOL,
        uint256 MAX_BTCTC,
        uint128 ROYALTY_BPS,
        address ADMIN,
        address ROYALTY_RECIPIENT,
        address SALE_RECIPIENT,
        address _proxyRegistryAddress
    ) 
        ERC721("BtcTradeCat", "BTCTC", _proxyRegistryAddress) 
    {
        NAME = "BtcTradeCat";
        SYMBOL = "BTCTC";
        MAX_BTCTC = 10000;
        ROYALTY_BPS = 500;
        ADMIN = 0xA8BdfD635aAc0D6005566865ACEFeA8cF18640d9;
        ROYALTY_RECIPIENT = 0xA8BdfD635aAc0D6005566865ACEFeA8cF18640d9;
        SALE_RECIPIENT = 0xA8BdfD635aAc0D6005566865ACEFeA8cF18640d9;
        COLLECTION = "BTC Trade Cat";
        WEBSITE = "https://btctradecat.org";
        _royaltyRecipient = msg.sender;
    }

    /**
     * @dev Returns the contract metadata including the collection name and website.
     * This provides a way to retrieve detailed information about the contract.
     */
    function getContractMetadata() public view returns (string memory, string memory) {
        return (COLLECTION, WEBSITE);
    }

    /**
     * @dev Mints `quantity` tokens and transfers them to `to`.
     * This function allows the contract owner to mint new tokens up to the maximum supply.
     */
    function mintBTCTC(address to, uint256 quantity) external onlyOwner {
        require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds maximum supply");
        _mint(to, quantity);
    }

    /**
     * @dev Sets the royalty information including the recipient and the basis points.
     * This function allows the contract owner to specify the royalty recipient and percentage.
     */
    function setRoyaltyInfo(address recipient, uint256 bps) public onlyOwner {
        require(bps <= 10000, "BPS must be between 0 and 10000");
        _royaltyRecipient = recipient;
        _royaltyBps = bps;
    }

    /**
     * @dev Returns the royalty information including the recipient and the royalty amount to be paid.
     * This function ensures artists and creators receive royalties on secondary sales.
     */
    function royaltyInfo(uint256 /* tokenId */, uint256 salePrice) external view override returns (address receiver, uint256 royaltyAmount) {
        return (_royaltyRecipient, (salePrice * _royaltyBps) / 10000);
    }
}

    // ProxyRegistry interface and contract for OpenSea compatibility
    interface ProxyRegistry {
    function proxies(address) external view returns (address);
}
