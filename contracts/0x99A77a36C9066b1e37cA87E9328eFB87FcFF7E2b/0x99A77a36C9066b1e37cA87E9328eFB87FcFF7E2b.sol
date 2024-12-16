{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "paris",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": false,
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
    "contracts/IRateProvider.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\ninterface IRateProvider {\n    function getRate() external view returns (uint256);\n}"
    },
    "contracts/ISolvBTCYieldToken.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\ninterface ISolvBTCYieldToken {\n\tfunction getValueByShares(uint256 shares) external view returns (uint256 value);\n\tfunction decimals() external view returns (uint8);\n}"
    },
    "contracts/SolvBTCYieldTokenBalancerRateProvider.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\nimport \"./IRateProvider.sol\";\nimport \"./ISolvBTCYieldToken.sol\";\n\ncontract SolvBTCYieldTokenBalancerRateProvider is IRateProvider {\n\taddress public immutable solvBTCYieldToken;\n\n\tconstructor(address _solvBTCYieldToken) {\n\t\tsolvBTCYieldToken = _solvBTCYieldToken;\n\t}\n\n \t/// @notice The SolvBTC.xxx exchange rate in the form of how much SolvBTC 1 SolvBTC.xxx is worth\n\tfunction getRate() external view returns (uint256) {\n\t\tuint8 decimals = ISolvBTCYieldToken(solvBTCYieldToken).decimals();\n\t\treturn ISolvBTCYieldToken(solvBTCYieldToken).getValueByShares(10**decimals);\n\t}\n}"
    }
  }
}}
