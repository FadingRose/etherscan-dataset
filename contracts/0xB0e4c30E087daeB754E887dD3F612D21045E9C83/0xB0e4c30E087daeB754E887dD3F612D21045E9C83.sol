// SPDX-License-Identifier: MIT
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

// File: @openzeppelin/contracts/utils/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/ReentrancyGuard.sol)

pragma solidity ^0.8.20;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

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
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}

// File: LikeBit/PreSale.sol


pragma solidity ^0.8.20;





interface IUSDTToken {
    function transferFrom(address from, address to, uint256 value) external;
}

/**
 * @title PreSale
 * @dev Contract for managing pre-sale of LikeBit tokens.
 */
contract PreSale is Ownable, ReentrancyGuard {
    IERC20 private usdt;
    IERC20 private LBT;
    uint private totalTokenSold;
    uint private totalTokenRemaining;
    uint private activePhaseId;
    uint public totalPhases;
    address private adminWallet;

    struct Phase {
        uint phaseId;
        uint tokenAvailableForSale;
        uint tokenPrice;
        uint tokenSold;
        uint soldTokenValue;
        bool airdrop;
        bool buying;
    }

    struct TokenPurchase {
        uint usdtDeposited;
        uint tokensBought;
        uint tokenPrice;
        uint phaseId;
        uint date;
        bool claimed;
    }

    mapping(address => uint) private usdtReceived;
    mapping(address => mapping(uint => uint)) private tokenToSend;
    mapping(uint => Phase) private phases;
    mapping(address => TokenPurchase[]) private tokenPurchase;
    mapping(address => bool) private blacklisted;

    modifier notBlacklisted() {
        require(
            !blacklisted[msg.sender],
            "Address is blacklisted. Contact Admin"
        );
        _;
    }

    event ClaimedTokens(
        address indexed _user,
        uint usdtDeposited,
        uint tokenAmount,
        uint tokenPrice,
        uint PhaseID
    );

    event NewPhaseSet(
        uint PhaseID,
        uint tokenAvailableForSell,
        uint tokenPrice
    );

    event Buy(
        address indexed _user,
        uint usdtDeposited,
        uint tokenAmount,
        uint tokenPrice,
        uint PhaseID
    );

    /**
     * @dev Constructor to initialize the pre-sale contract.
     * @param _usdt Address of the USDT token contract.
     * @param _admin Address of the admin wallet.
     */

    constructor(address _usdt, address _admin) Ownable(_admin) {
        usdt = IERC20(_usdt);
        totalTokenSold = 0;
        totalTokenRemaining = 2000000 * 10 ** 18;
        adminWallet = _admin;
        phases[1] = Phase({
            phaseId: 1,
            tokenAvailableForSale: 500000 * 10 ** 18,
            tokenPrice: 1250000,
            tokenSold: 0,
            soldTokenValue: 0,
            airdrop: false,
            buying: true
        });
        activePhaseId = 1;
        totalPhases++;
    }

    //View Functions

    /**
     * @dev Returns the address of the USDT token contract.
     */

    function getUsdtAddress() external view returns (address) {
        return address(usdt);
    }
    /**
     * @dev Returns the address of the LikeBit token contract.
     */

    function getTokenAddress() external view returns (address) {
        return address(LBT);
    }
    /**
     * @dev Returns the current token price for the active phase.
     */
    function getTokenPrice() public view returns (uint) {
        return phases[activePhaseId].tokenPrice;
    }

    /**
     * @dev Returns the address of the admin wallet.
     */

    function getAdminAddress() external view returns (address) {
        return adminWallet;
    }

    /**
     * @dev Returns the ID of the active sale phase.
     */

    function getActivePhase() external view returns (uint) {
        return activePhaseId;
    }

    /**
     * @dev Returns the total number of tokens sold.
     */
    function getTotalTokenSold() external view returns (uint) {
        return totalTokenSold;
    }

    function getOwner() external view returns (address) {
        return owner();
    }

    /**
     * @dev Checks if an address is blacklisted.
     * @param _user Address to check.
     * @return True if the address is blacklisted, otherwise false.
     */
    function isBlacklisted(address _user) external view returns (bool) {
        return blacklisted[_user];
    }

    /**
     * @dev Returns details of the purchases made by a user.
     * @param _user Address of the user.
     * @return tokensBought Array of token amounts bought.
     * @return phaseId Array of phase IDs for each purchase.
     * @return date Array of purchase dates.
     * @return claimed Array indicating whether tokens are claimed for each purchase.
     */

    function getUserPurchaseDetails(
        address _user
    )
        external
        view
        returns (
            uint[] memory tokensBought,
            uint[] memory phaseId,
            uint[] memory date,
            bool[] memory claimed
        )
    {
        TokenPurchase[] storage purchase = tokenPurchase[_user];
        uint length = purchase.length;
        tokensBought = new uint[](length);
        phaseId = new uint[](length);
        date = new uint[](length);
        claimed = new bool[](length);

        for (uint i = 0; i < length; i++) {
            tokensBought[i] = purchase[i].tokensBought;
            phaseId[i] = purchase[i].phaseId;
            date[i] = purchase[i].date;
            claimed[i] = purchase[i].claimed;
        }
        return (tokensBought, phaseId, date, claimed);
    }

    /**
     * @dev Checks if airdrop is active for a given phase.
     * @param _phaseId ID of the phase to check.
     * @return True if airdrop is active for the phase, otherwise false.
     */
    function isAirdropActive(uint _phaseId) external view returns (bool) {
        require(_phaseId > 0 && _phaseId <= totalPhases, "Invalid phase ID");
        Phase storage phase = phases[_phaseId];
        return phase.airdrop;
    }

    /**
     * @dev Checks if buying is active for a given phase.
     * @param _phaseId ID of the phase to check.
     * @return True if buying is active for the phase, otherwise false.
     */

    function isBuyActive(uint _phaseId) external view returns (bool) {
        require(_phaseId > 0 && _phaseId <= totalPhases, "Invalid phase ID");
        Phase storage phase = phases[_phaseId];
        return phase.buying;
    }

    /**
     * @dev Returns information about a sale phase.
     * @param _phaseId ID of the phase.
     * @return phaseId Phase ID.
     * @return _tokenAvailableForSale Total tokens available for sale.
     * @return _tokenPrice Token price.
     * @return _tokenSold Total tokens sold.
     * @return _soldTokenValue Total value of tokens sold.
     * @return _tokenRemaining Remaining tokens for sale in the phase.
     * @return isActivePhase True if the phase is active, otherwise false.
     * @return airdrop True if airdrop is active for the phase, otherwise false.
     * @return buying True if buying is active for the phase, otherwise false.
     */
    function getPhaseInfo(
        uint _phaseId
    )
        public
        view
        returns (
            uint phaseId,
            uint _tokenAvailableForSale,
            uint _tokenPrice,
            uint _tokenSold,
            uint _soldTokenValue,
            uint _tokenRemaining,
            bool isActivePhase,
            bool airdrop,
            bool buying
        )
    {
        require(_phaseId > 0);
        Phase storage phase = phases[_phaseId];
        return (
            phase.phaseId,
            phase.tokenAvailableForSale,
            phase.tokenPrice,
            phase.tokenSold,
            phase.soldTokenValue,
            phase.tokenAvailableForSale - phase.tokenSold,
            activePhaseId == phase.phaseId,
            phase.airdrop,
            phase.buying
        );
    }

    function addToBlacklist(address _user) external onlyOwner {
        require(_user != address(0), "Invalid address");
        blacklisted[_user] = true;
    }

    function removeFromBlacklist(address _user) external onlyOwner {
        blacklisted[_user] = false;
    }

    /**
     * @dev Sets a new sale phase with the given parameters.
     * @param _amount Amount of tokens available for sale in the new phase.
     * @param _tokenPrice Price of one token in the new phase.
     */

    function setPhase(uint _amount, uint _tokenPrice) external onlyOwner {
        uint _phaseId = totalPhases + 1;
        require(_amount > 0, "Amount cannot be zero");
        require(
            _amount <= totalTokenRemaining,
            "Amount cannot exceed sale allocation"
        );
        require(_tokenPrice > 0, "token price cannot be zero");

        Phase storage newPhase = phases[_phaseId];
        newPhase.phaseId = _phaseId;
        newPhase.tokenAvailableForSale = _amount;
        newPhase.tokenPrice = _tokenPrice;
        newPhase.tokenSold = 0;
        newPhase.soldTokenValue = 0;
        newPhase.airdrop = false;
        newPhase.buying = false;
        totalPhases++;

        emit NewPhaseSet(_phaseId, _amount, _tokenPrice);
    }

    function stopBuy(uint _phaseId) external onlyOwner {
        require(_phaseId > 0 && _phaseId <= totalPhases, "Invalid phase ID");
        Phase storage phase = phases[_phaseId];
        require(phase.phaseId == _phaseId, "Phase does not exist");
        require(phase.buying == true, "Buy not active");
        phase.buying = false;
    }

    function startBuy(uint _phaseId) external onlyOwner {
        require(_phaseId > 0 && _phaseId <= totalPhases, "Invalid phase ID");
        Phase storage phase = phases[_phaseId];
        require(phase.phaseId == _phaseId, "Phase does not exist");
        require(phase.buying == false, "Buy already active");
        phase.buying = true;
    }

    function estimatedToken(
        uint _usdtAmount
    ) public view returns (uint tokenAmount) {
        tokenAmount = (_usdtAmount * 10 ** 18) / getTokenPrice();
    }

    function getUSDTDepositedByUser(
        address _user
    ) external view returns (uint) {
        return usdtReceived[_user];
    }

    function getTokenToSendToUser(address _user) external view returns (uint) {
        return tokenToSend[_user][activePhaseId];
    }

    function setTokenAddress(address _LBT) external onlyOwner {
        require(_LBT != address(0), "Address cannot be zero address");
        require(
            IERC20(_LBT).balanceOf(address(this)) > 0,
            "Invalid LBT contract"
        );
        LBT = IERC20(_LBT);
    }

    function setActivePhase(uint _phaseId) external onlyOwner {
        require(_phaseId > 0 && totalPhases >= _phaseId, "Inavlid phase id");
        require(_phaseId != activePhaseId, "Phase already active");
        activePhaseId = _phaseId;
    }

    function setAdminWallet(address _admin) external onlyOwner {
        require(_admin != address(0), "Address cannot be zero address");
        adminWallet = _admin;
    }

    /**
     * @dev Starts the airdrop for the specified phase.
     * @param _phaseId ID of the phase to start the airdrop for.
     */

    function startAirDrop(uint _phaseId) external onlyOwner {
        require(_phaseId > 0 && _phaseId <= totalPhases, "Invalid phase ID");
        Phase storage phase = phases[_phaseId];
        require(phase.phaseId == _phaseId, "Phase id does not exist");
        require(phase.airdrop == false, "Air drop already active");
        phase.airdrop = true;
    }

    /**
     * @dev Stops the airdrop for the specified phase.
     * @param _phaseId ID of the phase to stop the airdrop for.
     */
    function stopAirDrop(uint _phaseId) external onlyOwner {
        require(_phaseId > 0 && _phaseId <= totalPhases, "Invalid phase ID");
        Phase storage phase = phases[_phaseId];
        require(phase.phaseId == _phaseId, "Phase id does not exist");
        require(phase.airdrop == true, "Air drop not active");
        phase.airdrop = false;
    }

    //User Functions
    /**
     * @dev Allows a user to buy tokens with USDT.
     * @param _usdtAmount Amount of USDT to spend for buying tokens.
     */
    function buy(uint _usdtAmount) external nonReentrant notBlacklisted {
        require(_usdtAmount > 0, "Invalid Amount");//1
        require(
            usdt.allowance(msg.sender, address(this)) >= _usdtAmount,
            "Insufficient Allowance"
        );//10
        require(
            usdt.balanceOf(msg.sender) >= _usdtAmount,
            "Not enough balance"
        );//

        Phase storage currentPhase = phases[activePhaseId];
        require(
            currentPhase.buying == true,
            "Buying not active for this phase"
        );
        uint tokenAmount = ((_usdtAmount * (10 ** 18)) /
            currentPhase.tokenPrice);//0.8 //

        require(
            tokenAmount <=
                currentPhase.tokenAvailableForSale - currentPhase.tokenSold,
            "Not enough token amount for buying"
        );

        currentPhase.tokenSold += tokenAmount;//0.8
        currentPhase.soldTokenValue =
            (currentPhase.tokenPrice * currentPhase.tokenSold) /
            10 ** 18;
        totalTokenSold += tokenAmount; //0.8
        totalTokenRemaining -= tokenAmount; 

        usdtReceived[msg.sender] += _usdtAmount;
        tokenToSend[msg.sender][activePhaseId] += tokenAmount;

        IUSDTToken(address(usdt)).transferFrom(msg.sender, adminWallet, _usdtAmount);

        TokenPurchase[] storage purchase = tokenPurchase[msg.sender];
        purchase.push(
            TokenPurchase({
                usdtDeposited: _usdtAmount,
                tokensBought: tokenAmount,
                tokenPrice: currentPhase.tokenPrice,
                phaseId: activePhaseId,
                date: block.timestamp,
                claimed: false
            })
        );

        emit Buy(
            msg.sender,
            _usdtAmount,
            tokenAmount,
            currentPhase.tokenPrice,
            activePhaseId
        );
    }

    /**
     * @dev Allows a user to claim tokens from an ongoing airdrop.
     * @param _phaseId ID of the phase from which tokens are claimed.
     * @param _index Index of the token purchase to claim from the user's purchase history.
     */

    function claimToken(
        uint _phaseId,
        uint _index
    ) external nonReentrant notBlacklisted {
        require(_phaseId > 0 && totalPhases >= _phaseId, "Inavlid phase id");
        Phase storage phase = phases[_phaseId];
        require(phase.airdrop, "Airdrop not started");
        TokenPurchase[] storage purchase = tokenPurchase[msg.sender];
        uint totalTokensClaimed;

        require(_index < purchase.length, "Invalid index");

        for (uint i = _index; i < purchase.length; i++) {
            if (purchase[i].phaseId == _phaseId && !purchase[i].claimed) {
                uint tokensToClaim = purchase[i].tokensBought;
                LBT.transfer(msg.sender, tokensToClaim);
                purchase[i].claimed = true;
                totalTokensClaimed += tokensToClaim;
                emit ClaimedTokens(
                    msg.sender,
                    purchase[i].usdtDeposited,
                    tokensToClaim,
                    purchase[i].tokenPrice,
                    _phaseId
                );
                return;
            }
        }
        require(totalTokensClaimed > 0, "No tokens to claim in this phase");
    }

    /**
     * @dev Function to withdraw mistakenly sent ERC20 tokens.
     * @param _token Address of the ERC20 token to withdraw.
     */

    function withdrawTokens(address _token, uint amount) external onlyOwner {
        require(_token != address(0), "Invalid token address");
        require(IERC20(_token).balanceOf(address(this)) >= amount, "Insufficient token balance");
        IERC20(_token).transfer(
            msg.sender,
            amount
        );
    }
}
