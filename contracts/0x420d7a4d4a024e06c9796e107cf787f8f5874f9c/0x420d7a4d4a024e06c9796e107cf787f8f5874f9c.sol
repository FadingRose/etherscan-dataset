/**
 *Submitted for verification at Etherscan.io on 2024-04-27
 */

/**
 *Submitted for verification at Etherscan.io on 2024-03-04
 */

//SPDX-License-Identifier: MIT Licensed
pragma solidity ^0.8.18;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
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

interface IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external;

    function transfer(address to, uint256 value) external;

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external;

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);
}

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

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
}

contract PresaleEth is Ownable {
    IERC20 public USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    AggregatorV3Interface public priceFeed;

    struct Phase {
        uint256 tokensToSell;
        uint256 totalSoldTokens;
        uint256 tokenPerUsdPrice;
    }
    mapping(uint256 => Phase) public phases;

    // Stats
    uint256 public totalStages;
    uint256 public currentStage;
    uint256 public soldToken;
    uint256 public amountRaised;
    uint256 public amountRaisedUSDT;
    uint256 public amountRaisedOverall;
    uint256 public uniqueBuyers;

    uint256[] public tokenPerUsdPrice = [
        1250000000000000000000,
        1241079739373254731616,
        1232225152179806294206,
        1223421174973696444738,
        1214697843911327057394,
        1206025302410844579519,
        1197418366002897752445,
        1188862733908742896545,
        1180386694681177553766,
        1171961981553318410350,
        1163588973830883978543,
        1155281368777365727422,
        1147038919030522705635,
        1138848396501457725947,
        1130722871131514377141,
        1122649452708391804658,
        1114640806999944267959,
        1106684373616644532979,
        1098780353807273925942,
        1090940827369523477046,
        1083153710343034780065,
        1075419144611612375923,
        1067748651967326891249,
        1060130608090916800949,
        1052554022335196353952,
        1045041279130525655763,
        1037591956587152536393,
        1030184403008138456783,
        1022829555682841011373,
        1015527414162545317910,
        1008277962068583066979,
        1001081167661073959876,
        993936984395189344995,
        986845351464971924249,
        979796594227038466814,
        972809961574006500000,
        965866285471439300000,
        958965851226037800000,
        952127051833796700000,
        945322544052030600000
    ];
    uint256[] public tokensToSell = [
        39_062_500 * 10**18,
        38_783_684 * 10**18,
        38_506_858 * 10**18,
        38_232_008 * 10**18,
        37_959_120 * 10**18,
        37_688_180 * 10**18,
        37_419_173 * 10**18,
        37_152_087 * 10**18,
        36_886_907 * 10**18,
        36_623_620 * 10**18,
        36_362_112 * 10**18,
        36_102_669 * 10**18,
        35_849_803 * 10**18,
        35_591_301 * 10**18,
        35_335_106 * 10**18,
        35_082_895 * 10**18,
        34_832_484 * 10**18,
        34_583_861 * 10**18,
        34_337_012 * 10**18,
        34_091_925 * 10**18,
        33_858_787 * 10**18,
        33_628_987 * 10**18,
        33_400_962 * 10**18,
        33_172_827 * 10**18,
        32_924_830 * 10**18,
        32_689_511 * 10**18,
        32_463_606 * 10**18,
        32_246_063 * 10**18,
        32_036_384 * 10**18,
        31_835_973 * 10**18,
        31_542_394 * 10**18,
        31_283_825 * 10**18,
        31_061_701 * 10**18,
        30_833_287 * 10**18,
        30_617_871 * 10**18,
        30_415_303 * 10**18,
        30_183_944 * 10**18,
        29_967_401 * 10**18,
        29_753_899 * 10**18,
        29_541_466 * 10**18
    ];

    address payable public fundReceiver;

    bool public presaleStatus;
    bool public isPresaleEnded;
    uint256 public claimStartTime;

    address[] public UsersAddresses;
    struct User {
        uint256 native_balance;
        uint256 usdt_balance;
        uint256 token_balance;
        uint256 claimed_tokens;
    }

    mapping(address => User) public users;
    mapping(address => bool) public isExist;

    event BuyToken(address indexed _user, uint256 indexed _amount);
    event ClaimToken(address indexed _user, uint256 indexed _amount);
    event UpdatePrice(uint256 _oldPrice, uint256 _newPrice);

    constructor(address _fundReceiver) {
        fundReceiver = payable(_fundReceiver);
        priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
       for (uint256 i = 0; i < tokensToSell.length; i++) {
            phases[i].tokensToSell = tokensToSell[i];
            phases[i].tokenPerUsdPrice = tokenPerUsdPrice[i];
        }
        totalStages = tokensToSell.length;
    }

    // update a presale
    function updatePresale(uint256 _phaseId, uint256 _tokenPerUsdPrice)
        public
        onlyOwner
    {
        require(phases[_phaseId].tokenPerUsdPrice > 0, "presale don't exist");
        phases[_phaseId].tokenPerUsdPrice = _tokenPerUsdPrice;
    }

    // to get real time price of Eth
    function getLatestPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price);
    }

    // to buy token during preSale time with Eth => for web3 use
    function buyToken() public payable {
        require(!isPresaleEnded, "Presale ended!");
        require(presaleStatus, " Presale is Paused, check back later");
        if (!isExist[msg.sender]) {
            isExist[msg.sender] = true;
            uniqueBuyers++;
            UsersAddresses.push(msg.sender);
        }
        fundReceiver.transfer(msg.value);

       uint256 numberOfTokens;
        numberOfTokens = nativeToToken(msg.value, currentStage);
        require(
            phases[currentStage].totalSoldTokens + numberOfTokens <=
                phases[currentStage].tokensToSell,
            "Phase Limit Reached"
        );
        soldToken = soldToken + (numberOfTokens);
        amountRaised = amountRaised + (msg.value);
        amountRaisedOverall = amountRaisedOverall + nativeToUsd(msg.value);
        phases[currentStage].totalSoldTokens += numberOfTokens;
        users[msg.sender].native_balance =
            users[msg.sender].native_balance +
            (msg.value);
        users[msg.sender].token_balance =
            users[msg.sender].token_balance +
            (numberOfTokens);
    }

    // to buy token during preSale time with USDT => for web3 use
    function buyTokenUSDT(uint256 amount) public {
        require(!isPresaleEnded, "Presale ended!");
        require(presaleStatus, " Presale is Paused, check back later");
        if (!isExist[msg.sender]) {
            isExist[msg.sender] = true;
            uniqueBuyers++;
            UsersAddresses.push(msg.sender);
        }
        USDT.transferFrom(msg.sender, fundReceiver, amount);

        uint256 numberOfTokens;
        numberOfTokens = usdtToToken(amount, currentStage);
        require(
            phases[currentStage].totalSoldTokens + numberOfTokens <=
                phases[currentStage].tokensToSell,
            "Phase Limit Reached"
        );
        soldToken = soldToken + numberOfTokens;
        amountRaisedUSDT = amountRaisedUSDT + amount;
        amountRaisedOverall = amountRaisedOverall + amount;

        users[msg.sender].usdt_balance += amount;
        users[msg.sender].token_balance =
            users[msg.sender].token_balance +
            numberOfTokens;
        phases[currentStage].totalSoldTokens += numberOfTokens;
    }

    function getPhaseDetail(uint256 phaseInd)
        external
        view
        returns (uint256 priceUsd)
    {
        Phase memory phase = phases[phaseInd];
        return (phase.tokenPerUsdPrice);
    }

    function setPresaleStatus(bool _status) external onlyOwner {
        presaleStatus = _status;
    }

    function endPresale() external onlyOwner {
        isPresaleEnded = true;
        claimStartTime = block.timestamp;
    }

    // to check number of token for given Eth
    function nativeToToken(uint256 _amount, uint256 phaseId)
        public
        view
        returns (uint256)
    {
        uint256 ethToUsd = (_amount * (getLatestPrice())) / (1 ether);
        uint256 numberOfTokens = (ethToUsd * phases[phaseId].tokenPerUsdPrice) /
            (1e8);
        return numberOfTokens;
    }

    // to check number of token for given usdt
    function usdtToToken(uint256 _amount, uint256 phaseId)
        public
        view
        returns (uint256)
    {
        uint256 numberOfTokens = (_amount * phases[phaseId].tokenPerUsdPrice) /
            (1e6);
        return numberOfTokens;
    }

    // Eth to USD
    function nativeToUsd(uint256 _amount) public view returns (uint256) {
        uint256 nativeTousd = (_amount * (getLatestPrice())) / (1e20);
        return nativeTousd;
    }

    //change tokens for buy
    function updateStableTokens(IERC20 _USDT) external onlyOwner {
        USDT = IERC20(_USDT);
    }

    // to withdraw funds for liquidity
    function initiateTransfer(uint256 _value) external onlyOwner {
        fundReceiver.transfer(_value);
    }

    // to withdraw funds for liquidity
    function changeFundReciever(address _addr) external onlyOwner {
        fundReceiver = payable(_addr);
    }

    // funtion is used to change the stage of presale
    function setCurrentStage(uint256 _stageNum) public onlyOwner {
        currentStage = _stageNum;
    }

    // to withdraw funds for liquidity
    function updatePriceFeed(AggregatorV3Interface _priceFeed)
        external
        onlyOwner
    {
        priceFeed = _priceFeed;
    }

    // to withdraw out tokens
    function transferTokens(IERC20 token, uint256 _value) external onlyOwner {
        token.transfer(msg.sender, _value);
    }

    function totalUsersCount() external view returns (uint256) {
        return UsersAddresses.length;
    }
}
