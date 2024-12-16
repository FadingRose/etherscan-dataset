// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function mint(uint256 amount) external;

    function mint(address to, uint256 amount) external;

    function burn(uint256 amount) external;
}

abstract contract Initializable {
    /*
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /*
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /*
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(
            _initializing || !_initialized,
            "Initializable: contract is already initialized"
        );

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }
}

contract Ownable is Initializable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /*
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init_unchained() internal initializer {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /*
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /*
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /*
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /*
     * @dev Leaves the contract without owner. It will not be possible to call
     * onlyOwner functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /*
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /*
     * @dev Transfers ownership of the contract to a new account (newOwner).
     */
    function _transferOwnership(address newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract MinterContract is Initializable, Ownable {
    address public luca;

    uint256 public limitAmount;
    address public executor;
    mapping(uint256 => uint256) public mintedAmount;
    event UpdateExecutor(address _executor);
    event UpdateLimit(uint256 _limitAmount);
    // changes
    address public wLuca;
    mapping(address => bool) public wrraperExecutor;
    mapping(address => uint256) public lucaConverted;
    address public receiver;
    address public trader;
    uint256 public mintPercentage;
    bool public paused;
    address public crosschain;

    constructor() {}

    function __Minter_init(
        address _luca,
        uint256 _limitAmount,
        address _executor,
        address _wLuca,
        address _receiver,
        address _trader,
        address _crosschain
    ) external initializer {
        __Ownable_init_unchained();
        __Minter_init_unchained(
            _luca,
            _limitAmount,
            _executor,
            _wLuca,
            _receiver,
            _trader,
            _crosschain
        );
    }

    function __Minter_init_unchained(
        address _luca,
        uint256 _limitAmount,
        address _executor,
        address _wLuca,
        address _receiver,
        address _trader,
        address _crosschain
    ) internal initializer {
        luca = _luca;
        limitAmount = _limitAmount;
        executor = _executor;
        wLuca = _wLuca;
        receiver = _receiver;
        trader = _trader;
        crosschain = _crosschain;
        paused = false;
        wrraperExecutor[address(this)] = true;
    }

    modifier onlyExecutor() {
        require(msg.sender == executor, "caller is not the executor");
        require(!paused, "Contract is paused");
        _;
    }

    modifier onlyWhiteListExecutor() {
        require(wrraperExecutor[msg.sender], "caller is not the executor");
        require(!paused, "Contract is paused");
        _;
    }

    function updateExecutor(address _executor) external onlyOwner {
        executor = _executor;
        emit UpdateExecutor(_executor);
    }

    function updateLimit(uint256 _limitAmount) external onlyOwner {
        limitAmount = _limitAmount;
        emit UpdateLimit(_limitAmount);
    }

    function updateMintPercentage(uint256 _mintPercentage) external onlyOwner {
        mintPercentage = _mintPercentage;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == crosschain, "only crosschain can call");
        IERC20(luca).mint(to, amount);
    }

    function mint(uint256 amount) external onlyExecutor {
        uint256 day = block.timestamp / 86400;
        mintedAmount[day] += amount;
        require(limitAmount >= mintedAmount[day], "Extraction limit exceeded");
        IERC20(luca).mint(address(this), amount);
        lucaConverted[receiver] += amount;
        _wrap(receiver, amount);
    }

    function mint() external onlyExecutor {
        require(lucaConverted[trader] != 0, "Trader has no luca");
        uint256 amountToMint = (lucaConverted[trader] * mintPercentage) / 100;
        uint256 day = block.timestamp / 86400;
        mintedAmount[day] += amountToMint;
        IERC20(luca).mint(address(this), amountToMint);
        lucaConverted[receiver] += amountToMint;
        _wrap(receiver, amountToMint);
    }

    function addWhitelistExecutor(address _executor, bool _allow)
        external
        onlyOwner
    {
        wrraperExecutor[_executor] = _allow;
    }

    function convertLucaToWLuca(address _to, uint256 _amount)
        external
        onlyWhiteListExecutor
    {
        lucaConverted[msg.sender] += _amount;
        _wrap(_to, _amount);
    }

    function convertWLucaToLuca(address _to, uint256 _amount)
        external
        onlyWhiteListExecutor
    {
        require(
            lucaConverted[msg.sender] >= _amount,
            "Not enough wLuca to convert"
        );
        lucaConverted[msg.sender] -= _amount;
        _unWrap(_to, _amount);
    }

    function burnTraderLuca(uint256 _amount) external onlyWhiteListExecutor {
        lucaConverted[msg.sender] += _amount;
        IERC20(luca).burn(_amount);
    }

    function _wrap(address _to, uint256 _amount) internal {
        IERC20(luca).burn(_amount);
        IERC20(wLuca).mint(_to, _amount);
    }

    function _unWrap(address _to, uint256 _amount) internal {
        IERC20(wLuca).burn(_amount);
        IERC20(luca).mint(_to, _amount);
    }

    function pause(bool _pause) external onlyOwner {
        paused = _pause;
    }
}
