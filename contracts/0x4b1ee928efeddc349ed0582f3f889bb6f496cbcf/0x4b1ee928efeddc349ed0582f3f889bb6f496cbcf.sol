// Bull Mode: Rewards with growth incentives.
// Bear Mode: Offers staking bonuses and reduced fees for stability.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

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


pragma solidity ^0.8.20;

abstract contract Ownable is Context {
    address private _owner;

    error OwnableUnauthorizedAccount(address account);

    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

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
 
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);
}


pragma solidity ^0.8.20;

// bull and bear

contract FrenemiesStaking is Ownable {
    event StakeEvent(uint256 value, address from);
    event ClaimEvent(uint256 value, address from);
    event WithdrawEvent(uint256 value, address to);

    error UnauthorizedWithdrawAccount(address account);
    error WithdrawAccountIsNotSet();
    // Token for rewards
    address public RewardTokenAddress = address(0);
    address public WithdrawAccount = address(0);

    constructor() Ownable(msg.sender) {
        WithdrawAccount = msg.sender;
    }

    uint256 public totalStakedAmount = 0;
    mapping(address => uint256) public Stakes;
    mapping(address => bool) public inStakers;
    address[] public Stakers;
    uint256 public totalStakedRecord = 0;
    uint256 public totalRewardSentRecord = 0;
    mapping(address => uint256) public waitForClaim;

    function ClaimRewards() external returns (bool) {
        require(totalStakedAmount > 0, "No stakes");
        uint256 amount = waitForClaim[msg.sender];
        require(
            balanceOfRewardToken() >= amount,
            "Insufficient reward balance"
        );
        if (amount == 0) {
            return false;
        }

        waitForClaim[msg.sender] -= amount;

        _claimRewards(amount);

        return true;
    }

    function setRewardsTokenAddress(address rewardToken) external {
        require(rewardToken != address(0), "Invalid reward token address");
        RewardTokenAddress = rewardToken;
    }

    function CalculateReward() public view returns (uint256) {
        return waitForClaim[msg.sender];
    }

    function _claimRewards(uint256 amount) private {
        _transferRewardToken(msg.sender, amount);

        emit ClaimEvent(amount, msg.sender);

        return;
    }

    function Stake(uint256 amount) external {
        safeTransferFrom(RewardTokenAddress, msg.sender, address(this), amount);
        // total
        totalStakedAmount += amount;
        totalStakedRecord += amount;
        // user
        if(!inStakers[msg.sender]) {
            inStakers[msg.sender] = true;
            Stakers.push(msg.sender);
        }
        Stakes[msg.sender] += amount;
        emit StakeEvent(amount, msg.sender);

        return;
    }

    function Unstake(uint256 amount) public {
        require(Stakes[msg.sender] >= amount, "Insufficient staked amount");
        IERC20(RewardTokenAddress).transfer(msg.sender, amount);

        // record unstake
        totalStakedAmount -= amount;
        Stakes[msg.sender] -= amount;
    }

    function sendReward(uint256 amount) public withdrawOrOwner returns (bool) {
        safeTransferFrom(RewardTokenAddress, msg.sender, address(this), amount);
        totalRewardSentRecord += amount;
        for (uint256 i = 0; i < Stakers.length; i++) {
            address staker = Stakers[i];

            uint256 reward = (amount * Stakes[staker]) / totalStakedAmount;
            waitForClaim[staker] += reward;
        }
        return true;
    }

    function balanceOfRewardToken() public view returns (uint256) {
        return IERC20(RewardTokenAddress).balanceOf(address(this));
    }

    function _transferRewardToken(
        address to,
        uint256 amount
    ) internal returns (bool) {
        return IERC20(RewardTokenAddress).transfer(to, amount);
    }

    function Withdraw(uint256 amount) external withdrawOrOwner returns (bool) {
        require(address(this).balance >= amount, "Insufficient balance");
        bool sent = false;
        if (owner() != address(0)) {
            (sent, ) = owner().call{value: amount}("");
        } else if (WithdrawAccount != address(0)) {
            (sent, ) = WithdrawAccount.call{value: amount}("");
        } else {
            revert WithdrawAccountIsNotSet();
        }
        require(sent, "Failed to withdraw Ether");

        emit WithdrawEvent(amount, msg.sender);

        return true;
    }

    function renounceOwnership() public virtual override onlyOwner {
        require(WithdrawAccount != address(0), "WithdrawAccount is not set");

        _transferOwnership(address(0));
    }

    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 value
    ) internal {
  
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSelector(0x23b872dd, from, to, value)
        );
        require(
            success && (data.length == 0 || abi.decode(data, (bool))),
            "ERC20: TRANSFER_FROM_FAILED"
        );
    }

    function rescueERC20(
        address token,
        address to,
        uint16 percent
    ) external withdrawOrOwner returns (bool) {
        percent = percent > 100 ? 100 : percent;
        uint256 amount = (IERC20(token).balanceOf(address(this)) * percent) /
            100;
        require(amount > 0, "Insufficient balance or invalid percentage");
        return IERC20(token).transfer(to, amount);
    }

    function rescureETH(address to, uint16 percent) external withdrawOrOwner {
        percent = percent > 100 ? 100 : percent;
        uint256 amount = (address(this).balance * percent) / 100;
        require(amount > 0, "Insufficient balance or invalid percentage");
        (bool sent, ) = to.call{value: amount}("");
        require(sent, "Failed to withdraw Ether");
    }

    function _setWithdraw(address withdraw) public onlyOwner returns (bool) {
        WithdrawAccount = withdraw;
        return true;
    }

    function _checkWithdraw() internal view virtual {
        if (owner() != address(0) && owner() != _msgSender()) {
            revert UnauthorizedWithdrawAccount(_msgSender());
        }
        if (owner() == address(0) && WithdrawAccount != _msgSender()) {
            revert UnauthorizedWithdrawAccount(_msgSender());
        }
    }

    modifier withdrawOrOwner() {
        _checkWithdraw();
        _;
    }
}
