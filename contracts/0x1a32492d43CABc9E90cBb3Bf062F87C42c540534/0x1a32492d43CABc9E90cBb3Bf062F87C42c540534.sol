// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IPair {
    function sync() external;
}

interface ILuca {
    function updateMilliThreshold(address _milliThreshold) external;
    function updateExecutor(address _executor) external;
    function rebaseByMilli(uint256 epoch, uint256 milli, bool positive) external returns (uint256);
    function rebase(uint256 epoch, uint256 indexDelta, bool positive) external returns (uint256);
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
        require(_initializing || !_initialized, "Initializable: contract is already initialized");

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

contract Ownable is Initializable{
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

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
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Rebaser is Initializable,Ownable{
    ILuca public luca;
    address[] pairs;
    address public exector;
    uint256 public milliThreshold;
    mapping(uint256 => uint256) public epochSta;

    event UpdateExecutor(address _executor);

    modifier onlyExecutor() {
        require(msg.sender == exector, "caller is not the executor");
        _;
    }

    function __Rebaser_init(address _luca, address[] memory _pairs) external initializer() {
        __Ownable_init_unchained();
        __Rebaser_init_unchained(_luca, _pairs);
    }

    function __Rebaser_init_unchained(address _luca, address[] memory _pairs) internal initializer() {
        luca = ILuca(_luca);
        pairs = _pairs;
    }

    function updateExecutor(address _executor) external onlyOwner{
        exector = _executor;
        emit UpdateExecutor(_executor);
    }
    function updateMilliThreshold(uint256 _milliThreshold) external onlyOwner{
        milliThreshold = _milliThreshold;
    }

    function addPair(address _pair) external onlyOwner() {
        pairs.push(_pair);
    }

    function rebaseByMilli(uint256 milli) external onlyExecutor() {
        uint256 epoch = block.timestamp / 86400;
        require(epochSta[epoch] == 0, "rebaseByMilli error");
        if(milli > milliThreshold){
            milli = milliThreshold;
        }
        epochSta[epoch] = milli;
        require(luca.rebaseByMilli(epoch, milli, false) > 0, "rebaseByMilli error");
        _sync();
    }

    function _sync() internal {
        for(uint i=0; i<pairs.length; i++ ){
            IPair(pairs[i]).sync();
        }
    }

    function getPairs() external view  returns (address[] memory)  {
        address[] memory _pairs = new address[](pairs.length);
        for(uint i=0; i<pairs.length; i++ ){
            _pairs[i] = pairs[i];
        }
        return _pairs;
    }

}
