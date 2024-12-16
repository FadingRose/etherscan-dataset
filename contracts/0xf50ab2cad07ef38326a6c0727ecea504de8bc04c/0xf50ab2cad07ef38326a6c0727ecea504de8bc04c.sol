// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.6

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

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
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
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
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}


// File @openzeppelin/contracts/utils/Counters.sol@v4.9.6

// OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)

pragma solidity ^0.8.0;

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 */
library Counters {
    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
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


// File contracts/Vesting.sol

//SPDX-License-Identifier: LicenseRef-LICENSE
pragma solidity ^0.8.9;


contract Vesting {
    using Counters for Counters.Counter;

    struct VestingPool {
        uint32 period; // in seconds
        uint32 cliff; // unix timestamp
        uint16 periodBP; // in bp
        uint16 releasedBP; // in bp
        uint16 firstReleaseInBP; // in bp
        uint amount; // total amount
        address user;
        IERC20 token;
    }

    Counters.Counter public _vestingPoolIdTracker;
    mapping (uint => VestingPool) public vestingPools;
    mapping (address => uint[]) public vestingIds;
    uint public totalVestedTokenAmount;
    bool public isVestingActive;
    address public owner;

    constructor() {
        owner = msg.sender;
        isVestingActive = true;
    }

    event LockToken (uint32 period, uint32 cliff, uint16 periodBP, uint16 firstReleaseInBP, uint amount, address user, address token);
    modifier onlyOwner(uint vestingPoolId) {
        VestingPool memory vestingPool = vestingPools[vestingPoolId];
        require(msg.sender == vestingPool.user, 'VS:100'); //Vesting: only owner is allowed to withdraw
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == owner, 'Only Admin');
        _;
    }

    function getCorrectAmount(IERC20 token, uint _amount) internal returns (uint) {
        uint beforeBalance = token.balanceOf(address(this));
        require(token.transferFrom(msg.sender, address(this), _amount), 'VS:101');
        uint afterBalance = token.balanceOf(address(this));

        return afterBalance - beforeBalance;
    }

    function getPercent(uint amount, uint bp) internal pure returns (uint) {
        require(bp <= 10000, 'VS:102'); //Vesting: BP must be <= 10000
        return (amount * bp) / 10000;
    }

    function getAdjustedAmount(uint totalAmount, uint amount) internal pure returns (uint, uint) {
        uint approxBp = (amount * 10000) / totalAmount;
        uint correctedAmount = getPercent(totalAmount, approxBp);

        return (approxBp, correctedAmount);
    }

    function availableToWithdraw(VestingPool memory vestingPool) public view returns (uint, uint) {

        if(block.timestamp <= uint(vestingPool.cliff)) return (0, 0);

        uint availableAmountInBP = (
            (
                ((block.timestamp - uint(vestingPool.cliff)) / uint(vestingPool.period)) * uint(vestingPool.periodBP)
            ) + uint(vestingPool.firstReleaseInBP)
        ) - uint(vestingPool.releasedBP);

        if (availableAmountInBP + vestingPool.releasedBP > 10000) {
            availableAmountInBP = 10000 - vestingPool.releasedBP;
        }

        uint availableAmountInToken = getPercent(vestingPool.amount, availableAmountInBP);

        return (availableAmountInBP, availableAmountInToken);
    }

    function create(uint32 period, uint32 cliff, uint16 periodBP, uint16 firstReleaseInBP, uint amount, address user, address _token) public returns (uint) {
        //        require(block.timestamp <= uint(cliff), 'Vesting: cliff cannot be in past');
        require(isVestingActive, 'InActive');
        require(10000 >= uint(firstReleaseInBP) && 0 <= uint(firstReleaseInBP), 'VS:103'); //'Vesting: First release cannot be more then 100% and less then 0%'
        require(10000 >= uint(periodBP) && 0 <= uint(periodBP), 'VS:104'); //'Vesting: Period amount release cannot be more then 100% and less then to 0%'

        IERC20 token = IERC20(_token);

        uint vestingPoolIdToAssign = _vestingPoolIdTracker.current();
        _vestingPoolIdTracker.increment();

        VestingPool storage vestingPool = vestingPools[vestingPoolIdToAssign];
        vestingPool.amount = getCorrectAmount(token, amount); // To support fee enabled tokens
        vestingPool.user = user;
        vestingPool.cliff = cliff;
        vestingPool.period = period;
        vestingPool.periodBP = periodBP;
        vestingPool.token = token;
        vestingPool.firstReleaseInBP = firstReleaseInBP;

        if (firstReleaseInBP > 0) {
            uint tokensToRelease = getPercent(amount, firstReleaseInBP);
            require(token.transfer(user, tokensToRelease), 'VS:101'); //Vesting: Token transfer failed
            vestingPool.releasedBP = firstReleaseInBP;
        }

        _withdraw(vestingPoolIdToAssign);
        // store all vesting pool ids against user address
        vestingIds[user].push(vestingPoolIdToAssign);
        totalVestedTokenAmount += amount;
        emit LockToken(period, cliff, periodBP, firstReleaseInBP, amount, user, _token);
        return vestingPoolIdToAssign;
    }

    function _withdraw(uint vestingPoolId) internal {
        (uint availableAmountInBP, uint availableAmountInToken) = availableToWithdraw(vestingPools[vestingPoolId]);
        VestingPool storage vestingPool = vestingPools[vestingPoolId];
        if (availableAmountInBP > 0) {
            require(vestingPool.token.transfer(vestingPool.user, availableAmountInToken), 'VS:101'); //'Vesting: Token transfer failed'
            vestingPool.releasedBP += uint16(availableAmountInBP);
        }
    }

    function withdraw(uint vestingPoolId) public onlyOwner(vestingPoolId) {
        _withdraw(vestingPoolId);
    }

    // Fallback
    function withdrawWithSpecificAmount(uint vestingPoolId, uint amount) public onlyOwner(vestingPoolId) {
        (, uint availableAmountInToken) = availableToWithdraw(vestingPools[vestingPoolId]);

        require(amount <= availableAmountInToken, 'Vesting: wut?');

        VestingPool storage vestingPool = vestingPools[vestingPoolId];

        (uint approxBP, uint correctedAmount) = getAdjustedAmount(vestingPool.amount, amount);

        require(vestingPool.token.transfer(msg.sender, correctedAmount), 'VS:101'); //'Vesting: Token transfer failed'
        vestingPool.releasedBP += uint16(approxBP);
    }

    function getUserVestingPoolIds (address _user) external view returns (uint[] memory) {
        return vestingIds[_user];
    }

    function toggleVestingStatus() external onlyAdmin {
        isVestingActive = !isVestingActive;
    }

}
