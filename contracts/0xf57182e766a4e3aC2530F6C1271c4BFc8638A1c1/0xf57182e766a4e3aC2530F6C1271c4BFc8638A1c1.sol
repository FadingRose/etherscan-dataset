/**
EVA AGI
https://evaintelligence.ai/

Disclaimer:
- Eva is a research project. There are no guarantees that it will be possible to create a competitive product in the market in the time and with the available resources.
- No direct or indirect contributor will be responsible for your possible profits or losses.
- The EVA Token can be obtained on decentralized platforms that carry risks inherent to technology and market fluctuations.
- By interacting with our services, you accept all responsibility.


*/

pragma solidity >=0.7.0 <0.9.0;

// SPDX-License-Identifier: Unlicensed
interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Ownable {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    constructor () {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract EVA is IERC20, Ownable {

    string private constant _name = "EVA AGI Intelligence";
    string private constant _symbol = "EVA AGI";
    uint8 private constant _decimals = 18;  
    uint256 private _totalSupply = 120 * 10**6 * 10**18;
    
    address public seedAndPresale;

    mapping(address => uint256) private balances;
    mapping(address => mapping (address => uint256)) private allowed;
    mapping(address => address) private boosterBuyingAllowed;
    
    // listing restrictions
    uint256 private restrictionLiftTime;
    uint256 private maxRestrictionAmount = 120 * 10**6 * 10**18;
    mapping (address => bool) private isWhitelisted;
    mapping (address => uint256) private lastTx;
    // end restrictions
    
    using SafeMath for uint256;
    
    enum State {
        Locked,
        Restricted, // Bot protection for liquidity pool
        Unlocked
    }
    State public state;
    
    constructor() {  
        state = State.Locked;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }  
    
    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }
    
    function totalSupply() public override view returns (uint256) {
	    return _totalSupply;
    }
    
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override launchRestrict(msg.sender, receiver, numTokens) returns (bool) {
        require(numTokens > 0, "Transfer amount must be greater than zero");
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint256) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address receiver, uint256 numTokens) public override launchRestrict(owner, receiver, numTokens) returns (bool) {
        require(numTokens <= balances[owner]);    
        require(boosterBuyingAllowed[owner] == msg.sender || numTokens <= allowed[owner][msg.sender]);
    
        balances[owner] = balances[owner].sub(numTokens);
        if (boosterBuyingAllowed[owner] != msg.sender) {
            allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
            balances[receiver] = balances[receiver].add(numTokens);
            emit Transfer(owner, receiver, numTokens);
        } else {
            _totalSupply = _totalSupply.sub(numTokens);
            emit Transfer(owner, address(0), numTokens);
        }
        return true;
    }
    
    function boosterBuyingAllowance(address owner) public view returns (bool) {
        return boosterBuyingAllowance(owner, msg.sender);
    }
    
    function boosterBuyingAllowance(address owner, address delegate) public view returns (bool) {
        if (boosterBuyingAllowed[owner] == delegate) return true;
        else return false;
    }
    
    function allowBuyingBoosters(address evac) public returns (bool) {
        boosterBuyingAllowed[msg.sender] = evac;
        return true;
    }
    
    function setSeedAndPresale(address seedAndPresale_) public onlyOwner() {
        seedAndPresale = seedAndPresale_;
    }
    
    modifier ownerOrPresale {
        require(owner() == msg.sender || seedAndPresale == msg.sender, "Cannot burn tokens");
        _;
    }
    
    function burn(uint256 numTokens) public ownerOrPresale() returns(bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        _totalSupply = _totalSupply.sub(numTokens);
        emit Transfer(msg.sender, address(0), numTokens);
        return true;
    }
    
    // Security from bots

    // enable/disable works only once, token never returns to Locked
    function setBotProtection(bool enable) public onlyOwner() {
        if (enable && state == State.Locked) state = State.Restricted;
        if (!enable) state = State.Unlocked;
    }

    function setRestrictionAmount(uint256 amount) public onlyOwner() {
        maxRestrictionAmount = amount;
    }

    function whitelistAccount(address account) public onlyOwner() {
        isWhitelisted[account] = true;
    }

    modifier launchRestrict(address sender, address recipient, uint256 amount) {
        if (state == State.Locked) {
            require(sender == owner() || sender == seedAndPresale || isWhitelisted[sender], "Tokens are locked");
        }
        if (state == State.Restricted) {
            require(amount <= maxRestrictionAmount, "EVA: amount greater than max limit in restricted mode");
            if (!isWhitelisted[sender] && !isWhitelisted[recipient]) {
                require(lastTx[sender].add(60) <= block.timestamp && lastTx[recipient].add(60) <= block.timestamp, "EVA: only one tx/min in restricted mode");
                lastTx[sender] = block.timestamp;
                lastTx[recipient] = block.timestamp;
            } else if (!isWhitelisted[recipient]) {
                require(lastTx[recipient].add(60) <= block.timestamp, "EVA: only one tx/min in restricted mode");
                lastTx[recipient] = block.timestamp;
            } else if (!isWhitelisted[sender]) {
                require(lastTx[sender].add(60) <= block.timestamp, "EVA: only one tx/min in restricted mode");
                lastTx[sender] = block.timestamp;
            }
        }
        _;
    }

    // Bot security end
}


library SafeMath { 
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
