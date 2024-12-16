// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20Token {
    string public name = "PEPEX";
    string public symbol = "PEPEX";
    uint8 public decimals = 18;
    uint256 public totalSupply = 100000000000 * (10 ** uint256(decimals));
    address public owner;
    address public feeRecipient;
    address public swapRouter;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    uint256 public constant SWAP_FEE_PERCENT = 3;
    uint256 public constant WALLET_TRANSFER_FEE_PERCENT = 0;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(address _feeRecipient) {
        owner = msg.sender;
        feeRecipient = _feeRecipient;
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0), "Transfer to the zero address");
        require(balanceOf[from] >= value, "Insufficient balance");

        uint256 fee;
        if (from == swapRouter || to == swapRouter) {
            // Apply 5% fee on swaps
            fee = (value * SWAP_FEE_PERCENT) / 100;
        } else {
            // Apply 1% fee on normal transfers
            fee = (value * WALLET_TRANSFER_FEE_PERCENT) / 100;
        }

        uint256 amountToTransfer = value - fee;

        balanceOf[from] -= value;
        balanceOf[to] += amountToTransfer;
        balanceOf[feeRecipient] += fee;

        emit Transfer(from, to, amountToTransfer);
        emit Transfer(from, feeRecipient, fee);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Approve to the zero address");

        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(value <= balanceOf[from], "Insufficient balance");
        require(value <= allowance[from][msg.sender], "Allowance exceeded");

        allowance[from][msg.sender] -= value;
        _transfer(from, to, value);
        return true;
    }

    function setFeeRecipient(address _feeRecipient) public onlyOwner {
        feeRecipient = _feeRecipient;
    }

    function setSwapRouter(address _swapRouter) public onlyOwner {
        swapRouter = _swapRouter;
    }
}
