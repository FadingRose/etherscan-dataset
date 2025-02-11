// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
 
interface IERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function mint(uint256 amount) external;
    function mint(address to,uint256 amount) external;
    function burn(uint256 amount) external;
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function lucaToFragment(uint256 value) external view returns (uint256);
    function fragmentToLuca(uint256 value) external view returns (uint256);
}
interface Itrader {
    function suck(address _to, uint256 _amount) external;
}
interface ICrosschain {
    function transferToken(
         address[2] calldata addrs,
        uint256[3] calldata uints,
        string[] calldata strs,
        uint8[] calldata vs,
        bytes32[] calldata rssMetadata) external;
    function stakeToken(string memory _chain, string memory  receiveAddr, address tokenAddr, uint256 _amount) external ;
}

abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
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

    /**
     * @dev Initializes the contract setting the management contract as the initial owner.
     */
    function __Ownable_init_unchained(address _management) internal initializer {
        require( _management != address(0),"management address cannot be 0");
        _owner = _management;
        emit OwnershipTransferred(address(0), _management);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IMinterContract {
    function convertLucaToWLuca(address _to, uint256 _amount) external;
    function convertWLucaToLuca(address _to, uint256 _amount) external;
    function mint(address to , uint256 amount) external;
}

interface Ifile {
    function factory() external view returns (address);

    function luca() external view returns (address);

    function wluca() external view returns (address);

    function minter() external view returns (address);

    function agt() external view returns (address);

    function crossChain() external view returns (address);
}


contract CrosschainV3 is Initializable,Ownable,ICrosschain {
    using SafeMath for uint256;
    bool public pause;
    uint256 public nodeNum;
    uint256 public stakeNum;
    bytes32 public DOMAIN_SEPARATOR;
    bool public bscSta;
    IERC20 public lucaToken;
    mapping(string => mapping(address => uint256)) public chargeRate;
    mapping(address => uint256) chargeAmount;
    mapping(string => bool) public chainSta;
    mapping(string => mapping(string => bool)) status;
    mapping(address => uint256) nodeAddrIndex;
    mapping(uint256 => address) public nodeIndexAddr;
    mapping(address => bool) public nodeAddrSta;
    mapping(uint256 => Stake) public stakeMsg;
    event UpdatePause(bool sta);
    event WithdrawChargeAmount(address tokenAddr, uint256 amount);
    event AddNodeAddr(address[] nodeAddrs);
    event DeleteNodeAddr(address[] nodeAddrs);
    event UpdateChainCharge(string chain, bool sta, address[] tokens, uint256[] fees);
    event TransferToken(address indexed _tokenAddr, address _receiveAddr, uint256 _fragment, uint256 _amount, string chain, string txid);
    event StakeToken(address indexed _tokenAddr, address indexed _userAddr, string receiveAddr, uint256 fragment, uint256 amount, uint256 fee,string chain);
    IERC20 public agtToken;
    Itrader public trader;
    mapping(address => uint256) public threshold;
    mapping(address => mapping(uint256 => uint256)) public withdrawLimit;
    event UpdateThreshold(address tokenAddr, uint256 threshold);

    
    
    struct Data {
        address userAddr;
        address contractAddr;
        uint256 fragment;
        uint256 amount;
        uint256 expiration;
        string chain;
        string txid;
    }

    struct Stake {
        address tokenAddr;
        address userAddr;
        string receiveAddr;
        uint256 fragment;
        uint256 amount;
        uint256 fee;
        string chain;
    }

    struct Sig {
        /* v parameter */
        uint8 v;
        /* r parameter */
        bytes32 r;
        /* s parameter */
        bytes32 s;
    }

    modifier onlyGuard() {
        require(!pause, "Crosschain: The system is suspended");
        _;
    }

    address public file;

    function init( 
        address _lucaToken, 
        address _trader, 
        address _agt,
        address _management,
        bool _sta
    )  external initializer{
        __Ownable_init_unchained(_management);
        __Crosschain_init_unchained(_lucaToken, _trader, _agt, _sta);
    }

    function __Crosschain_init_unchained(
        address _lucaToken, 
        address _trader, 
        address _agt,
        bool _sta
    ) internal initializer{
        require( _lucaToken != address(0),"lucaToken address cannot be 0");
        require( _trader != address(0),"trader address cannot be 0");
        require( _agt != address(0),"agt address cannot be 0");
        lucaToken = IERC20(_lucaToken);
        trader = Itrader(_trader);
        agtToken = IERC20(_agt);
        bscSta = _sta;
        uint chainId;
        assembly {
            chainId := chainId
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(uint256 chainId,address verifyingContract)'),
                chainId,
                address(this)
            )
        );
    }

    receive() payable external{

    }

    fallback() payable external{

    }

    function updatePause(bool _sta) external onlyOwner{
        pause = _sta;
        emit UpdatePause(_sta);
    }

    function updateThreshold(address[] calldata _tokens, uint256[] calldata _thresholds) external onlyOwner{
        require(_tokens.length == _thresholds.length, "Parameter array length does not match");
        for (uint256 i = 0; i< _tokens.length; i++){
            threshold[_tokens[i]] = _thresholds[i];
            emit UpdateThreshold(_tokens[i], _thresholds[i]);
        }
    }

    function updateChainCharge(string calldata _chain, bool _sta, address[] calldata _tokens, uint256[] calldata _fees) external onlyOwner{
        chainSta[_chain] = _sta;
        require(_tokens.length == _fees.length, "Parameter array length does not match");
        for (uint256 i = 0; i< _tokens.length; i++){
            chargeRate[_chain][_tokens[i]] = _fees[i];
        }
        emit UpdateChainCharge(_chain, _sta, _tokens, _fees);
    }


    function withdrawChargeAmount(address[] calldata tokenAddrs, address receiveAddr) external onlyOwner{
        require( receiveAddr != address(0),"receiveAddr address cannot be 0");
        for (uint256 i = 0; i< tokenAddrs.length; i++){
            if(tokenAddrs[i] == address(lucaToken)){
                uint256 _amount =  chargeAmount[tokenAddrs[i]];
                chargeAmount[tokenAddrs[i]] = 0;
                ( address minter, address wluca) = (
                        Ifile(file).minter(), Ifile(file).wluca()
                    );
                require(IERC20(wluca).transfer(minter,_amount), "Token transfer failed");
                IMinterContract(minter).convertWLucaToLuca( address(this),_amount);
                require(lucaToken.transfer(receiveAddr,_amount), "Token transfer failed");
                emit WithdrawChargeAmount(tokenAddrs[i], _amount);
            }else{
                IERC20 token = IERC20(tokenAddrs[i]);
                uint256 _amount = chargeAmount[tokenAddrs[i]];
                chargeAmount[tokenAddrs[i]] = 0;
                require(token.transfer(receiveAddr,_amount), "Token transfer failed");
                emit WithdrawChargeAmount(tokenAddrs[i], _amount);
            }
            
        }
       
    }

    function addNodeAddr(address[] calldata _nodeAddrs) external onlyOwner{
        for (uint256 i = 0; i< _nodeAddrs.length; i++){
            address _nodeAddr = _nodeAddrs[i];
            require(!nodeAddrSta[_nodeAddr], "This node is already a node address");
            nodeAddrSta[_nodeAddr] = true;
            uint256 _nodeAddrIndex = nodeAddrIndex[_nodeAddr];
            if (_nodeAddrIndex == 0){
                _nodeAddrIndex = ++nodeNum;
                nodeAddrIndex[_nodeAddr] = _nodeAddrIndex;
                nodeIndexAddr[_nodeAddrIndex] = _nodeAddr;
            }
        }
        emit AddNodeAddr(_nodeAddrs);
    }

    function deleteNodeAddr(address[] calldata _nodeAddrs) external onlyOwner{
        for (uint256 i = 0; i< _nodeAddrs.length; i++){
            address _nodeAddr = _nodeAddrs[i];
            require(nodeAddrSta[_nodeAddr], "This node is not a pledge node");
            nodeAddrSta[_nodeAddr] = false;
            uint256 _nodeAddrIndex = nodeAddrIndex[_nodeAddr];
            if (_nodeAddrIndex > 0){
                uint256 _nodeNum = nodeNum;
                address _lastNodeAddr = nodeIndexAddr[_nodeNum];
                nodeAddrIndex[_lastNodeAddr] = _nodeAddrIndex;
                nodeIndexAddr[_nodeAddrIndex] = _lastNodeAddr;
                nodeAddrIndex[_nodeAddr] = 0;
                nodeIndexAddr[_nodeNum] = address(0x0);
                nodeNum--;
            }
        }
        emit DeleteNodeAddr(_nodeAddrs);
    }

    function stakeToken(string memory _chain, string memory receiveAddr, address tokenAddr, uint256 _amount) override external {
        address _sender = msg.sender;
        require( tokenAddr == address(lucaToken) || tokenAddr == address(agtToken) , "Crosschain: The token does not support transfers");
        require( chainSta[_chain], "Crosschain: The chain does not support transfer");
        require(verfylimit(tokenAddr,_amount),"Extraction limit exceeded");
        if (address(lucaToken) == tokenAddr){
            uint256 _charge = chargeRate[_chain][tokenAddr];
            uint256 _offsetAmount = _amount.sub(_charge);
            uint256 fragment = lucaToken.lucaToFragment(_offsetAmount);
            require(fragment > 0, "Share calculation anomaly");
            chargeAmount[tokenAddr] = chargeAmount[tokenAddr].add(_charge);
            stakeMsg[++stakeNum] = Stake(tokenAddr, _sender, receiveAddr, fragment, _offsetAmount, _charge, _chain);
            ( address minter) = (
                        Ifile(file).minter()
                    );
            if(!bscSta){
                require(lucaToken.transferFrom(_sender,address(this),_offsetAmount), "Token transfer failed");
                require(lucaToken.transferFrom(_sender,minter,_charge), "Token transfer failed");
                IMinterContract(minter).convertLucaToWLuca(address(this), _charge);
                lucaToken.burn(_offsetAmount);        
            }else{
                require(lucaToken.transferFrom(_sender,minter,_amount), "Token transfer failed");
                IMinterContract(minter).convertLucaToWLuca( address(this), _amount);
            }

            // need to wrap the token
            emit StakeToken(tokenAddr, _sender, receiveAddr, fragment, _offsetAmount, _charge, _chain);
        }else{
            IERC20 token = IERC20(tokenAddr);
            require(token.transferFrom(_sender,address(this),_amount), "Token transfer failed");
            uint256 fee = chargeRate[_chain][tokenAddr];
            _amount = _amount.sub(fee);
            chargeAmount[tokenAddr] = chargeAmount[tokenAddr].add(fee);
            stakeMsg[++stakeNum] = Stake(tokenAddr, _sender, receiveAddr, 0, _amount, fee, _chain);
            token.burn(_amount); 
            emit StakeToken(tokenAddr, _sender, receiveAddr, 0, _amount, fee, _chain);
        }
    }

    /**
    * @notice A method in which issue transfer tokens to users. 
    * @param addrs [User address, token contract address]
    * @param uints [Number of luca fragments (0 for non-luca tokens), number of transfers, expiration time]
    * @param strs [chain name, transaction id]
    * @param vs  array of signature data
    * @param rssMetadata array of signature data
    */
    function transferToken(
        address[2] calldata addrs,
        uint256[3] calldata uints,
        string[] calldata strs,
        uint8[] calldata vs,
        bytes32[] calldata rssMetadata
    )
        external
        override
        onlyGuard
    {
        require( addrs[1] == address(lucaToken) || addrs[1] == address(agtToken) , "Crosschain: The token does not support transfers");
        require( block.timestamp<= uints[2], "Crosschain: The transaction exceeded the time limit");
        require( !status[strs[0]][strs[1]], "Crosschain: The transaction has been withdrawn");
        status[strs[0]][strs[1]] = true;
        uint256 len = vs.length;
        uint256 counter;
        require(len*2 == rssMetadata.length, "Crosschain: Signature parameter length mismatch");
        uint256[] memory arr = new uint256[](len);
        bytes32 digest = getDigest(Data( addrs[0], addrs[1], uints[0], uints[1], uints[2], strs[0], strs[1]));
        for (uint256 i = 0; i < len; i++) {
            (bool result, uint256 index) = verifySign(
                digest,
                Sig(vs[i], rssMetadata[i*2], rssMetadata[i*2+1])
            );
            arr[i] = index;
            if (result){
                counter++;
            }
        }
        require(areElementsUnique(arr), "IncentiveContracts: Signature parameter not unique");
        require(
            counter > nodeNum/2,
            "The number of signed accounts did not reach the minimum threshold"
        );
        _transferToken(addrs, uints, strs);
    }
   
    function queryCharge(address[] calldata addrs) external view returns (address[] memory, uint256[] memory) {
        address[] memory _addrArray = new address[](1) ;
        uint256[] memory _chargeAmount = new uint256[](1) ;
        uint256 len = addrs.length;
        _addrArray = new address[](len) ;
        _chargeAmount = new uint256[](len) ;
        for (uint256 i = 0; i < len; i++) {
            _addrArray[i] = addrs[i];
            _chargeAmount[i] = chargeAmount[addrs[i]];
        }
        return (_addrArray, _chargeAmount);
    }

    function _transferToken(address[2] memory addrs, uint256[3] memory uints, string[] memory strs) internal {
        if (address(lucaToken) == addrs[1]){
            uint256 amount = uints[1];
            ( address minter, address wluca) = (
                        Ifile(file).minter(), Ifile(file).wluca()
                    );
            if (!bscSta){
                IMinterContract(minter).mint(addrs[0], amount);
            }else{
                require(IERC20(wluca).transfer(minter,amount), "Token transfer failed");
                IMinterContract(minter).convertWLucaToLuca( address(this), amount);
                uint256 balance = lucaToken.balanceOf(address(this));
                require(balance >= amount,"Insufficient token balance");
                require(
                lucaToken.transfer(addrs[0],amount),
                    "Token transfer failed"
                );
            }
            require(verfylimit(addrs[1],amount),"Extraction limit exceeded");
            emit TransferToken(addrs[1], addrs[0], uints[0], amount, strs[0], strs[1]);
        }else if(address(agtToken) == addrs[1]){
            uint256 amount = uints[1];
            uint256 balance = agtToken.balanceOf(address(this));
            if (balance < amount){
                trader.suck(address(this),amount);
            }
            balance = agtToken.balanceOf(address(this));
            require(balance >= amount,"Insufficient token balance");
            require(verfylimit(addrs[1],amount),"Extraction limit exceeded");
            require(
                agtToken.transfer(addrs[0],amount),
                "Token transfer failed"
            );
            emit TransferToken(addrs[1], addrs[0], 0, amount, strs[0], strs[1]);
        }
    }

    function areElementsUnique(uint256[] memory arr) internal pure returns (bool) {
        for(uint i = 0; i < arr.length - 1; i++) {
            for(uint j = i + 1; j < arr.length; j++) {
                if (arr[i] == arr[j]) {
                    return false; 
                }
            }
        }
        return true; 
    }

    function verfylimit(address token, uint256 amount) internal returns (bool) {
        uint256 day = block.timestamp/86400;
        withdrawLimit[token][day] += amount;
        return threshold[token] > withdrawLimit[token][day];
    }

    function verifySign(bytes32 _digest,Sig memory _sig) internal view returns (bool,uint256)  {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 hash = keccak256(abi.encodePacked(prefix, _digest));
        address _nodeAddr = ecrecover(hash, _sig.v, _sig.r, _sig.s);
        require(_nodeAddr !=address(0),"Illegal signature");
        return (nodeAddrSta[_nodeAddr],nodeAddrIndex[_nodeAddr]);
    }
    
    function getDigest(Data memory _data) internal view returns(bytes32 digest){
        digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(_data.userAddr, _data.contractAddr,  _data.fragment, _data.amount, _data.expiration, _data.chain, _data.txid))
            )
        );
    }

    function setFile(address _file) external onlyOwner {
                file = _file;
    }


    function wrapAllLuca() external {
        (address luca, address minter) = (
            Ifile(file).luca(),
            Ifile(file).minter()
        );
        if(chargeAmount[luca] > 1e23){
            chargeAmount[luca] = IERC20(luca).fragmentToLuca(chargeAmount[luca]);
        }
        uint256 luca_balance = IERC20(luca).balanceOf(address(this));
        IERC20(luca).transfer(minter, luca_balance);
        IMinterContract(minter).convertLucaToWLuca(address(this), luca_balance);
    }

    
}
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}
