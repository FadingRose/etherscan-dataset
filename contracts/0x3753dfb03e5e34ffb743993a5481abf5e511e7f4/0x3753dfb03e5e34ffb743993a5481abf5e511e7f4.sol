// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

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

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
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
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
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

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.20;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol


pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

// File: Proximo.sol


pragma solidity ^0.8.20;





contract ProximoPresale is Ownable {
    IERC20 public token;
    IERC20Metadata public tokenMetadata;
    AggregatorV3Interface public priceFeed;
    address public sellerAddress;
    address public paymentAddress;
    address public usdtAddress;
    uint256 public presaleTokenAmount;
    bool public presaleActive = true;
    uint256 public totalSold = 0;
    uint256 public presaleEndTime;
    mapping(address => uint256) public userTokens;

    struct Stage {
        uint256 id;
        uint256 bonus;
        uint256 price;
        uint256 start;
        uint256 end;
    }
    mapping(uint256 => Stage) public stages;
    uint256 public maxStage = 4;
    uint256 currentStageId = 0;

    constructor(
        address _seller,
        address _payment,
        address _token,
        address _priceFeed,
        address _usdt
    ) Ownable(msg.sender) {
        token = IERC20(_token);
        tokenMetadata = IERC20Metadata(_token);
        sellerAddress = _seller;
        paymentAddress = _payment;
        priceFeed = AggregatorV3Interface(_priceFeed);
        usdtAddress = _usdt;
    }

    function getEthToUsdPrice() public view returns (int256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        return price;
    }

    function convertEthToUsd(uint256 ethAmount) public view returns (uint256) {
        int256 ethToUsdPrice = getEthToUsdPrice();
        uint256 usdAmount = (ethAmount * uint256(ethToUsdPrice)) /
            (10**priceFeed.decimals());
        return usdAmount;
    }

    function buyTokenWithEth(uint256 _amount) public payable {
        require(presaleActive, "Presale is not active!");
        require(_amount >= 0, "Please enter minimum token!");
        uint256 _id = getCurrentStageIdActive();
        require(_id > 0, "Stage info not available!");
        uint256 _bonus = stages[_id].bonus;
        uint256 _price = stages[_id].price;
        uint256 _start = stages[_id].start;
        uint256 _end = stages[_id].end;
        require(_start <= block.timestamp, "Presale has not started yet!");
        require(_end >= block.timestamp, "Presale end!");
        uint256 _totalPayUsd = _amount * _price;
        uint256 _ethToUsd = convertEthToUsd(1e18);
        uint256 _totalPayAmount = _totalPayUsd / _ethToUsd;
        require(msg.value >= _totalPayAmount, "Not enough payment!");
        uint256 _weiAmount = _amount * 1e18;
        uint256 _bonusAmount = (_amount * _bonus) / 100;
        _bonusAmount *= 1e18;
        uint256 _totalAmount = _weiAmount + _bonusAmount;
        uint256 _tokenDecimals = tokenMetadata.decimals();
        uint256 _subDecimals = 18 - _tokenDecimals;
        uint256 _totalTokenAmount = _totalAmount / (10**_subDecimals);
        require(
            (totalSold + _totalTokenAmount) <= presaleTokenAmount,
            "Presale token amount exceeds!"
        );

        // payment price transfer to seller address
        require(
            payable(sellerAddress).send(msg.value),
            "Failed to transfer ETH payment!"
        );

        // update user tokens
        userTokens[msg.sender] += _totalTokenAmount;
        totalSold += _totalTokenAmount;
    }

    function buyTokenWithUsdt(uint256 _amount) public {
        require(presaleActive, "Presale is not active!");
        require(_amount >= 0, "Please enter minimum token!");
        uint256 _id = getCurrentStageIdActive();
        require(_id > 0, "Stage info not available!");
        uint256 _bonus = stages[_id].bonus;
        uint256 _price = stages[_id].price;
        uint256 _start = stages[_id].start;
        uint256 _end = stages[_id].end;
        require(_start <= block.timestamp, "Presale has not started yet!");
        require(_end>= block.timestamp, "Presale end!");
        uint256 _totalPayUsd = _amount * _price;
        uint256 _usdtAmount = _totalPayUsd;
        require(
            IERC20(usdtAddress).transferFrom(
                msg.sender,
                paymentAddress,
                _usdtAmount
            ),
            "Failed to transfer USDT payment!"
        );

        // update user tokens
        uint256 _weiAmount = _amount * 1e18;
        uint256 _bonusAmount = (_amount * _bonus) / 100;
        _bonusAmount *= 1e18;
        uint256 _totalAmount = _weiAmount + _bonusAmount;
        uint256 _tokenDecimals = tokenMetadata.decimals();
        uint256 _subDecimals = 18 - _tokenDecimals;
        uint256 _totalTokenAmount = _totalAmount / (10**_subDecimals);
        require(
            (totalSold + _totalTokenAmount) <= presaleTokenAmount,
            "Presale token amount exceeds!"
        );

        userTokens[msg.sender] += _totalTokenAmount;
        totalSold += _totalTokenAmount;
    }

    function setToken(address _token) public onlyOwner {
        token = IERC20(_token);
        tokenMetadata = IERC20Metadata(_token);
    }

    function setPriceFeed(address _priceFeed) public onlyOwner {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function setSellerAddress(address _seller) public onlyOwner {
        sellerAddress = _seller;
    }

    function setPaymentAddress(address _payment) public onlyOwner {
        paymentAddress = _payment;
    }

    function setPresaleTokenAmount(uint256 _amount) public onlyOwner {
        presaleTokenAmount = _amount;
    }

    function flipPresaleActive() public onlyOwner {
        presaleActive =!presaleActive;
    }

    function setMaxStage(uint256 _maxStage) public onlyOwner {
        maxStage = _maxStage;
    }

    function addStage(
        uint256 _id,
        uint256 _bonus,
        uint256 _price,
        uint256 _start,
        uint256 _end
    ) public onlyOwner {
        stages[_id] = Stage(_id, _bonus, _price, _start, _end);
    }

    function setStage(
        uint256 _id,
        uint256 _bonus,
        uint256 _price,
        uint256 _start,
        uint256 _end
    ) public onlyOwner {
        stages[_id] = Stage(_id, _bonus, _price, _start, _end);
    }

    function getCurrentStageIdActive() public view returns (uint256) {
        for (uint256 i = maxStage; i > 0; i--) {
            if (stages[i].start <= block.timestamp && stages[i].end >= block.timestamp) {
                return i;
            }
        }
        return 0;
    }

    function setEmptyTotalSold() public onlyOwner {
        totalSold = 0;
    }

    function withdrawFunds() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function getUserTokens(address _user) public view returns (uint256) {
        return userTokens[_user];
    }

    function setPresaleEndTime(uint256 _endTime) public onlyOwner {
        presaleEndTime = _endTime;
    }
}
