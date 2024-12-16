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
    "@openzeppelin/contracts/token/ERC20/IERC20.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)\n\npragma solidity ^0.8.0;\n\n/**\n * @dev Interface of the ERC20 standard as defined in the EIP.\n */\ninterface IERC20 {\n    /**\n     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n     * another (`to`).\n     *\n     * Note that `value` may be zero.\n     */\n    event Transfer(address indexed from, address indexed to, uint256 value);\n\n    /**\n     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n     * a call to {approve}. `value` is the new allowance.\n     */\n    event Approval(address indexed owner, address indexed spender, uint256 value);\n\n    /**\n     * @dev Returns the amount of tokens in existence.\n     */\n    function totalSupply() external view returns (uint256);\n\n    /**\n     * @dev Returns the amount of tokens owned by `account`.\n     */\n    function balanceOf(address account) external view returns (uint256);\n\n    /**\n     * @dev Moves `amount` tokens from the caller's account to `to`.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transfer(address to, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Returns the remaining number of tokens that `spender` will be\n     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n     * zero by default.\n     *\n     * This value changes when {approve} or {transferFrom} are called.\n     */\n    function allowance(address owner, address spender) external view returns (uint256);\n\n    /**\n     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n     * that someone may use both the old and the new allowance by unfortunate\n     * transaction ordering. One possible solution to mitigate this race\n     * condition is to first reduce the spender's allowance to 0 and set the\n     * desired value afterwards:\n     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n     *\n     * Emits an {Approval} event.\n     */\n    function approve(address spender, uint256 amount) external returns (bool);\n\n    /**\n     * @dev Moves `amount` tokens from `from` to `to` using the\n     * allowance mechanism. `amount` is then deducted from the caller's\n     * allowance.\n     *\n     * Returns a boolean value indicating whether the operation succeeded.\n     *\n     * Emits a {Transfer} event.\n     */\n    function transferFrom(address from, address to, uint256 amount) external returns (bool);\n}\n"
    },
    "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)\n\npragma solidity ^0.8.0;\n\nimport \"../IERC20.sol\";\n\n/**\n * @dev Interface for the optional metadata functions from the ERC20 standard.\n *\n * _Available since v4.1._\n */\ninterface IERC20Metadata is IERC20 {\n    /**\n     * @dev Returns the name of the token.\n     */\n    function name() external view returns (string memory);\n\n    /**\n     * @dev Returns the symbol of the token.\n     */\n    function symbol() external view returns (string memory);\n\n    /**\n     * @dev Returns the decimals places of the token.\n     */\n    function decimals() external view returns (uint8);\n}\n"
    },
    "contracts/interfaces/IStETH.sol": {
      "content": "// SPDX-License-Identifier: BSD-3-Clause\npragma solidity ^0.8.25;\n\ninterface IStETH {\n    function getPooledEthByShares(uint256 _sharesAmount) external view returns (uint256);\n    function decimals() external view returns (uint8);\n}\n"
    },
    "contracts/interfaces/OracleInterface.sol": {
      "content": "// SPDX-License-Identifier: BSD-3-Clause\npragma solidity ^0.8.25;\n\ninterface OracleInterface {\n    function getPrice(address asset) external view returns (uint256);\n}\n\ninterface ResilientOracleInterface is OracleInterface {\n    function updatePrice(address vToken) external;\n\n    function updateAssetPrice(address asset) external;\n\n    function getUnderlyingPrice(address vToken) external view returns (uint256);\n}\n\ninterface TwapInterface is OracleInterface {\n    function updateTwap(address asset) external returns (uint256);\n}\n\ninterface BoundValidatorInterface {\n    function validatePriceWithAnchorPrice(\n        address asset,\n        uint256 reporterPrice,\n        uint256 anchorPrice\n    ) external view returns (bool);\n}\n"
    },
    "contracts/oracles/WstETHOracle.sol": {
      "content": "// SPDX-License-Identifier: BSD-3-Clause\npragma solidity 0.8.25;\n\nimport { IStETH } from \"../interfaces/IStETH.sol\";\nimport { CorrelatedTokenOracle } from \"./common/CorrelatedTokenOracle.sol\";\nimport { EXP_SCALE } from \"../utilities/constants.sol\";\n\n/**\n * @title WstETHOracle renamed from WstETHOracleV2 in venus\n * @author Venus\n * @notice This oracle fetches the price of wstETH\n */\ncontract WstETHOracle is CorrelatedTokenOracle {\n    /// @notice Constructor for the implementation contract.\n    /// @custom:oz-upgrades-unsafe-allow constructor\n    constructor(address stETH, address resilientOracle) CorrelatedTokenOracle(stETH, resilientOracle) {}\n\n    /**\n     * @notice Gets the stETH for 1 wstETH\n     * @return amount Amount of stETH\n     */\n    function _getUnderlyingAmount(address corelatedToken) internal view override returns (uint256) {\n        return IStETH(UNDERLYING_TOKEN).getPooledEthByShares(EXP_SCALE);\n    }\n}\n"
    },
    "contracts/oracles/common/CorrelatedTokenOracle.sol": {
      "content": "// SPDX-License-Identifier: BSD-3-Clause\npragma solidity 0.8.25;\n\nimport { OracleInterface } from \"../../interfaces/OracleInterface.sol\";\nimport { ensureNonzeroAddress } from \"../../utilities/validators.sol\";\nimport { IERC20Metadata } from \"@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol\";\nimport { EXP_SCALE } from \"../../utilities/constants.sol\";\n/**\n * @title CorrelatedTokenOracle\n * @notice This oracle fetches the price of a token that is correlated to another token.\n */\nabstract contract CorrelatedTokenOracle is OracleInterface {\n    /// @notice Address of the underlying token\n    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable\n    address public immutable UNDERLYING_TOKEN;\n\n    /// @notice Address of Resilient Oracle\n    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable\n    OracleInterface public immutable RESILIENT_ORACLE;\n\n    /// @notice Thrown if the token address is invalid\n    error InvalidTokenAddress();\n\n    /// @notice Constructor for the implementation contract.\n    /// @custom:oz-upgrades-unsafe-allow constructor\n    constructor(address underlyingToken, address resilientOracle) {\n        ensureNonzeroAddress(underlyingToken);\n        ensureNonzeroAddress(resilientOracle);\n        UNDERLYING_TOKEN = underlyingToken;\n        RESILIENT_ORACLE = OracleInterface(resilientOracle);\n    }\n\n    /**\n     * @notice Fetches the price of the correlated token\n     * @param correlatedToken Address of the correlated token\n     * @return price The price of the correlated token in scaled decimal places\n     */\n    function getPrice(address correlatedToken) external view override returns (uint256) {\n        // get underlying token amount for 1 correlated token scaled by underlying token decimals\n        uint256 underlyingAmount = _getUnderlyingAmount(correlatedToken);\n\n        // oracle returns (36 - asset decimal) scaled price\n        uint256 underlyingUSDPrice = RESILIENT_ORACLE.getPrice(UNDERLYING_TOKEN);\n\n        // IERC20Metadata token = IERC20Metadata(CORRELATED_TOKEN);\n        // uint256 decimals = token.decimals();\n\n        // underlyingAmount (for 1 correlated token) * underlyingUSDPrice / decimals(correlated token)\n        return (underlyingAmount * underlyingUSDPrice) / EXP_SCALE;\n    }\n\n    /**\n     * @notice Gets the underlying amount for correlated token\n     * @return underlyingAmount Amount of underlying token\n     */\n    function _getUnderlyingAmount(address asset) internal view virtual returns (uint256);\n}\n"
    },
    "contracts/utilities/constants.sol": {
      "content": "// SPDX-License-Identifier: BSD-3-Clause\npragma solidity ^0.8.25;\n\n/// @dev Base unit for computations, usually used in scaling (multiplications, divisions)\nuint256 constant EXP_SCALE = 1e18;\n\n/// @dev A unit (literal one) in EXP_SCALE, usually used in additions/subtractions\nuint256 constant MANTISSA_ONE = EXP_SCALE;\n\n/// @dev The approximate number of seconds per year\nuint256 constant SECONDS_PER_YEAR = 31_536_000;\n"
    },
    "contracts/utilities/validators.sol": {
      "content": "// SPDX-License-Identifier: BSD-3-Clause\npragma solidity 0.8.25;\n\n/// @notice Thrown if the supplied address is a zero address where it is not allowed\nerror ZeroAddressNotAllowed();\n\n/// @notice Thrown if the supplied value is 0 where it is not allowed\nerror ZeroValueNotAllowed();\n\n/// @notice Checks if the provided address is nonzero, reverts otherwise\n/// @param address_ Address to check\n/// @custom:error ZeroAddressNotAllowed is thrown if the provided address is a zero address\nfunction ensureNonzeroAddress(address address_) pure {\n    if (address_ == address(0)) {\n        revert ZeroAddressNotAllowed();\n    }\n}\n\n/// @notice Checks if the provided value is nonzero, reverts otherwise\n/// @param value_ Value to check\n/// @custom:error ZeroValueNotAllowed is thrown if the provided value is 0\nfunction ensureNonzeroValue(uint256 value_) pure {\n    if (value_ == 0) {\n        revert ZeroValueNotAllowed();\n    }\n}\n"
    }
  }
}}
