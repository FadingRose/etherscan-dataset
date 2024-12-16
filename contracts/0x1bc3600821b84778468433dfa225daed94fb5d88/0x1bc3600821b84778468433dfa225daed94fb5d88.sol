// SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;


//  @btctradecat.org
//  @x.com/btctradecat   
//  Writing a smart contract is a unique form of art that will live ∞ forever ∞ on the blockchain.   


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
    
    /// @title Interface to check if a contract supports another interface
    interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

    /// @title Interface for ERC2981, the NFT Royalty Standard
    interface IERC2981 {
    function royaltyInfo(uint256 tokenId, uint256 salePrice) external view returns (address receiver, uint256 royaltyAmount);
}

    /// @title Interface for contract metadata
    interface IContractMetadata {
    function getContractMetadata() external view returns (string memory, string memory);
}

    /// @title Implementation of the IERC165 interface
    abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

    /// @title Interface for ERC721, the NFT Standard
    interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

    /// @title Interface for receiving ERC721 tokens
    interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

    /// @title Metadata extension for ERC721
    interface IERC721Metadata is IERC721 {
    function NAME() external view returns (string memory);
    function SYMBOL() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

    /// @title Interface for ERC721 token supply
    interface IERC721Supply is IERC721 {
    function totalSupply() external view returns (uint256);
}

    /// @title Enumerable extension for ERC721
    interface IERC721Enumerable is IERC721 {
    function tokenByIndex(uint256 index) external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
}

    /// @title Library with functions to safely handle addresses
    library Address {
    /// @notice Checks if the address is a contract
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /// @notice Sends value to a payable address
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /// @notice Calls a function on a target address
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /// @notice Calls a function on a target address with custom error message
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /// @notice Calls a function on a target address with value
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /// @notice Calls a function on a target address with value and custom error message
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /// @notice Performs a static call on a target address
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /// @notice Performs a static call on a target address with custom error message
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /// @notice Performs a delegate call on a target address
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /// @notice Performs a delegate call on a target address with custom error message
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /// @notice Verifies the call result and reverts with provided error message if call failed
    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns (bytes memory) {
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

    /// @title Provides information about the current execution context
    abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

    /// @title Contract module which provides a basic access control mechanism, where
    /// there is an account (an owner) that can be granted exclusive access to
    /// specific functions.
    abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(_msgSender());
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
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

    /// @title Library for managing counters
    library Counters {
    struct Counter {
        uint256 _value;
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

    /// @title Contract module to track total supply of tokens
    abstract contract Supply {
    uint256 private _totalSupply;

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function _increaseTotalSupply(uint256 amount) internal {
        _totalSupply += amount;
    }

    function _decreaseTotalSupply(uint256 amount) internal {
        require(_totalSupply >= amount, "Supply: decrease amount exceeds total supply");
        _totalSupply -= amount;
    }
}

    /// @title Implementation of the ERC721 Non-Fungible Token Standard
    abstract contract ERC721 is Context, ERC165, IERC721 {
    using Address for address;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdTracker;

    string private Name;
    string private Symbol;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(string memory name_, string memory symbol_) {
        Name = name_;
        Symbol = symbol_;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC721).interfaceId || super.supportsInterface(interfaceId);
    }

    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    function name() public view virtual returns (string memory) {
        return Name;
    }

    function symbol() public view virtual returns (string memory) {
        return Symbol;
    }

    /// @notice Returns the URI for a given token ID
    function tokenURI(uint256 tokenId) public view virtual returns (string memory);

    /// @notice Approves another address to transfer the given token ID
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "ERC721: approve caller is not owner nor approved for all");

        _approve(to, tokenId);
    }

    /// @notice Returns the account approved for a given token ID
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /// @notice Sets or unsets the approval of a given operator
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /// @notice Tells whether an operator is approved by a given owner
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /// @notice Transfers a token from one address to another
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /// @notice Transfers a token from one address to another with additional data
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /// @notice Transfers a token from one address to another
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /// @notice Safely transfers a token from one address to another
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /// @notice Returns whether the given token ID exists
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /// @notice Returns whether the given spender can transfer a given token ID
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /// @notice Safely mints a token and transfers it to the given address
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /// @notice Safely mints a token and transfers it to the given address with additional data
    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /// @notice Mints a token and transfers it to the given address
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Burns a token
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /// @notice Transfers a token from one address to another
    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /// @notice Approves another address to transfer the given token ID
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /// @notice Checks if the address can receive ERC721 tokens
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
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

    /// @notice Hook that is called before any token transfer
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
}

    /// @title Library for string operations
    library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

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

    /// @title Implementation of ERC721 with storage-based token URI management
    abstract contract ERC721URIStorage is ERC721 {
    using Strings for uint256;

    mapping(uint256 => string) private _tokenURIs;

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        if (bytes(base).length == 0) {
            return _tokenURI;
        }

        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }

    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
}

    /// @title Implementation of ERC721 with burnable tokens
    abstract contract ERC721Burnable is Context, ERC721 {
    function burn(uint256 tokenId) public virtual {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
        _burn(tokenId);
    }
}

    /// @title Implementation of ERC721 with enumerable extension
    abstract contract ERC721Enumerable is ERC721 {
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;
    uint256[] private _allTokens;
    mapping(uint256 => uint256) private _allTokensIndex;

    function totalSupply() public view virtual returns (uint256) {
        return _allTokens.length;
    }

    function tokenByIndex(uint256 index) public view virtual returns (uint256) {
        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256) {
        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }

    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        uint256 lastTokenIndex = balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = tokenIndex;
        }

        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId;
        _allTokensIndex[lastTokenId] = tokenIndex;

        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }
}

    /// @title Interface for mintable ERC721 tokens
    interface IMintableERC721 {
    function mintTo(address to, string calldata uri) external returns (uint256);
}

    /// @title Contract module that helps prevent reentrant calls to a function
    abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

    /// @title The main ERC721 contract with additional functionalities
    contract BtcTardeCat is ERC721, IMintableERC721, IERC721Supply, 
    IERC721Enumerable, ERC721URIStorage, ERC721Burnable, 
    ERC721Enumerable, Ownable, IERC2981, Supply, 
    IContractMetadata, ReentrancyGuard, IERC721Receiver {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 public constant MAX_BTCTC = 10000;
    string private _contractURI;
    uint256 private _royaltyBps;
    address private _royaltyRecipient;
    string public COLLECTION;
    string public DESCRIPTION;
    string public WEBSITE;
    string private _baseTokenURI;

    uint256[] private _allTokens;
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
    mapping(uint256 => uint256) private _ownedTokensIndex;
    mapping(uint256 => uint256) private _allTokensIndex;

    constructor(
        string memory NAME,
        string memory SYMBOL,
        uint256 MAX_BTCTC,
        uint128 ROYALTY_BPS,
        address ADMIN,
        address ROYALTY_RECIPIENT,
        address SALE_RECIPIENT
    )
        ERC721("BtcTradeCat", "BTCTC")
    {
        NAME = "BtcTradeCat";
        SYMBOL = "BTCTC";
        MAX_BTCTC = 10000;
        ROYALTY_BPS = 500;
        ADMIN = 0xb7bb42903a13D63B87D376393EE521D9a43e83F4;
        ROYALTY_RECIPIENT = 0xb7bb42903a13D63B87D376393EE521D9a43e83F4;
        SALE_RECIPIENT = 0xb7bb42903a13D63B87D376393EE521D9a43e83F4;
        COLLECTION = "BTC Trade Cat";
        WEBSITE = "https://btctradecat.org";
        _royaltyRecipient = msg.sender;
    }

    event BaseURISet(string baseURI);

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseTokenURI = baseURI_;
        emit BaseURISet(baseURI_);
    }

    function mintTo(address to, string calldata /*uri*/) external override nonReentrant returns (uint256) {
        require(_tokenIdCounter.current() < MAX_BTCTC, "Max supply reached");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _increaseTotalSupply(1);
        return tokenId;
    }

    function contractURI() public view returns (string memory) {
        return _contractURI;
    }

    function setRoyaltyInfo(address recipient, uint256 bps) public onlyOwner {
        require(bps <= 10000, "BPS must be between 0 and 10000");
        _royaltyRecipient = recipient;
        _royaltyBps = bps;
    }

    function royaltyInfo(uint256 /* tokenId */, uint256 salePrice) external view override returns (address receiver, uint256 royaltyAmount) {
        return (_royaltyRecipient, (salePrice * _royaltyBps) / 10000);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }

    function totalSupply() public view virtual override(IERC721Supply, Supply, ERC721Enumerable) returns (uint256) {
        return super.totalSupply();
    }

    function tokenByIndex(uint256 _index) public view override(IERC721Enumerable, ERC721Enumerable) returns (uint256) {
        require(_index < totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[_index];
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) public view override(IERC721Enumerable, ERC721Enumerable) returns (uint256) {
        require(_index < balanceOf(_owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[_owner][_index];
    }

    function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
        _decreaseTotalSupply(1);
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function getContractMetadata() public view override returns (string memory, string memory) {
        return (COLLECTION, WEBSITE);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function onERC721Received(address /*operator*/, address /*from*/, uint256 /*tokenId*/, bytes calldata /*data*/) pure external override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
