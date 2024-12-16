{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "london",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "remappings": [],
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    }
  },
  "sources": {
    "contracts/auction-pricing/ConstantPriceAdapter.sol": {
      "content": "// SPDX-License-Identifier: Apache-2.0\npragma solidity 0.8.17;\n\n/**\n * @title ConstantPriceAdapter\n * @author Index Coop\n * @notice Price adapter contract for AuctionRebalanceModuleV1 that returns a constant price.\n * The rate of change is zero.\n * Price formula: price = initialPrice\n */\ncontract ConstantPriceAdapter {\n    /**\n     * @dev Calculates and returns the constant price.\n     *\n     * @param _priceAdapterConfigData   Encoded bytes representing the constant price.\n     *\n     * @return price                    The constant price decoded from _priceAdapterConfigData.\n     */\n    function getPrice(\n        address /* _setToken */,\n        address /* _component */,\n        uint256 /* _componentQuantity */,\n        uint256 /* _timeElapsed */,\n        uint256 /* _duration */,\n        bytes memory _priceAdapterConfigData\n    )\n        external\n        pure\n        returns (uint256 price)\n    {\n        price = getDecodedData(_priceAdapterConfigData);\n        require(price > 0, \"ConstantPriceAdapter: Price must be greater than 0\");\n    }\n\n    /**\n     * @notice Returns true if the price adapter configuration data is valid.\n     *\n     * @param _priceAdapterConfigData   Encoded bytes representing the constant price.\n     *\n     * @return isValid                  True if the constant price is greater than 0, False otherwise.\n     */\n    function isPriceAdapterConfigDataValid(\n        bytes memory _priceAdapterConfigData\n    )\n        external\n        pure\n        returns (bool isValid)\n    {\n        uint256 price = getDecodedData(_priceAdapterConfigData);\n        isValid = price > 0;\n    }\n\n    /**\n     * @notice Encodes the constant price into bytes.\n     *\n     * @param _price  The constant price in base units.\n     *\n     * @return        Encoded bytes representing the constant price.\n     */\n    function getEncodedData(uint256 _price) external pure returns (bytes memory) {\n        return abi.encode(_price);\n    }\n\n    /**\n     * @dev Decodes the constant price from the provided bytes.\n     *\n     * @param _data  Encoded bytes representing the constant price.\n     *\n     * @return       The constant price decoded from bytes in base units.\n     */\n    function getDecodedData(bytes memory _data) public pure returns (uint256) {\n        return abi.decode(_data, (uint256));\n    }\n}\n"
    }
  }
}}
