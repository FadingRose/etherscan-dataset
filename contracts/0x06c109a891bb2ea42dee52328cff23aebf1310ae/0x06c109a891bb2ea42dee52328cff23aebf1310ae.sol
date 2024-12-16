// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

interface IERC1155 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function uri(uint256 tokenId) external view returns (string memory);
}

contract BulkQuery {
    bytes4 private constant INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    bytes4 private constant INTERFACE_ID_ERC1155 = 0xd9b67a26;
    bytes4 private constant INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
    address private constant NULL_ADDRESS = address(0);

    function bulkQuery(address[] calldata contractAddresses, uint256[] calldata tokenIds) external view returns (string[] memory) {
        require(contractAddresses.length == tokenIds.length, "Arrays must have the same length");
        require(contractAddresses.length > 0, "Input arrays cannot be empty");

        string[] memory uris = new string[](contractAddresses.length);

        for (uint256 i = 0; i < contractAddresses.length; i++) {
            bool supportsERC721 = false;
            bool supportsERC721Metadata = false;
            bool supportsERC1155 = false;
            bool supportsERC1155MetadataURI = false;

            try IERC721(contractAddresses[i]).supportsInterface(INTERFACE_ID_ERC721) returns (bool result) {
                supportsERC721 = result;
            } catch {
                supportsERC721 = false;
            }

            try IERC721(contractAddresses[i]).supportsInterface(INTERFACE_ID_ERC721_METADATA) returns (bool result) {
                supportsERC721Metadata = result;
            } catch {
                supportsERC721Metadata = false;
            }

            try IERC1155(contractAddresses[i]).supportsInterface(INTERFACE_ID_ERC1155) returns (bool result) {
                supportsERC1155 = result;
            } catch {
                supportsERC1155 = false;
            }

            try IERC1155(contractAddresses[i]).supportsInterface(INTERFACE_ID_ERC1155_METADATA_URI) returns (bool result) {
                supportsERC1155MetadataURI = result;
            } catch {
                supportsERC1155MetadataURI = false;
            }

            if (supportsERC1155 && supportsERC1155MetadataURI) {
                try IERC1155(contractAddresses[i]).uri(tokenIds[i]) returns (string memory uri) {
                    uris[i] = uri;
                } catch {
                    uris[i] = "";
                }
            } else if (supportsERC721 && supportsERC721Metadata) {
                try IERC721(contractAddresses[i]).tokenURI(tokenIds[i]) returns (string memory uri) {
                    uris[i] = uri;
                } catch {
                    uris[i] = "";
                }
            } else {
                uris[i] = "";
            }
        }

        return uris;
    }
}
