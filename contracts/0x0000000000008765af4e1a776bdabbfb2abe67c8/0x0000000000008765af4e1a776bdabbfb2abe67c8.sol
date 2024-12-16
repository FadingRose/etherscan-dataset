{{
  "language": "Solidity",
  "sources": {
    "src/ZwapUSDC.sol": {
      "content": "// SPDX-License-Identifier: AGPL-3.0-only\npragma solidity 0.8.26;\n\n/// @notice Swap ETH to USDC and make payments.\ncontract ZwapUSDC {\n    address constant POOL = 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640;\n    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;\n    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n    uint160 constant MAX_SQRT_RATIO_MINUS_ONE = 1461446703485210103287273052203988822378723970341;\n\n    constructor() payable {}\n\n    receive() external payable {\n        zwap(msg.sender, int256(msg.value));\n    }\n\n    function zwap(address to, int256 amount) public payable {\n        assembly (\"memory-safe\") {\n            if iszero(amount) { amount := callvalue() }\n        }\n        (int256 amount0,) = ISwap(POOL).swap(to, false, amount, MAX_SQRT_RATIO_MINUS_ONE, \"\");\n        if (amount > 0) {\n            assembly (\"memory-safe\") {\n                if lt(sub(0, amount0), mod(amount, 10000000000)) { revert(codesize(), codesize()) }\n            }\n        } else {\n            assembly (\"memory-safe\") {\n                if selfbalance() {\n                    pop(call(gas(), caller(), selfbalance(), codesize(), 0x00, codesize(), 0x00))\n                }\n            }\n        }\n    }\n\n    fallback() external payable {\n        assembly (\"memory-safe\") {\n            let amount1Delta := calldataload(0x24)\n            pop(call(gas(), WETH, amount1Delta, codesize(), 0x00, codesize(), 0x00))\n            mstore(0x00, 0xa9059cbb000000000000000000000000)\n            mstore(0x14, POOL)\n            mstore(0x34, amount1Delta)\n            pop(call(gas(), WETH, 0, 0x10, 0x44, codesize(), 0x00))\n        }\n    }\n\n    struct Zwap {\n        address to;\n        uint256 amount;\n    }\n\n    function zwap(Zwap[] calldata zwaps, uint256 sum) public payable {\n        zwap(address(this), -int256(sum));\n        for (uint256 i; i != zwaps.length; ++i) {\n            _transfer(zwaps[i].to, zwaps[i].amount);\n        }\n        if ((sum = _balanceOfThis()) != 0) _transfer(msg.sender, sum);\n    }\n\n    function _transfer(address to, uint256 amount) internal {\n        assembly (\"memory-safe\") {\n            mstore(0x00, 0xa9059cbb000000000000000000000000)\n            mstore(0x14, to)\n            mstore(0x34, amount)\n            pop(call(gas(), USDC, 0, 0x10, 0x44, codesize(), 0x00))\n        }\n    }\n\n    function _balanceOfThis() internal view returns (uint256 amount) {\n        assembly (\"memory-safe\") {\n            mstore(0x00, 0x70a08231000000000000000000000000)\n            mstore(0x14, address())\n            pop(staticcall(gas(), USDC, 0x10, 0x24, 0x20, 0x20))\n            amount := mload(0x20)\n        }\n    }\n}\n\n/// @dev Minimal Uniswap V3 swap interface.\ninterface ISwap {\n    function swap(address, bool, int256, uint160, bytes calldata)\n        external\n        returns (int256, int256);\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "@solady/=lib/solady/",
      "@forge/=lib/forge-std/src/",
      "forge-std/=lib/forge-std/src/",
      "solady/=lib/solady/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 9999999
    },
    "metadata": {
      "useLiteralContent": false,
      "bytecodeHash": "ipfs",
      "appendCBOR": true
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    },
    "evmVersion": "cancun",
    "viaIR": false,
    "libraries": {}
  }
}}
