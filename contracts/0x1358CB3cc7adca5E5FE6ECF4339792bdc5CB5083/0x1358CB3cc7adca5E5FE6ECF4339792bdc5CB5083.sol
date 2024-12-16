{{
  "language": "Solidity",
  "sources": {
    "contracts/usdc_deposit.sol": {
      "content": "// SPDX-License-Identifier: MIT\npragma solidity ^0.8.0;\n\ninterface IERC20 {\n    function totalSupply() external view returns (uint256);\n    function balanceOf(address account) external view returns (uint256);\n    function transfer(address recipient, uint256 amount) external returns (bool);\n    function allowance(address owner, address spender) external view returns (uint256);\n    function approve(address spender, uint256 amount) external returns (bool);\n    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n}\n\ncontract AlexUSDCWallet {\n    address public owner;\n    IERC20 public usdcToken;\n\n    event Deposit(address indexed from, uint256 amount);\n    event Withdrawal(address indexed to, uint256 amount);\n    event WithdrawalAll(address indexed to, uint256 amount);\n\n    constructor() {\n        owner = msg.sender;\n        usdcToken = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);\n    }\n\n    modifier onlyOwner() {\n        require(msg.sender == owner, \"Not the contract owner\");\n        _;\n    }\n\n    function deposit(uint256 amount) external {\n        require(usdcToken.transferFrom(msg.sender, address(this), amount), \"Transfer failed\");\n        emit Deposit(msg.sender, amount);\n    }\n\n    function withdraw(uint256 amount) external onlyOwner {\n        require(usdcToken.balanceOf(address(this)) >= amount, \"Insufficient balance\");\n        require(usdcToken.transfer(owner, amount), \"Transfer failed\");\n        emit Withdrawal(owner, amount);\n    }\n\n    function withdrawAll() external onlyOwner {\n        uint256 balance = usdcToken.balanceOf(address(this));\n        require(balance > 0, \"No balance to withdraw\");\n        require(usdcToken.transfer(owner, balance), \"Transfer failed\");\n        emit WithdrawalAll(owner, balance);\n    }\n\n    function getBalance() external view returns (uint256) {\n        return usdcToken.balanceOf(address(this));\n    }\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
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
  }
}}
