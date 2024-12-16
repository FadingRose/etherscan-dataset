// SPDX-License-Identifier: MIT
pragma solidity =0.8.24;









contract DSMath {
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x + y;
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x - y;
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x * y;
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x / y;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x <= y ? x : y;
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x >= y ? x : y;
    }

    function imin(int256 x, int256 y) internal pure returns (int256 z) {
        return x <= y ? x : y;
    }

    function imax(int256 x, int256 y) internal pure returns (int256 z) {
        return x >= y ? x : y;
    }

    uint256 constant WAD = 10**18;
    uint256 constant RAY = 10**27;

    function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }

    function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }

    function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    // This famous algorithm is called "exponentiation by squaring"
    // and calculates x^n with x as fixed-point and n as regular unsigned.
    //
    // It's O(log n), instead of O(n) for naive repeated multiplication.
    //
    // These facts are why it works:
    //
    //  If n is even, then x^n = (x^2)^(n/2).
    //  If n is odd,  then x^n = x * x^(n-1),
    //   and applying the equation for even x gives
    //    x^n = x * (x^2)^((n-1) / 2).
    //
    //  Also, EVM division is flooring and
    //    floor[(n-1) / 2] = floor[n / 2].
    //
    function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}







contract MainnetAuthAddresses {
    address internal constant ADMIN_VAULT_ADDR = 0xCCf3d848e08b94478Ed8f46fFead3008faF581fD;
    address internal constant DSGUARD_FACTORY_ADDRESS = 0x5a15566417e6C1c9546523066500bDDBc53F88C7;
    address internal constant ADMIN_ADDR = 0x25eFA336886C74eA8E282ac466BdCd0199f85BB9; // USED IN ADMIN VAULT CONSTRUCTOR
    address internal constant PROXY_AUTH_ADDRESS = 0x149667b6FAe2c63D1B4317C716b0D0e4d3E2bD70;
    address internal constant MODULE_AUTH_ADDRESS = 0x7407974DDBF539e552F1d051e44573090912CC3D;
}







contract AuthHelper is MainnetAuthAddresses {
}








contract AdminVault is AuthHelper {
    address public owner;
    address public admin;

    error SenderNotAdmin();

    constructor() {
        owner = msg.sender;
        admin = ADMIN_ADDR;
    }

    /// @notice Admin is able to change owner
    /// @param _owner Address of new owner
    function changeOwner(address _owner) public {
        if (admin != msg.sender){
            revert SenderNotAdmin();
        }
        owner = _owner;
    }

    /// @notice Admin is able to set new admin
    /// @param _admin Address of multisig that becomes new admin
    function changeAdmin(address _admin) public {
        if (admin != msg.sender){
            revert SenderNotAdmin();
        }
        admin = _admin;
    }

}







interface IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint256 digits);
    function totalSupply() external view returns (uint256 supply);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}







library Address {
    //insufficient balance
    error InsufficientBalance(uint256 available, uint256 required);
    //unable to send value, recipient may have reverted
    error SendingValueFail();
    //insufficient balance for call
    error InsufficientBalanceForCall(uint256 available, uint256 required);
    //call to non-contract
    error NonContractCall();
    
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        uint256 balance = address(this).balance;
        if (balance < amount){
            revert InsufficientBalance(balance, amount);
        }

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        if (!(success)){
            revert SendingValueFail();
        }
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        uint256 balance = address(this).balance;
        if (balance < value){
            revert InsufficientBalanceForCall(balance, value);
        }
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        if (!(isContract(target))){
            revert NonContractCall();
        }

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
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











library SafeERC20 {
    using Address for address;

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Compatible with tokens that require the approval to be set to
     * 0 before setting it to a non-zero value.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
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

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
     */
    function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
        // and not revert is the subcall reverts.

        (bool success, bytes memory returndata) = address(token).call(data);
        return success && (returndata.length == 0 || abi.decode(returndata, (bool))) && address(token).code.length > 0;
    }
}











contract AdminAuth is AuthHelper {
    using SafeERC20 for IERC20;

    AdminVault public constant adminVault = AdminVault(ADMIN_VAULT_ADDR);

    error SenderNotOwner();
    error SenderNotAdmin();

    modifier onlyOwner() {
        if (adminVault.owner() != msg.sender){
            revert SenderNotOwner();
        }
        _;
    }

    modifier onlyAdmin() {
        if (adminVault.admin() != msg.sender){
            revert SenderNotAdmin();
        }
        _;
    }

    /// @notice withdraw stuck funds
    function withdrawStuckFunds(address _token, address _receiver, uint256 _amount) public onlyOwner {
        if (_token == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
            payable(_receiver).transfer(_amount);
        } else {
            IERC20(_token).safeTransfer(_receiver, _amount);
        }
    }

    /// @notice Destroy the contract
    /// @dev Deprecated method, selfdestruct will soon just send eth
    function kill() public onlyAdmin {
        selfdestruct(payable(msg.sender));
    }
}








contract FeeRecipient is AdminAuth {

    address public wallet;

    constructor(address _newWallet) {
        wallet = _newWallet;
    }

    function getFeeAddr() public view returns (address) {
        return wallet;
    }

    function changeWalletAddr(address _newWallet) public onlyOwner {
        wallet = _newWallet;
    }
}







interface ILendingPoolAddressesProviderV2 {
  event LendingPoolUpdated(address indexed newAddress);
  event ConfigurationAdminUpdated(address indexed newAddress);
  event EmergencyAdminUpdated(address indexed newAddress);
  event LendingPoolConfiguratorUpdated(address indexed newAddress);
  event LendingPoolCollateralManagerUpdated(address indexed newAddress);
  event PriceOracleUpdated(address indexed newAddress);
  event LendingRateOracleUpdated(address indexed newAddress);
  event ProxyCreated(bytes32 id, address indexed newAddress);
  event AddressSet(bytes32 id, address indexed newAddress, bool hasProxy);

  function setAddress(bytes32 id, address newAddress) external;

  function setAddressAsProxy(bytes32 id, address impl) external;

  function getAddress(bytes32 id) external view returns (address);

  function getLendingPool() external view returns (address);

  function setLendingPoolImpl(address pool) external;

  function getLendingPoolConfigurator() external view returns (address);

  function setLendingPoolConfiguratorImpl(address configurator) external;

  function getLendingPoolCollateralManager() external view returns (address);

  function setLendingPoolCollateralManager(address manager) external;

  function getPoolAdmin() external view returns (address);

  function setPoolAdmin(address admin) external;

  function getEmergencyAdmin() external view returns (address);

  function setEmergencyAdmin(address admin) external;

  function getPriceOracle() external view returns (address);

  function setPriceOracle(address priceOracle) external;

  function getLendingRateOracle() external view returns (address);

  function setLendingRateOracle(address lendingRateOracle) external;
}







abstract contract IPriceOracleGetterAave {
    function getAssetPrice(address _asset) external virtual view returns (uint256);
    function getAssetsPrices(address[] calldata _assets) external virtual view returns(uint256[] memory);
    function getSourceOfAsset(address _asset) external virtual view returns(address);
    function getFallbackOracle() external virtual view returns(address);
}






interface IAggregatorV3 {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    // getRoundData and latestRoundData should both raise "No data present"
    // if they do not have data to report, instead of returning unset values
    // which could be misinterpreted as actual reported values.
    function getRoundData(uint80 _roundId)
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestAnswer() external view returns (uint256);

    function getTimestamp(uint256 _roundId) external view returns (uint256);

    function phaseId() external view returns (uint16);

    function phaseAggregators(uint16 _phaseId) external view returns (address);
}






interface IFeedRegistry {
  struct Phase {
    uint16 phaseId;
    uint80 startingAggregatorRoundId;
    uint80 endingAggregatorRoundId;
  }

  event FeedProposed(
    address indexed asset,
    address indexed denomination,
    address indexed proposedAggregator,
    address currentAggregator,
    address sender
  );
  event FeedConfirmed(
    address indexed asset,
    address indexed denomination,
    address indexed latestAggregator,
    address previousAggregator,
    uint16 nextPhaseId,
    address sender
  );

  // V3 AggregatorV3Interface

  function decimals(
    address base,
    address quote
  )
    external
    view
    returns (
      uint8
    );

  function description(
    address base,
    address quote
  )
    external
    view
    returns (
      string memory
    );

  function version(
    address base,
    address quote
  )
    external
    view
    returns (
      uint256
    );

  function latestRoundData(
    address base,
    address quote
  )
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function getRoundData(
    address base,
    address quote,
    uint80 _roundId
  )
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  // V2 AggregatorInterface

  function latestAnswer(
    address base,
    address quote
  )
    external
    view
    returns (
      int256 answer
    );

  function latestTimestamp(
    address base,
    address quote
  )
    external
    view
    returns (
      uint256 timestamp
    );

  function latestRound(
    address base,
    address quote
  )
    external
    view
    returns (
      uint256 roundId
    );

  function getAnswer(
    address base,
    address quote,
    uint256 roundId
  )
    external
    view
    returns (
      int256 answer
    );

  function getTimestamp(
    address base,
    address quote,
    uint256 roundId
  )
    external
    view
    returns (
      uint256 timestamp
    );


  function isFeedEnabled(
    address aggregator
  )
    external
    view
    returns (
      bool
    );

  function getPhase(
    address base,
    address quote,
    uint16 phaseId
  )
    external
    view
    returns (
      Phase memory phase
    );

  // Round helpers


  function getPhaseRange(
    address base,
    address quote,
    uint16 phaseId
  )
    external
    view
    returns (
      uint80 startingRoundId,
      uint80 endingRoundId
    );

  function getPreviousRoundId(
    address base,
    address quote,
    uint80 roundId
  ) external
    view
    returns (
      uint80 previousRoundId
    );

  function getNextRoundId(
    address base,
    address quote,
    uint80 roundId
  ) external
    view
    returns (
      uint80 nextRoundId
    );

  // Feed management

  function proposeFeed(
    address base,
    address quote,
    address aggregator
  ) external;

  function confirmFeed(
    address base,
    address quote,
    address aggregator
  ) external;

  // Proposed aggregator

  function proposedGetRoundData(
    address base,
    address quote,
    uint80 roundId
  )
    external
    view
    returns (
      uint80 id,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function proposedLatestRoundData(
    address base,
    address quote
  )
    external
    view
    returns (
      uint80 id,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  // Phases
  function getCurrentPhaseId(
    address base,
    address quote
  )
    external
    view
    returns (
      uint16 currentPhaseId
    );

    function getFeed(address base, address quote) external view returns (address);
}








interface IWStEth {
    function wrap(uint256 _stETHAmount) external returns (uint256);
    function unwrap(uint256 _wstETHAmount) external returns (uint256);
    function stEthPerToken() external view returns (uint256);
    function tokensPerStEth() external view returns (uint256);
}







library Denominations {
  address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
  address public constant BTC = 0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB;

  // Fiat currencies follow https://en.wikipedia.org/wiki/ISO_4217
  address public constant USD = address(840);
  address public constant GBP = address(826);
  address public constant EUR = address(978);
  address public constant JPY = address(392);
  address public constant KRW = address(410);
  address public constant CNY = address(156);
  address public constant AUD = address(36);
  address public constant CAD = address(124);
  address public constant CHF = address(756);
  address public constant ARS = address(32);
  address public constant PHP = address(608);
  address public constant NZD = address(554);
  address public constant SGD = address(702);
  address public constant NGN = address(566);
  address public constant ZAR = address(710);
  address public constant RUB = address(643);
  address public constant INR = address(356);
  address public constant BRL = address(986);
}







contract MainnetUtilAddresses {
    address internal refillCaller = 0x33fDb79aFB4456B604f376A45A546e7ae700e880;
    address internal feeAddr = 0x76720aC2574631530eC8163e4085d6F98513fb27;

    address internal constant BOT_REGISTRY_ADDRESS = 0x637726f8b08a7ABE3aE3aCaB01A80E2d8ddeF77B;
    address internal constant UNI_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address internal constant MKR_PROXY_REGISTRY = 0x4678f0a6958e4D2Bc4F1BAF7Bc52E8F3564f3fE4;
    address internal constant AAVE_MARKET = 0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5;
    address internal constant AAVE_V3_MARKET = 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e;
    address internal constant SPARK_MARKET = 0x02C3eA4e34C0cBd694D2adFa2c690EECbC1793eE;

    address internal constant DFS_PROXY_REGISTRY_ADDR = 0x29474FdaC7142f9aB7773B8e38264FA15E3805ed;

    address internal constant WETH_ADDR = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address internal constant WSTETH_ADDR = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    address internal constant STETH_ADDR = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
    address internal constant WBTC_ADDR = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address internal constant CHAINLINK_WBTC_ADDR = 0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB;
    address internal constant DAI_ADDR = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    address internal constant FEE_RECEIVER_ADMIN_ADDR = 0xA74e9791D7D66c6a14B2C571BdA0F2A1f6D64E06;

    address internal constant UNI_V3_ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address internal constant UNI_V3_QUOTER = 0xb27308f9F90D607463bb33eA1BeBb41C27CE5AB6;

    address internal constant FEE_RECIPIENT = 0x39C4a92Dc506300c3Ea4c67ca4CA611102ee6F2A;

    // not needed on mainnet
    address internal constant DEFAULT_BOT = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    address public constant CHAINLINK_FEED_REGISTRY = 0x47Fb2585D2C56Fe188D0E6ec628a38b74fCeeeDf;
    
    address public constant TX_SAVER_FEE_RECIPIENT = 0x0eD7f3223266Ca1694F85C23aBe06E614Af3A479;

}







contract UtilHelper is MainnetUtilAddresses{
}















contract TokenPriceHelper is DSMath, UtilHelper {
    IFeedRegistry public constant feedRegistry = IFeedRegistry(CHAINLINK_FEED_REGISTRY);

    /// @dev Helper function that returns chainlink price data
    /// @param _inputTokenAddr Token address we are looking the usd price for
    /// @param _roundId Chainlink roundId, if 0 uses the latest
    function getRoundInfo(address _inputTokenAddr, uint80 _roundId, IAggregatorV3 aggregator)
        public
        view
        returns (uint256, uint256 updateTimestamp)
    {
        int256 price;

        /// @dev Price staleness not checked, the risk has been deemed acceptable
        if (_roundId == 0) {
            (, price, , updateTimestamp, ) = aggregator.latestRoundData();
        } else {
            (, price, , updateTimestamp, ) = aggregator.getRoundData(_roundId);
        }

        // no price for wsteth, can calculate from steth
        if (_inputTokenAddr == WSTETH_ADDR) price = getWStEthPrice(price);

        return (uint256(price), updateTimestamp);
    }

    /// @dev Helper function that returns chainlink price data
    /// @param _inputTokenAddr Token address we are looking the usd price for
    /// @param _roundId Chainlink roundId, if 0 uses the latest
    function getRoundInfo(address _inputTokenAddr, uint80 _roundId)
        public
        view
        returns (uint256, uint256 updateTimestamp)
    {
        address tokenAddr = getAddrForChainlinkOracle(_inputTokenAddr);
        IAggregatorV3 aggregator = IAggregatorV3(feedRegistry.getFeed(tokenAddr, Denominations.USD));

        return getRoundInfo(_inputTokenAddr, _roundId, aggregator);
    }

    /// @dev helper function that returns latest token price in USD
    /// @dev 1. Chainlink USD feed
    /// @dev 2. Chainlink ETH feed
    /// @dev 3. Aave feed
    /// @dev if no price found return 0
    function getPriceInUSD(address _inputTokenAddr) public view returns (uint256) {
        address chainlinkTokenAddr = getAddrForChainlinkOracle(_inputTokenAddr);

        int256 price;
        price = getChainlinkPriceInUSD(chainlinkTokenAddr, true);
        if (price == 0){
            price = int256(getAaveTokenPriceInUSD(_inputTokenAddr));
        }
        if (price == 0){
            price = int256(getAaveV3TokenPriceInUSD(_inputTokenAddr));
        }
        if (price == 0){
            price = int256(getSparkTokenPriceInUSD(_inputTokenAddr));
        }
        if (price == 0){
            return 0;
        }

        if (_inputTokenAddr == WSTETH_ADDR) price = getWStEthPrice(price);
        if (_inputTokenAddr == WBTC_ADDR) price = getWBtcPrice(price);
        return uint256(price);
    }

    /// @dev helper function that returns latest token price in USD
    /// @dev 1. Chainlink USD feed
    /// @dev 2. Chainlink ETH feed
    /// @dev 3. Aave feed
    /// @dev if no price found return 0
    /// @dev expect WBTC and WSTETH to have chainlink USD price
    function getPriceInETH(address _inputTokenAddr) public view returns (uint256) {
        address chainlinkTokenAddr = getAddrForChainlinkOracle(_inputTokenAddr);

        uint256 chainlinkPriceInUSD = uint256(getChainlinkPriceInUSD(chainlinkTokenAddr, false));
        if (chainlinkPriceInUSD != 0){
            uint256 chainlinkETHPriceInUSD = uint256(getChainlinkPriceInUSD(ETH_ADDR, false));
            uint256 priceInEth = wdiv(chainlinkPriceInUSD, chainlinkETHPriceInUSD);
            if (_inputTokenAddr == WSTETH_ADDR) return uint256(getWStEthPrice(int256(priceInEth)));
            if (_inputTokenAddr == WBTC_ADDR) return uint256(getWBtcPrice(int256(priceInEth)));
            return priceInEth;
        }

        uint256 chainlinkPriceInETH = uint256(getChainlinkPriceInETH(chainlinkTokenAddr));
        if (chainlinkPriceInETH != 0) return chainlinkPriceInETH;

        uint256 aavePriceInETH = getAaveTokenPriceInETH(_inputTokenAddr);
        if (aavePriceInETH != 0) return aavePriceInETH;

        uint256 aaveV3PriceInETH = getAaveV3TokenPriceInETH(_inputTokenAddr);
        if (aaveV3PriceInETH != 0) return aaveV3PriceInETH;

        uint256 sparkPriceInETH = getSparkTokenPriceInETH(_inputTokenAddr);
        if (sparkPriceInETH != 0) return sparkPriceInETH;
        
        return 0;
    }

    /// @dev If there's no USD price feed can fallback to ETH price feed, if there's no USD or ETH price feed return 0
    function getChainlinkPriceInUSD(address _inputTokenAddr, bool _useFallback) public view returns (int256 chainlinkPriceInUSD) {
        try feedRegistry.latestRoundData(_inputTokenAddr, Denominations.USD) returns (uint80, int256 answer, uint256, uint256, uint80){
            chainlinkPriceInUSD = answer;
        } catch {
            if (_useFallback){
                uint256 chainlinkPriceInETH = uint256(getChainlinkPriceInETH(_inputTokenAddr));
                uint256 chainlinkETHPriceInUSD = uint256(getChainlinkPriceInUSD(ETH_ADDR, false));
                chainlinkPriceInUSD = int256(wmul(chainlinkPriceInETH, chainlinkETHPriceInUSD));
            } else {
                chainlinkPriceInUSD = 0;
            }
        }
    }

    /// @dev If there's no ETH price feed returns 0
    function getChainlinkPriceInETH(address _inputTokenAddr) public view returns (int256 chainlinkPriceInETH) {
        try feedRegistry.latestRoundData(_inputTokenAddr, Denominations.ETH) returns (uint80, int256 answer, uint256, uint256, uint80){
            chainlinkPriceInETH = answer;
        } catch {
            chainlinkPriceInETH = 0;
        }
    }
    
    /// @dev chainlink uses different addresses for WBTC and ETH
    /// @dev there is only STETH price feed so we use that for WSTETH and handle later 
    function getAddrForChainlinkOracle(address _inputTokenAddr)
        public
        pure
        returns (address tokenAddrForChainlinkUsage)
    {
        if (_inputTokenAddr == WETH_ADDR) {
            tokenAddrForChainlinkUsage = ETH_ADDR;
        } else if (_inputTokenAddr == WSTETH_ADDR) {
            tokenAddrForChainlinkUsage = STETH_ADDR;
        } else if (_inputTokenAddr == WBTC_ADDR) {
            tokenAddrForChainlinkUsage = CHAINLINK_WBTC_ADDR;
        } else {
            tokenAddrForChainlinkUsage = _inputTokenAddr;
        }
    }

    function getWStEthPrice(int256 _stEthPrice) public view returns (int256 wStEthPrice) {
        wStEthPrice = int256(wmul(uint256(_stEthPrice), IWStEth(WSTETH_ADDR).stEthPerToken()));
    }

    function getWBtcPrice(int256 _btcPrice) public view returns (int256 wBtcPrice) {
        (, int256 wBtcPriceToPeg, , , ) = feedRegistry.latestRoundData(WBTC_ADDR, CHAINLINK_WBTC_ADDR);
        wBtcPrice = (_btcPrice * wBtcPriceToPeg + 1e8 / 2) / 1e8;
    }

    /// @dev if price isn't found this returns 0
    function getAaveTokenPriceInETH(address _tokenAddr) public view returns (uint256 price) {
        address priceOracleAddress = ILendingPoolAddressesProviderV2(AAVE_MARKET).getPriceOracle();

        try IPriceOracleGetterAave(priceOracleAddress).getAssetPrice(_tokenAddr) returns (uint256 tokenPrice){
            price = tokenPrice;
        } catch {
            price = 0;
        }
    }

    /// @dev if price isn't found this returns 0
    function getAaveTokenPriceInUSD(address _tokenAddr) public view returns (uint256) {
        uint256 tokenAavePriceInETH = getAaveTokenPriceInETH(_tokenAddr);
        uint256 ethPriceInUSD = uint256(getChainlinkPriceInUSD(ETH_ADDR, false));

        return wmul(tokenAavePriceInETH, ethPriceInUSD);
    }

    function getAaveV3TokenPriceInUSD(address _tokenAddr) public view returns (uint256 price) {
        address priceOracleAddress = ILendingPoolAddressesProviderV2(AAVE_V3_MARKET).getPriceOracle();

        try IPriceOracleGetterAave(priceOracleAddress).getAssetPrice(_tokenAddr) returns (uint256 tokenPrice) {
            price = tokenPrice;
        } catch {
            price = 0;
        }
    }

    /// @dev if price isn't found this returns 0
    function getAaveV3TokenPriceInETH(address _tokenAddr) public view returns (uint256) {
        uint256 tokenAavePriceInUSD = getAaveV3TokenPriceInUSD(_tokenAddr);
        uint256 ethPriceInUSD = uint256(getChainlinkPriceInUSD(ETH_ADDR, false));

        return wdiv(tokenAavePriceInUSD, ethPriceInUSD);
    }

    function getSparkTokenPriceInUSD(address _tokenAddr) public view returns (uint256 price) {
        address priceOracleAddress = ILendingPoolAddressesProviderV2(SPARK_MARKET).getPriceOracle();

        try IPriceOracleGetterAave(priceOracleAddress).getAssetPrice(_tokenAddr) returns (uint256 tokenPrice) {
            price = tokenPrice;
        } catch {
            price = 0;
        }
    }

    /// @dev if price isn't found this returns 0
    function getSparkTokenPriceInETH(address _tokenAddr) public view returns (uint256) {
        uint256 tokenSparkPriceInUSD = getSparkTokenPriceInUSD(_tokenAddr);
        uint256 ethPriceInUSD = uint256(getChainlinkPriceInUSD(ETH_ADDR, false));

        return wdiv(tokenSparkPriceInUSD, ethPriceInUSD);
    }
}







abstract contract IWETH {
    function allowance(address, address) public virtual view returns (uint256);

    function balanceOf(address) public virtual view returns (uint256);

    function approve(address, uint256) public virtual;

    function transfer(address, uint256) public virtual returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) public virtual returns (bool);

    function deposit() public payable virtual;

    function withdraw(uint256) public virtual;
}









library TokenUtils {
    using SafeERC20 for IERC20;

    address public constant WETH_ADDR = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant ETH_ADDR = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    /// @dev Only approves the amount if allowance is lower than amount, does not decrease allowance
    function approveToken(
        address _tokenAddr,
        address _to,
        uint256 _amount
    ) internal {
        if (_tokenAddr == ETH_ADDR) return;

        if (IERC20(_tokenAddr).allowance(address(this), _to) < _amount) {
            IERC20(_tokenAddr).safeApprove(_to, _amount);
        }
    }

    function pullTokensIfNeeded(
        address _token,
        address _from,
        uint256 _amount
    ) internal returns (uint256) {
        // handle max uint amount
        if (_amount == type(uint256).max) {
            _amount = getBalance(_token, _from);
        }

        if (_from != address(0) && _from != address(this) && _token != ETH_ADDR && _amount != 0) {
            IERC20(_token).safeTransferFrom(_from, address(this), _amount);
        }

        return _amount;
    }

    function withdrawTokens(
        address _token,
        address _to,
        uint256 _amount
    ) internal returns (uint256) {
        if (_amount == type(uint256).max) {
            _amount = getBalance(_token, address(this));
        }

        if (_to != address(0) && _to != address(this) && _amount != 0) {
            if (_token != ETH_ADDR) {
                IERC20(_token).safeTransfer(_to, _amount);
            } else {
                (bool success, ) = _to.call{value: _amount}("");
                require(success, "Eth send fail");
            }
        }

        return _amount;
    }

    function depositWeth(uint256 _amount) internal {
        IWETH(WETH_ADDR).deposit{value: _amount}();
    }

    function withdrawWeth(uint256 _amount) internal {
        IWETH(WETH_ADDR).withdraw(_amount);
    }

    function getBalance(address _tokenAddr, address _acc) internal view returns (uint256) {
        if (_tokenAddr == ETH_ADDR) {
            return _acc.balance;
        } else {
            return IERC20(_tokenAddr).balanceOf(_acc);
        }
    }

    function getTokenDecimals(address _token) internal view returns (uint256) {
        if (_token == ETH_ADDR) return 18;

        return IERC20(_token).decimals();
    }
}










contract GasFeeHelper is DSMath, TokenPriceHelper {
    using TokenUtils for address;

    // only support token with decimals <= 18
    error TokenDecimalsUnsupportedError(uint256 decimals);

    FeeRecipient public constant feeRecipient = FeeRecipient(FEE_RECIPIENT);

    uint256 public constant SANITY_GAS_PRICE = 1000 gwei;

    /// @dev Divider for input amount, 5 bps
    uint256 public constant MAX_DFS_FEE = 2000;

    function calcGasCost(uint256 _gasUsed, address _feeToken, uint256 _l1GasCostInEth) public view returns (uint256 txCost) {
        uint256 gasPrice = tx.gasprice;

        // gas price must be in a reasonable range
        if (tx.gasprice > SANITY_GAS_PRICE) {
            gasPrice = SANITY_GAS_PRICE;
        }

        // can't use more gas than the block gas limit
        if (_gasUsed > block.gaslimit) {
            _gasUsed = block.gaslimit;
        }

        // calc gas used
        txCost = (_gasUsed * gasPrice) + _l1GasCostInEth;

        // convert to token amount
        if (_feeToken != TokenUtils.WETH_ADDR) {
            uint256 price = getPriceInETH(_feeToken);
            uint256 tokenDecimals = _feeToken.getTokenDecimals();

            if (tokenDecimals > 18) revert TokenDecimalsUnsupportedError(tokenDecimals);

            if (price > 0) {
                txCost = wdiv(txCost, uint256(price)) / (10**(18 - tokenDecimals));
            } else {
                txCost = 0;
            }
        }
    }

    
}







contract MainnetLlamaLendAddresses {
    address internal constant BYTES_TRANSIENT_STORAGE = 0xB3FE6f712c8B8c64CD2780ce714A36e7640DDf0f;
    address internal constant LLAMALEND_FACTORY = 0xeA6876DDE9e3467564acBeE1Ed5bac88783205E0;
    /// @dev this is the only WETH controller which has use_eth param default to True in Controller.remove_collateral 
    address internal constant OLD_WETH_CONTROLLER = 0xaade9230AA9161880E13a38C83400d3D1995267b;
}






abstract contract IBytesTransientStorage {
    function setBytesTransiently(bytes calldata) public virtual;
    function getBytesTransiently() public virtual returns (bytes memory);
}







interface IAGG {
    function rate() external view returns (uint256);
    function rate(address) external view returns (uint256);
    function rate0() external view returns (uint256);
    function target_debt_fraction() external view returns (uint256);
    function sigma() external view returns (int256);
    function peg_keepers(uint256) external view returns (address); 
}






interface ILLAMMA {
    function active_band_with_skip() external view returns (int256);
    function get_sum_xy(address) external view returns (uint256[2] memory);
    function get_xy(address) external view returns (uint256[][2] memory);
    function get_p() external view returns (uint256);
    function read_user_tick_numbers(address) external view returns (int256[2] memory);
    function p_oracle_up(int256) external view returns (uint256);
    function p_oracle_down(int256) external view returns (uint256);
    function p_current_up(int256) external view returns (uint256);
    function p_current_down(int256) external view returns (uint256);
    function bands_x(int256) external view returns (uint256);
    function bands_y(int256) external view returns (uint256);
    function get_base_price() external view returns (uint256);
    function price_oracle() external view returns (uint256);
    function active_band() external view returns (int256);
    function A() external view returns (uint256);
    function min_band() external view returns (int256);
    function max_band() external view returns (int256);
    function rate() external view returns (uint256);
    function exchange(uint256 i, uint256 j, uint256 in_amount, uint256 min_amount) external returns (uint256[2] memory);
    function coins(uint256 i) external view returns (address);
    function user_state(address _user) external view returns (uint256[4] memory);
}






interface ILlamaLendController {
    function create_loan(uint256 _collateralAmount, uint256 _debtAmount, uint256 _nBands) external payable;
    function create_loan_extended(uint256 _collateralAmount, uint256 _debtAmount, uint256 _nBands, address _callbacker, uint256[] memory _callbackArgs) external payable;

    /// @dev all functions below: if _collateralAmount is 0 will just return
    function add_collateral(uint256 _collateralAmount) external payable;
    function add_collateral(uint256 _collateralAmount, address _for) external payable;

    function remove_collateral(uint256 _collateralAmount) external;
    /// @param _useEth relevant only for ETH collateral pools (currently not deployed)
    function remove_collateral(uint256 _collateralAmount, bool _useEth) external;

    /// @dev all functions below: if _debtAmount is 0 will just return
    function borrow_more(uint256 _collateralAmount, uint256 _debtAmount) external payable;
    function borrow_more_extended(uint256 _collateralAmount, uint256 _debt, address _callbacker, uint256[] memory _callbackArgs) external payable;

    /// @dev if _debtAmount > debt will do full repay
    function repay(uint256 _debtAmount) external payable;
    function repay(uint256 _debtAmount, address _for) external payable;
    /// @param _maxActiveBand Don't allow active band to be higher than this (to prevent front-running the repay)
    function repay(uint256 _debtAmount, address _for, int256 _maxActiveBand) external payable;
    function repay(uint256 _debtAmount, address _for, int256 _maxActiveBand, bool _useEth) external payable;
    function repay_extended(address _callbacker, uint256[] memory _callbackArgs) external;

    function liquidate(address user, uint256 min_x) external;
    function liquidate(address user, uint256 min_x, bool _useEth) external;
    function liquidate_extended(address user, uint256 min_x, uint256 frac, bool use_eth, address callbacker, uint256[] memory _callbackArgs) external;
    function liquidate_extended(address user, uint256 min_x, uint256 frac, address callbacker, uint256[] memory _callbackArgs) external;


    /// GETTERS
    function amm() external view returns (address);
    function monetary_policy() external view returns (address);
    function collateral_token() external view returns (address);
    function borrowed_token() external view returns (address);
    function debt(address) external view returns (uint256);
    function total_debt() external view returns (uint256);
    function health_calculator(address, int256, int256, bool, uint256) external view returns (int256);
    function health_calculator(address, int256, int256, bool) external view returns (int256);
    function health(address) external view returns (int256);
    function health(address, bool) external view returns (int256);
    function max_borrowable(uint256 collateralAmount, uint256 nBands) external view returns (uint256);
    function min_collateral(uint256 debtAmount, uint256 nBands) external view returns (uint256);
    function calculate_debt_n1(uint256, uint256, uint256) external view returns (int256);
    function minted() external view returns (uint256);
    function redeemed() external view returns (uint256);
    function amm_price() external view returns (uint256);
    function user_state(address) external view returns (uint256[4] memory);
    function user_prices(address) external view returns (uint256[2] memory);
    function loan_exists(address) external view returns (bool);
    function liquidation_discount() external view returns (uint256);
    function factory() external view returns (address);
    function loan_discount() external view returns (uint256);
}







interface ILlamaLendFactory {
    function controllers(uint256) external view returns (address);
}














contract LlamaLendHelper is MainnetLlamaLendAddresses, DSMath {
    using TokenUtils for address;

    error InvalidLlamaLendController();

    IBytesTransientStorage constant transientStorage = IBytesTransientStorage(BYTES_TRANSIENT_STORAGE);
    ILlamaLendFactory constant factory = ILlamaLendFactory(LLAMALEND_FACTORY);

    bytes4 constant LLAMALEND_SWAPPER_ID = bytes4(keccak256("LlamaLendSwapper"));

    function isControllerValid(address _controllerAddr, uint256 _controllerId) public view returns (bool) {
        return (factory.controllers(_controllerId) == _controllerAddr);
    }

    function getCollateralRatio(address _user, address _controllerAddr) public view returns (uint256 collRatio, bool isInSoftLiquidation) {
        // fetch users debt
        uint256 debt = ILlamaLendController(_controllerAddr).debt(_user);
        // no position can exist without debt
        if (debt == 0) return (0, false);
        (uint256 debtAssetCollAmount, uint256 collAmount) = getCollAmountsFromAMM(_controllerAddr, _user);
        // if user has debt asset as coll he is currently underwater
        if (debtAssetCollAmount > 0) isInSoftLiquidation = true;

        // fetch collToken oracle price
        address amm = ILlamaLendController(_controllerAddr).amm();
        uint256 oraclePrice = ILLAMMA(amm).price_oracle();
        // calculate collAmount as WAD (18 decimals)
        address collToken = ILlamaLendController(_controllerAddr).collateral_token();
        uint256 assetDec = IERC20(collToken).decimals();
        uint256 collAmountWAD = assetDec > 18 ? (collAmount / 10 ** (assetDec - 18)) : (collAmount * 10 ** (18 - assetDec));
        
        collRatio = wdiv(wmul(collAmountWAD, oraclePrice) + debtAssetCollAmount, debt);
    }

    function _sendLeftoverFunds(
        address _collToken,
        address _debtToken,
        uint256 _collStartingBalance,
        uint256 _debtStartingBalance,
        address _to
    ) internal returns (uint256 collTokenReceived, uint256 debtTokenReceived) {
        collTokenReceived = _collToken.getBalance(address(this)) - _collStartingBalance;
        debtTokenReceived = _debtToken.getBalance(address(this)) - _debtStartingBalance;
        _collToken.withdrawTokens(_to, collTokenReceived);
        _debtToken.withdrawTokens(_to, debtTokenReceived);
    }

    function userMaxWithdraw(
        address _controllerAddress,
        address _user
    ) public view returns (uint256 maxWithdraw) {
        uint256[4] memory userState = ILlamaLendController(_controllerAddress).user_state(_user);
        return
            userState[0] -
            ILlamaLendController(_controllerAddress).min_collateral(userState[2], userState[3]);
    }

    function getCollAmountsFromAMM(
        address _controllerAddress,
        address _user
    ) public view returns (uint256 debtAssetCollAmount, uint256 collAssetCollAmount) {
        address llammaAddress = ILlamaLendController(_controllerAddress).amm();
        uint256[2] memory xy = ILLAMMA(llammaAddress).get_sum_xy(_user);
        debtAssetCollAmount = xy[0];
        collAssetCollAmount = xy[1];
    }
}







contract MainnetActionsUtilAddresses {
    address internal constant DFS_REG_CONTROLLER_ADDR = 0xF8f8B3C98Cf2E63Df3041b73f80F362a4cf3A576;
    address internal constant REGISTRY_ADDR = 0x287778F121F134C66212FB16c9b53eC991D32f5b;
    address internal constant DFS_LOGGER_ADDR = 0xcE7a977Cac4a481bc84AC06b2Da0df614e621cf3;
    address internal constant SUB_STORAGE_ADDR = 0x1612fc28Ee0AB882eC99842Cde0Fc77ff0691e90;
    address internal constant PROXY_AUTH_ADDR = 0x149667b6FAe2c63D1B4317C716b0D0e4d3E2bD70;
    address internal constant LSV_PROXY_REGISTRY_ADDRESS = 0xa8a3c86c4A2DcCf350E84D2b3c46BDeBc711C16e;
    address internal constant TRANSIENT_STORAGE = 0x2F7Ef2ea5E8c97B8687CA703A0e50Aa5a49B7eb2;
}







contract ActionsUtilHelper is MainnetActionsUtilAddresses {
}








contract DFSRegistry is AdminAuth {
    error EntryAlreadyExistsError(bytes4);
    error EntryNonExistentError(bytes4);
    error EntryNotInChangeError(bytes4);
    error ChangeNotReadyError(uint256,uint256);
    error EmptyPrevAddrError(bytes4);
    error AlreadyInContractChangeError(bytes4);
    error AlreadyInWaitPeriodChangeError(bytes4);

    event AddNewContract(address,bytes4,address,uint256);
    event RevertToPreviousAddress(address,bytes4,address,address);
    event StartContractChange(address,bytes4,address,address);
    event ApproveContractChange(address,bytes4,address,address);
    event CancelContractChange(address,bytes4,address,address);
    event StartWaitPeriodChange(address,bytes4,uint256);
    event ApproveWaitPeriodChange(address,bytes4,uint256,uint256);
    event CancelWaitPeriodChange(address,bytes4,uint256,uint256);

    struct Entry {
        address contractAddr;
        uint256 waitPeriod;
        uint256 changeStartTime;
        bool inContractChange;
        bool inWaitPeriodChange;
        bool exists;
    }

    mapping(bytes4 => Entry) public entries;
    mapping(bytes4 => address) public previousAddresses;

    mapping(bytes4 => address) public pendingAddresses;
    mapping(bytes4 => uint256) public pendingWaitTimes;

    /// @notice Given an contract id returns the registered address
    /// @dev Id is keccak256 of the contract name
    /// @param _id Id of contract
    function getAddr(bytes4 _id) public view returns (address) {
        return entries[_id].contractAddr;
    }

    /// @notice Helper function to easily query if id is registered
    /// @param _id Id of contract
    function isRegistered(bytes4 _id) public view returns (bool) {
        return entries[_id].exists;
    }

    /////////////////////////// OWNER ONLY FUNCTIONS ///////////////////////////

    /// @notice Adds a new contract to the registry
    /// @param _id Id of contract
    /// @param _contractAddr Address of the contract
    /// @param _waitPeriod Amount of time to wait before a contract address can be changed
    function addNewContract(
        bytes4 _id,
        address _contractAddr,
        uint256 _waitPeriod
    ) public onlyOwner {
        if (entries[_id].exists){
            revert EntryAlreadyExistsError(_id);
        }

        entries[_id] = Entry({
            contractAddr: _contractAddr,
            waitPeriod: _waitPeriod,
            changeStartTime: 0,
            inContractChange: false,
            inWaitPeriodChange: false,
            exists: true
        });

        emit AddNewContract(msg.sender, _id, _contractAddr, _waitPeriod);
    }

    /// @notice Reverts to the previous address immediately
    /// @dev In case the new version has a fault, a quick way to fallback to the old contract
    /// @param _id Id of contract
    function revertToPreviousAddress(bytes4 _id) public onlyOwner {
        if (!(entries[_id].exists)){
            revert EntryNonExistentError(_id);
        }
        if (previousAddresses[_id] == address(0)){
            revert EmptyPrevAddrError(_id);
        }

        address currentAddr = entries[_id].contractAddr;
        entries[_id].contractAddr = previousAddresses[_id];

        emit RevertToPreviousAddress(msg.sender, _id, currentAddr, previousAddresses[_id]);
    }

    /// @notice Starts an address change for an existing entry
    /// @dev Can override a change that is currently in progress
    /// @param _id Id of contract
    /// @param _newContractAddr Address of the new contract
    function startContractChange(bytes4 _id, address _newContractAddr) public onlyOwner {
        if (!entries[_id].exists){
            revert EntryNonExistentError(_id);
        }
        if (entries[_id].inWaitPeriodChange){
            revert AlreadyInWaitPeriodChangeError(_id);
        }

        entries[_id].changeStartTime = block.timestamp; // solhint-disable-line
        entries[_id].inContractChange = true;

        pendingAddresses[_id] = _newContractAddr;

        emit StartContractChange(msg.sender, _id, entries[_id].contractAddr, _newContractAddr);
    }

    /// @notice Changes new contract address, correct time must have passed
    /// @param _id Id of contract
    function approveContractChange(bytes4 _id) public onlyOwner {
        if (!entries[_id].exists){
            revert EntryNonExistentError(_id);
        }
        if (!entries[_id].inContractChange){
            revert EntryNotInChangeError(_id);
        }
        if (block.timestamp < (entries[_id].changeStartTime + entries[_id].waitPeriod)){// solhint-disable-line
            revert ChangeNotReadyError(block.timestamp, (entries[_id].changeStartTime + entries[_id].waitPeriod));
        }

        address oldContractAddr = entries[_id].contractAddr;
        entries[_id].contractAddr = pendingAddresses[_id];
        entries[_id].inContractChange = false;
        entries[_id].changeStartTime = 0;

        pendingAddresses[_id] = address(0);
        previousAddresses[_id] = oldContractAddr;

        emit ApproveContractChange(msg.sender, _id, oldContractAddr, entries[_id].contractAddr);
    }

    /// @notice Cancel pending change
    /// @param _id Id of contract
    function cancelContractChange(bytes4 _id) public onlyOwner {
        if (!entries[_id].exists){
            revert EntryNonExistentError(_id);
        }
        if (!entries[_id].inContractChange){
            revert EntryNotInChangeError(_id);
        }

        address oldContractAddr = pendingAddresses[_id];

        pendingAddresses[_id] = address(0);
        entries[_id].inContractChange = false;
        entries[_id].changeStartTime = 0;

        emit CancelContractChange(msg.sender, _id, oldContractAddr, entries[_id].contractAddr);
    }

    /// @notice Starts the change for waitPeriod
    /// @param _id Id of contract
    /// @param _newWaitPeriod New wait time
    function startWaitPeriodChange(bytes4 _id, uint256 _newWaitPeriod) public onlyOwner {
        if (!entries[_id].exists){
            revert EntryNonExistentError(_id);
        }
        if (entries[_id].inContractChange){
            revert AlreadyInContractChangeError(_id);
        }

        pendingWaitTimes[_id] = _newWaitPeriod;

        entries[_id].changeStartTime = block.timestamp; // solhint-disable-line
        entries[_id].inWaitPeriodChange = true;

        emit StartWaitPeriodChange(msg.sender, _id, _newWaitPeriod);
    }

    /// @notice Changes new wait period, correct time must have passed
    /// @param _id Id of contract
    function approveWaitPeriodChange(bytes4 _id) public onlyOwner {
        if (!entries[_id].exists){
            revert EntryNonExistentError(_id);
        }
        if (!entries[_id].inWaitPeriodChange){
            revert EntryNotInChangeError(_id);
        }
        if (block.timestamp < (entries[_id].changeStartTime + entries[_id].waitPeriod)){ // solhint-disable-line
            revert ChangeNotReadyError(block.timestamp, (entries[_id].changeStartTime + entries[_id].waitPeriod));
        }

        uint256 oldWaitTime = entries[_id].waitPeriod;
        entries[_id].waitPeriod = pendingWaitTimes[_id];
        
        entries[_id].inWaitPeriodChange = false;
        entries[_id].changeStartTime = 0;

        pendingWaitTimes[_id] = 0;

        emit ApproveWaitPeriodChange(msg.sender, _id, oldWaitTime, entries[_id].waitPeriod);
    }

    /// @notice Cancel wait period change
    /// @param _id Id of contract
    function cancelWaitPeriodChange(bytes4 _id) public onlyOwner {
        if (!entries[_id].exists){
            revert EntryNonExistentError(_id);
        }
        if (!entries[_id].inWaitPeriodChange){
            revert EntryNotInChangeError(_id);
        }

        uint256 oldWaitPeriod = pendingWaitTimes[_id];

        pendingWaitTimes[_id] = 0;
        entries[_id].inWaitPeriodChange = false;
        entries[_id].changeStartTime = 0;

        emit CancelWaitPeriodChange(msg.sender, _id, oldWaitPeriod, entries[_id].waitPeriod);
    }
}






contract DFSExchangeData {

    struct OffchainData {
        address wrapper; // dfs wrapper address for the aggregator (must be in WrapperExchangeRegistry)
        address exchangeAddr; // exchange address we are calling to execute the order (must be in ExchangeAggregatorRegistry)
        address allowanceTarget; // exchange aggregator contract we give allowance to
        uint256 price; // expected price that the aggregator sent us
        uint256 protocolFee; // deprecated (used as a separate fee amount for 0x v1)
        bytes callData; // 0ff-chain calldata the aggregator gives to perform the swap
    }

    struct ExchangeData {
        address srcAddr; // source token address (which we're selling)
        address destAddr; // destination token address (which we're buying)
        uint256 srcAmount; // amount of source token in token decimals
        uint256 destAmount; // amount of bought token in token decimals
        uint256 minPrice; // minPrice we are expecting (checked in DFSExchangeCore)
        uint256 dfsFeeDivider; // service fee divider
        address user; // currently deprecated (used to check custom fees for the user)
        address wrapper; // on-chain wrapper address (must be in WrapperExchangeRegistry)
        bytes wrapperData; // on-chain additional data for on-chain (uniswap route for example)
        OffchainData offchainData; // offchain aggregator order
    }

    struct InjectedExchangeData {
        address wrapper; // on-chain wrapper address (must be in WrapperExchangeRegistry)
        bytes wrapperData; // on-chain additional data for on-chain (uniswap route for example)
        OffchainData offchainData; // offchain aggregator order
    }
}









contract StrategyModel {
        
    /// @dev Group of strategies bundled together so user can sub to multiple strategies at once
    /// @param creator Address of the user who created the bundle
    /// @param strategyIds Array of strategy ids stored in StrategyStorage
    struct StrategyBundle {
        address creator;
        uint64[] strategyIds;
    }

    /// @dev Template/Class which defines a Strategy
    /// @param name Name of the strategy useful for logging what strategy is executing
    /// @param creator Address of the user which created the strategy
    /// @param triggerIds Array of identifiers for trigger - bytes4(keccak256(TriggerName))
    /// @param actionIds Array of identifiers for actions - bytes4(keccak256(ActionName))
    /// @param paramMapping Describes how inputs to functions are piped from return/subbed values
    /// @param continuous If the action is repeated (continuos) or one time
    struct Strategy {
        string name;
        address creator;
        bytes4[] triggerIds;
        bytes4[] actionIds;
        uint8[][] paramMapping;
        bool continuous;
    }

    /// @dev List of actions grouped as a recipe
    /// @param name Name of the recipe useful for logging what recipe is executing
    /// @param callData Array of calldata inputs to each action
    /// @param subData Used only as part of strategy, subData injected from StrategySub.subData
    /// @param actionIds Array of identifiers for actions - bytes4(keccak256(ActionName))
    /// @param paramMapping Describes how inputs to functions are piped from return/subbed values
    struct Recipe {
        string name;
        bytes[] callData;
        bytes32[] subData;
        bytes4[] actionIds;
        uint8[][] paramMapping;
    }

    /// @dev Actual data of the sub we store on-chain
    /// @dev In order to save on gas we store a keccak256(StrategySub) and verify later on
    /// @param walletAddr Address of the users smart wallet/proxy
    /// @param isEnabled Toggle if the subscription is active
    /// @param strategySubHash Hash of the StrategySub data the user inputted
    struct StoredSubData {
        bytes20 walletAddr; // address but put in bytes20 for gas savings
        bool isEnabled;
        bytes32 strategySubHash;
    }

    /// @dev Instance of a strategy, user supplied data
    /// @param strategyOrBundleId Id of the strategy or bundle, depending on the isBundle bool
    /// @param isBundle If true the id points to bundle, if false points directly to strategyId
    /// @param triggerData User supplied data needed for checking trigger conditions
    /// @param subData User supplied data used in recipe
    struct StrategySub {
        uint64 strategyOrBundleId;
        bool isBundle;
        bytes[] triggerData;
        bytes32[] subData;
    }

    /// @dev Data needed when signing relay transaction
    /// @param maxTxCostInFeeToken Max tx cost user is willing to pay in fee token
    /// @param feeToken Address of the token user is willing to pay fee in
    /// @param tokenPriceInEth Price of the token in ETH
    /// @param deadline Deadline for the relay transaction to be executed
    /// @param shouldTakeFeeFromPosition Flag to indicate if fee should be taken from position, otherwise from EOA/wallet
    struct TxSaverSignedData {
        uint256 maxTxCostInFeeToken;
        address feeToken;
        uint256 tokenPriceInEth;
        uint256 deadline;
        bool shouldTakeFeeFromPosition;
    }
}









contract DFSExchangeHelper {
    
    using TokenUtils for address;
    
    error InvalidOffchainData();
    error OutOfRangeSlicingError();
    //Order success but amount 0
    error ZeroTokensSwapped();

    using SafeERC20 for IERC20;

    function sendLeftover(
        address _srcAddr,
        address _destAddr,
        address payable _to
    ) internal {
        // clean out any eth leftover
        TokenUtils.ETH_ADDR.withdrawTokens(_to, type(uint256).max);

        _srcAddr.withdrawTokens(_to, type(uint256).max);
        _destAddr.withdrawTokens(_to, type(uint256).max);
    }

    function sliceUint(bytes memory bs, uint256 start) internal pure returns (uint256) {
        if (bs.length < start + 32){
            revert OutOfRangeSlicingError();
        }

        uint256 x;
        assembly {
            x := mload(add(bs, add(0x20, start)))
        }

        return x;
    }

    function writeUint256(
        bytes memory _b,
        uint256 _index,
        uint256 _input
    ) internal pure {
        if (_b.length < _index + 32) {
            revert InvalidOffchainData();
        }

        bytes32 input = bytes32(_input);

        _index += 32;

        // Read the bytes32 from array memory
        assembly {
            mstore(add(_b, _index), input)
        }
    }
}







contract MainnetExchangeAddresses {

    address internal constant FEE_RECIPIENT_ADDRESS = 0x39C4a92Dc506300c3Ea4c67ca4CA611102ee6F2A;
    address internal constant DISCOUNT_ADDRESS = 0x84fE6D4aaD0CA1ce3af7153eecd11729fa7a74f0;
    address internal constant WRAPPER_EXCHANGE_REGISTRY = 0x653893375dD1D942D2C429caB51641F2bf14d426;
    address internal constant EXCHANGE_AGGREGATOR_REGISTRY_ADDR = 0x7b67D9D7993A258C4b2C31CDD9E6cbD5Fb674985;
    address internal constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address internal constant TOKEN_GROUP_REGISTRY = 0xcA49e64FE1FE8be40ED30F682edA1b27a6c8611c;
    address internal constant BYTES_TRANSIENT_STORAGE_ADDR = 0xB3FE6f712c8B8c64CD2780ce714A36e7640DDf0f;
}







contract ExchangeHelper is MainnetExchangeAddresses {
}







contract ExchangeAggregatorRegistry is AdminAuth {
    mapping(address => bool) public exchangeTargetAddresses;

    error EmptyAddrError();

    function setExchangeTargetAddr(address _exchangeAddr, bool _state) public onlyOwner {
        if(_exchangeAddr == address(0)) {
			revert EmptyAddrError();
		}

        exchangeTargetAddresses[_exchangeAddr] = _state;
    }

    function isExchangeAggregatorAddr(address _exchangeAddr) public view returns (bool) {
        return exchangeTargetAddresses[_exchangeAddr];
    }
}






contract WrapperExchangeRegistry is AdminAuth {
	mapping(address => bool) private wrappers;

	error EmptyAddrError();

	function addWrapper(address _wrapper) public onlyOwner {
		if(_wrapper == address(0)) {
			revert EmptyAddrError();
		}

		wrappers[_wrapper] = true;
	}

	function removeWrapper(address _wrapper) public onlyOwner {
		wrappers[_wrapper] = false;
	}

	function isWrapper(address _wrapper) public view returns(bool) {
		return wrappers[_wrapper];
	}
}







interface IExchangeV3 {
    function sell(address _srcAddr, address _destAddr, uint _srcAmount, bytes memory _additionalData) external returns (uint);
    function getSellRate(address _srcAddr, address _destAddr, uint _srcAmount, bytes memory _additionalData) external returns (uint);
}







abstract contract IOffchainWrapper is DFSExchangeData {
    function takeOrder(
        ExchangeData memory _exData
    ) virtual public payable returns (bool success, uint256);
}







contract Discount is AdminAuth{
    mapping(address => bool) public serviceFeesDisabled;

    function reenableServiceFee(address _wallet) public onlyOwner{
        serviceFeesDisabled[_wallet] = false;
    }

    function disableServiceFee(address _wallet) public onlyOwner{
        serviceFeesDisabled[_wallet] = true;
    }
}



















contract DFSExchangeCore is
    DSMath,
    DFSExchangeHelper,
    DFSExchangeData,
    ExchangeHelper,
    StrategyModel
{   
    using SafeERC20 for IERC20;
    using TokenUtils for address;

    error SlippageHitError(uint256 amountBought, uint256 amountExpected);
    error InvalidWrapperError(address wrapperAddr);

    ExchangeAggregatorRegistry internal constant exchangeAggRegistry = ExchangeAggregatorRegistry(EXCHANGE_AGGREGATOR_REGISTRY_ADDR);
    WrapperExchangeRegistry internal constant wrapperRegistry = WrapperExchangeRegistry(WRAPPER_EXCHANGE_REGISTRY);

    /// @notice Internal method that performs a sell on offchain aggregator/on-chain
    /// @dev Useful for other DFS contract to integrate for exchanging
    /// @param exData Exchange data struct
    function _sell(ExchangeData memory exData) internal returns (address wrapperAddress, uint256 destAmount) {
        (wrapperAddress, destAmount, ) = _sell(exData, address(this));
    }

    /// @notice Internal method that performs a sell on offchain aggregator/on-chain
    /// @dev Useful for other DFS contract to integrate for exchanging
    /// @param exData Exchange data struct
    /// @return (address, uint, bool) Address of the wrapper used and destAmount and if there was fee
    function _sell(ExchangeData memory exData, address smartWallet) internal returns (address, uint256, bool) {
        uint256 amountWithoutFee = exData.srcAmount;
        uint256 destBalanceBefore = exData.destAddr.getBalance(address(this));

        _takeDfsExchangeFee(exData, smartWallet);

        address wrapperAddr = _executeSwap(exData);

        uint256 destBalanceAfter = exData.destAddr.getBalance(address(this));
        uint256 amountBought = destBalanceAfter - destBalanceBefore;

        // check slippage
        if (amountBought < wmul(exData.minPrice, exData.srcAmount)){
            revert SlippageHitError(amountBought, wmul(exData.minPrice, exData.srcAmount));
        }

        bool hasFee = exData.srcAmount != amountWithoutFee;
        // revert back exData changes to keep it consistent
        exData.srcAmount = amountWithoutFee;

        return (wrapperAddr, amountBought, hasFee);
    }

    /// @notice Takes order from exchange aggregator and returns bool indicating if it is successful
    /// @param _exData Exchange data
    function offChainSwap(ExchangeData memory _exData)
        internal
        returns (bool success, uint256)
    {
        /// @dev Check if exchange address is in our registry to not call an untrusted contract
        if (!exchangeAggRegistry.isExchangeAggregatorAddr(_exData.offchainData.exchangeAddr)) {
            return (false, 0);
        }

        /// @dev Check if we have the address is a registered wrapper
        if (!wrapperRegistry.isWrapper(_exData.offchainData.wrapper)) {
            return (false, 0);
        }

        // send src amount
        IERC20(_exData.srcAddr).safeTransfer(_exData.offchainData.wrapper, _exData.srcAmount);

        return IOffchainWrapper(_exData.offchainData.wrapper).takeOrder(_exData);
    }

    /// @notice Calls wrapper contract for exchange to preform an on-chain swap
    /// @param _exData Exchange data struct
    /// @return swappedTokens Dest amount of tokens we get after sell
    function onChainSwap(ExchangeData memory _exData)
        internal
        returns (uint256 swappedTokens)
    {
        if (!(WrapperExchangeRegistry(WRAPPER_EXCHANGE_REGISTRY).isWrapper(_exData.wrapper))){
            revert InvalidWrapperError(_exData.wrapper);
        }

        IERC20(_exData.srcAddr).safeTransfer(_exData.wrapper, _exData.srcAmount);

        swappedTokens = IExchangeV3(_exData.wrapper).sell(
            _exData.srcAddr,
            _exData.destAddr,
            _exData.srcAmount,
            _exData.wrapperData
        );
    }

    function _takeDfsExchangeFee(ExchangeData memory exData, address smartWallet) internal {
        if (exData.dfsFeeDivider != 0) {
            exData.srcAmount = sub(exData.srcAmount, getFee(
                exData.srcAmount,
                smartWallet,
                exData.srcAddr,
                exData.dfsFeeDivider
            ));
        }
    }

    function _executeSwap(ExchangeData memory exData) internal returns (address wrapperAddr) {
        wrapperAddr = exData.offchainData.wrapper;
        bool offChainSwapSuccess;

         // Try offchain aggregator first and then fallback on specific wrapper
        if (exData.offchainData.price > 0) {
            (offChainSwapSuccess, ) = offChainSwap(exData);
        }

        // fallback to desired wrapper if offchain aggregator failed
        if (!offChainSwapSuccess) {
            onChainSwap(exData);
            wrapperAddr = exData.wrapper;
        }
    }

    /// @notice Takes a feePercentage and sends it to wallet
    /// @param _amount Amount of the whole trade
    /// @param _wallet Address of the users wallet (safe or dsproxy)
    /// @param _token Address of the token
    /// @param _dfsFeeDivider Dfs fee divider
    /// @return feeAmount Amount owner earned on the fee
    function getFee(
        uint256 _amount,
        address _wallet,
        address _token,
        uint256 _dfsFeeDivider
    ) internal returns (uint256 feeAmount) {
        if (_dfsFeeDivider != 0 && Discount(DISCOUNT_ADDRESS).serviceFeesDisabled(_wallet)) {
            _dfsFeeDivider = 0;
        }

        if (_dfsFeeDivider == 0) {
            feeAmount = 0;
        } else {
            feeAmount = _amount / _dfsFeeDivider;
            address walletAddr = FeeRecipient(FEE_RECIPIENT_ADDRESS).getFeeAddr();
            _token.withdrawTokens(walletAddr, feeAmount);
        }
    }
}







interface ITxSaverBytesTransientStorage {
    function getFeeType() external view returns (uint256);
    function getBytesTransiently() external view returns (bytes memory result);
}









contract TxSaverGasCostCalc is DSMath, UtilHelper {
    using TokenUtils for address;
    
    // only support token with decimals <= 18
    error TokenDecimalsTooHigh(uint256 decimals);
    // when injecting price, price must be greater than 0
    error ZeroTokenPriceInEthError();

    function calcGasCostUsingInjectedPrice(
        uint256 _gasUsed,
        address _feeToken,
        uint256 _tokenPriceInEth,
        uint256 _l1GasCostInEth
    ) internal view returns (uint256 txCost) {
        // can't use more gas than the block gas limit
        if (_gasUsed > block.gaslimit) {
            _gasUsed = block.gaslimit;
        }

        // calc gas used
        txCost = (_gasUsed * tx.gasprice) + _l1GasCostInEth;    

        // convert to token amount
        if (_feeToken != TokenUtils.WETH_ADDR) {
            uint256 tokenDecimals = _feeToken.getTokenDecimals();

            if (tokenDecimals > 18) revert TokenDecimalsTooHigh(tokenDecimals);

            if (_tokenPriceInEth == 0) revert ZeroTokenPriceInEthError();

            txCost = wdiv(txCost, _tokenPriceInEth) / (10**(18 - tokenDecimals));
        }
    }
}












contract DFSExchangeWithTxSaver is DFSExchangeCore, TxSaverGasCostCalc
{   
    using SafeERC20 for IERC20;
    using TokenUtils for address;

    bytes4 internal constant TX_SAVER_EXECUTOR_ID = bytes4(keccak256("TxSaverExecutor"));
    uint256 constant EOA_OR_WALLET_FEE_FLAG = 2; // see TxSaverBytesTransientStorage

    /// For TxSaver, total gas cost fee taken from user can't be higher than maxTxCost set by user
    error TxCostInFeeTokenTooHighError(uint256 maxTxCost, uint256 txCost);

    error FeeTokenNotSameAsSrcToken(address srcToken, address feeToken);

    function _sellWithTxSaverChoice(ExchangeData memory _exData, address _user, DFSRegistry _registry) 
        internal returns (
            address wrapperAddress,
            uint256 destAmount,
            bool hasFee,
            bool txSaverFeeTaken
        ) 
    {   
        address txSaverAddr = _registry.getAddr(TX_SAVER_EXECUTOR_ID);
        ITxSaverBytesTransientStorage tStorage = ITxSaverBytesTransientStorage(txSaverAddr);

        // Check if TxSaverExecutor initiated transaction by setting right flag in transient storage
        // we can't just check for msg.sender, as that wouldn't work for flashloan actions
        uint256 feeType = tStorage.getFeeType();
        
        // if not initiated by TxSaverExecutor, perform regular sell
        if (feeType == 0) {
            txSaverFeeTaken = false;
            (wrapperAddress, destAmount, hasFee) = _sell(_exData, _user);
            return (wrapperAddress, destAmount, hasFee, txSaverFeeTaken);
        }

        (
            uint256 estimatedGas,
            uint256 l1GasCostInEth,
            TxSaverSignedData memory txSaverData,
            InjectedExchangeData memory injectedExchangeData
        ) = _readDataFromTransientStorage(feeType, tStorage);

        uint256 amountWithoutFee = _exData.srcAmount;

        _injectExchangeData(_exData, injectedExchangeData);

        // when taking fee from EOA/wallet perform regular sell
        // fee is taken inside the RecipeExecutor
        if (feeType == EOA_OR_WALLET_FEE_FLAG) {
            txSaverFeeTaken = false;
            (wrapperAddress, destAmount, hasFee) = _sell(_exData, _user);
            return (wrapperAddress, destAmount, hasFee, txSaverFeeTaken);
        }
        
        // when taking fee from position, take tx cost before regular sell
        _takeTxSaverFee(_exData, txSaverData, estimatedGas, l1GasCostInEth);
        txSaverFeeTaken = true;
    
        // perform regular sell
        (wrapperAddress, destAmount, hasFee) = _sell(_exData, _user);
    
        // revert back exData changes to keep it consistent
        _exData.srcAmount = amountWithoutFee;
    }

    function _injectExchangeData(ExchangeData memory _exData, InjectedExchangeData memory _injectedExchangeData) internal pure {
        // if offchain order data is present, inject it here
        if (_injectedExchangeData.offchainData.price > 0) {
            _exData.offchainData = _injectedExchangeData.offchainData;
        }

        // if onchain order data is present, inject it here 
        if (_injectedExchangeData.wrapper != address(0)) {
            _exData.wrapper = _injectedExchangeData.wrapper;
            _exData.wrapperData = _injectedExchangeData.wrapperData;
        }
    }

    function _readDataFromTransientStorage(uint256 _feeType, ITxSaverBytesTransientStorage _tStorage) 
        internal view returns (
            uint256 estimatedGas,
            uint256 l1GasCostInEth,
            TxSaverSignedData memory txSaverData,
            InjectedExchangeData memory injectedExchangeData
        ) 
    {
        if (_feeType == EOA_OR_WALLET_FEE_FLAG) {
            (estimatedGas, l1GasCostInEth, injectedExchangeData) = abi.decode(
                _tStorage.getBytesTransiently(),
                (uint256, uint256, InjectedExchangeData)
            );
        } else {
            (estimatedGas, l1GasCostInEth, txSaverData, injectedExchangeData) = abi.decode(
                _tStorage.getBytesTransiently(),
                (uint256, uint256, TxSaverSignedData, InjectedExchangeData)
            );
        }
    }

    function _takeTxSaverFee(
        ExchangeData memory _exData,
        TxSaverSignedData memory _txSaverData,
        uint256 _estimatedGas,
        uint256 _l1GasCostInEth
    ) internal {
        // when sending sponsored tx, no tx cost is taken
        if (_estimatedGas == 0) return;

        // calculate gas cost in src token
        uint256 txCostInSrcToken = calcGasCostUsingInjectedPrice(
            _estimatedGas,
            _exData.srcAddr,
            _txSaverData.tokenPriceInEth,
            _l1GasCostInEth
        );

        // revert if tx cost is higher than max value set by user
        if (txCostInSrcToken > _txSaverData.maxTxCostInFeeToken) {
            revert TxCostInFeeTokenTooHighError(_txSaverData.maxTxCostInFeeToken, txCostInSrcToken);
        }
        if (_exData.srcAddr != _txSaverData.feeToken){
            revert FeeTokenNotSameAsSrcToken(_exData.srcAddr, _txSaverData.feeToken);
        }

        // subtract tx cost from src amount and send it to fee recipient
        _exData.srcAmount = sub(_exData.srcAmount, txCostInSrcToken);
        _exData.srcAddr.withdrawTokens(TX_SAVER_FEE_RECIPIENT, txCostInSrcToken);
    }
}









/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC-1967 implementation slot:
 * ```solidity
 * contract ERC1967 {
 *     // Define the slot. Alternatively, use the SlotDerivation library to derive the slot.
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(newImplementation.code.length > 0);
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * Since version 5.1, this library also support writing and reading value types to and from transient storage.
 *
 *  * Example using transient storage:
 * ```solidity
 * contract Lock {
 *     // Define the slot. Alternatively, use the SlotDerivation library to derive the slot.
 *     bytes32 internal constant _LOCK_SLOT = 0xf4678858b2b588224636b8522b729e7722d32fc491da849ed75b3fdf3c84f542;
 *
 *     modifier locked() {
 *         require(!_LOCK_SLOT.asBoolean().tload());
 *
 *         _LOCK_SLOT.asBoolean().tstore(true);
 *         _;
 *         _LOCK_SLOT.asBoolean().tstore(false);
 *     }
 * }
 * ```
 *
 * TIP: Consider using this library along with {SlotDerivation}.
 */
library StorageSlot {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    struct Int256Slot {
        int256 value;
    }

    struct StringSlot {
        string value;
    }

    struct BytesSlot {
        bytes value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Int256Slot` with member `value` located at `slot`.
     */
    function getInt256Slot(bytes32 slot) internal pure returns (Int256Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` with member `value` located at `slot`.
     */
    function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
     */
    function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := store.slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` with member `value` located at `slot`.
     */
    function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
     */
    function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := store.slot
        }
    }

    /**
     * @dev UDVT that represent a slot holding a address.
     */
    type AddressSlotType is bytes32;

    /**
     * @dev Cast an arbitrary slot to a AddressSlotType.
     */
    function asAddress(bytes32 slot) internal pure returns (AddressSlotType) {
        return AddressSlotType.wrap(slot);
    }

    /**
     * @dev UDVT that represent a slot holding a bool.
     */
    type BooleanSlotType is bytes32;

    /**
     * @dev Cast an arbitrary slot to a BooleanSlotType.
     */
    function asBoolean(bytes32 slot) internal pure returns (BooleanSlotType) {
        return BooleanSlotType.wrap(slot);
    }

    /**
     * @dev UDVT that represent a slot holding a bytes32.
     */
    type Bytes32SlotType is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Bytes32SlotType.
     */
    function asBytes32(bytes32 slot) internal pure returns (Bytes32SlotType) {
        return Bytes32SlotType.wrap(slot);
    }

    /**
     * @dev UDVT that represent a slot holding a uint256.
     */
    type Uint256SlotType is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Uint256SlotType.
     */
    function asUint256(bytes32 slot) internal pure returns (Uint256SlotType) {
        return Uint256SlotType.wrap(slot);
    }

    /**
     * @dev UDVT that represent a slot holding a int256.
     */
    type Int256SlotType is bytes32;

    /**
     * @dev Cast an arbitrary slot to a Int256SlotType.
     */
    function asInt256(bytes32 slot) internal pure returns (Int256SlotType) {
        return Int256SlotType.wrap(slot);
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(AddressSlotType slot) internal view returns (address value) {
        /// @solidity memory-safe-assembly
        assembly {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(AddressSlotType slot, address value) internal {
        /// @solidity memory-safe-assembly
        assembly {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(BooleanSlotType slot) internal view returns (bool value) {
        /// @solidity memory-safe-assembly
        assembly {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(BooleanSlotType slot, bool value) internal {
        /// @solidity memory-safe-assembly
        assembly {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Bytes32SlotType slot) internal view returns (bytes32 value) {
        /// @solidity memory-safe-assembly
        assembly {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Bytes32SlotType slot, bytes32 value) internal {
        /// @solidity memory-safe-assembly
        assembly {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Uint256SlotType slot) internal view returns (uint256 value) {
        /// @solidity memory-safe-assembly
        assembly {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Uint256SlotType slot, uint256 value) internal {
        /// @solidity memory-safe-assembly
        assembly {
            tstore(slot, value)
        }
    }

    /**
     * @dev Load the value held at location `slot` in transient storage.
     */
    function tload(Int256SlotType slot) internal view returns (int256 value) {
        /// @solidity memory-safe-assembly
        assembly {
            value := tload(slot)
        }
    }

    /**
     * @dev Store `value` at location `slot` in transient storage.
     */
    function tstore(Int256SlotType slot, int256 value) internal {
        /// @solidity memory-safe-assembly
        assembly {
            tstore(slot, value)
        }
    }
}







/**
 * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuardTransient.sol
 *
 * @dev Variant of {ReentrancyGuard} that uses transient storage.
 *
 * NOTE: This variant only works on networks where EIP-1153 is available.
 */
abstract contract ReentrancyGuardTransient {
    using StorageSlot for *;

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.ReentrancyGuard")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant REENTRANCY_GUARD_STORAGE =
        0x9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f00;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if (_reentrancyGuardEntered()) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        REENTRANCY_GUARD_STORAGE.asBoolean().tstore(true);
    }

    function _nonReentrantAfter() private {
        REENTRANCY_GUARD_STORAGE.asBoolean().tstore(false);
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return REENTRANCY_GUARD_STORAGE.asBoolean().tload();
    }
}



















contract LlamaLendSwapper is 
    LlamaLendHelper,
    DFSExchangeWithTxSaver,
    AdminAuth,
    ActionsUtilHelper,
    GasFeeHelper,
    ReentrancyGuardTransient
{
    using SafeERC20 for IERC20;
    using TokenUtils for address;

    /// @dev Divider for automation fee, 5 bps
    uint256 internal constant AUTOMATION_DFS_FEE = 2000;

    struct CallbackData {
        uint256 stablecoins;
        uint256 collateral;
    }

    ///@dev called by llamalend controller after repay_extended
    ///@dev sends all collateral the user has to this contract, we swap a part or all of it
    ///@dev after swapping, llamalend will either recreate the position or close it fully
    function callback_repay(
        address _user,
        uint256,
        uint256,
        uint256,
        uint256[] memory info
    ) external nonReentrant returns (CallbackData memory cb) {
        uint256 gasUsed = info[0];
        if (!isControllerValid(msg.sender, info[1])) revert InvalidLlamaLendController();

        ExchangeData memory exData = abi.decode(transientStorage.getBytesTransiently(), (DFSExchangeData.ExchangeData));
        address collToken = exData.srcAddr;
        address debtToken = exData.destAddr;

        (, uint256 receivedAmount, bool hasFee, bool txSaverFeeTaken) = _sellWithTxSaverChoice(
            exData,
            _user,
            DFSRegistry(REGISTRY_ADDR)
        );
        
        // can't take both automation fee and TxSaver fee
        if (gasUsed > 0 && !txSaverFeeTaken){
            receivedAmount -= _takeAutomationFee(receivedAmount, debtToken, gasUsed, hasFee);
        }

        // if receivedAmount > current debt, leftover coll will be returned and receivedAmount-currentDebt will be returned
        // if receivedAmount < current debt, new position will be created with leftover coll and currentDebt-receivedAmount
        cb.stablecoins = receivedAmount;
        cb.collateral = collToken.getBalance(address(this));

        // approve the controller to create new position
        IERC20(collToken).safeApprove(msg.sender, cb.collateral);
        IERC20(debtToken).safeApprove(msg.sender, cb.stablecoins);
    }

    ///@dev called by llamalend controller after create_loan_extended and borrow_more_extended
    ///@dev sends exData.srcAmount of debt token to this contract for us to sell then pulls received coll token
    function callback_deposit(
        address _user,
        uint256,
        uint256,
        uint256,
        uint256[] memory info
    ) external nonReentrant returns (CallbackData memory cb) {
        uint256 gasUsed = info[0];
        if (!isControllerValid(msg.sender, info[1])) revert InvalidLlamaLendController();
        ExchangeData memory exData = abi.decode(transientStorage.getBytesTransiently(), (DFSExchangeData.ExchangeData));

        address collToken = exData.destAddr;

        (, uint256 receivedAmount, bool hasFee, bool txSaverFeeTaken) = _sellWithTxSaverChoice(
            exData,
            _user,
            DFSRegistry(REGISTRY_ADDR)
        );

        // can't take both automation fee and TxSaver fee
        if (gasUsed > 0 && !txSaverFeeTaken){
            receivedAmount -= _takeAutomationFee(receivedAmount, collToken, gasUsed, hasFee);
        }

        cb.collateral = receivedAmount;

        // approve the controller to create new position
        IERC20(collToken).safeApprove(msg.sender, cb.collateral);
    }

    ///@dev called by llamalend controller after liquidate_extended
    ///@dev if users debtTokenCollateralAmount is higher than debt, this won'te be called at all
    ///@dev this will send all marketCollateralAmount from users position to this contract, which we can sell all or a part of it
    function callback_liquidate(
        address _user,
        uint256,
        uint256,
        uint256,
        uint256[] memory info
    ) external nonReentrant returns (CallbackData memory cb) {
        uint256 gasUsed = info[0];
        if (!isControllerValid(msg.sender, info[1])) revert InvalidLlamaLendController();
        bool sellMax = info[2] > 0;
        ExchangeData memory exData = abi.decode(transientStorage.getBytesTransiently(), (DFSExchangeData.ExchangeData));
        
        address collToken = exData.srcAddr;
        address debtToken = exData.destAddr;
        if (sellMax) {
            exData.srcAmount = collToken.getBalance(address(this));
        }

        (, uint256 receivedAmount, bool hasFee, bool txSaverFeeTaken) = _sellWithTxSaverChoice(
            exData,
            _user,
            DFSRegistry(REGISTRY_ADDR)
        );

        // can't take both automation fee and TxSaver fee
        if (gasUsed > 0 && !txSaverFeeTaken) {
            receivedAmount -= _takeAutomationFee(receivedAmount, debtToken, gasUsed, hasFee);
        }

        cb.stablecoins = receivedAmount;
        cb.collateral = collToken.getBalance(address(this));

        IERC20(collToken).safeApprove(msg.sender, cb.collateral);
        IERC20(debtToken).safeApprove(msg.sender, cb.stablecoins);
    }

    /// @dev No funds should be stored on this contract, but if anything is left send back to the user
    function withdrawAll(address _controllerAddress) external nonReentrant {
        address collToken = ILlamaLendController(_controllerAddress).collateral_token();
        address debtToken = ILlamaLendController(_controllerAddress).borrowed_token();

        debtToken.withdrawTokens(msg.sender, type(uint256).max);
        collToken.withdrawTokens(msg.sender, type(uint256).max);
    }

    function _takeAutomationFee(
        uint256 _destTokenAmount,
        address _token,
        uint256 _gasUsed,
        bool hasFee
    ) internal returns (uint256 feeAmount) {
        // we need to take the fee for tx cost as well, as it's in a strategy
        feeAmount += calcGasCost(_gasUsed, _token, 0);
        
        // gas fee can't go over 20% of the whole amount
        if (feeAmount > (_destTokenAmount / 5)) {
            feeAmount = _destTokenAmount / 5;
        }
        // if user has been whitelisted we don't take 0.05% fee
        if (hasFee) {
            feeAmount += _destTokenAmount / AUTOMATION_DFS_FEE;
        }

        address walletAddr = FeeRecipient(FEE_RECIPIENT_ADDRESS).getFeeAddr();
        _token.withdrawTokens(walletAddr, feeAmount);
    }

}

