// File: @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol


pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

// File: DMDR.sol

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

interface TOKEN
{
    function transfer(address to, uint tokens) external returns (bool success);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) ;
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}



contract DMDR_buy
    {


        address payable public  owner;

        uint public min_amount=10000000;

        address public USDT_token=0xdAC17F958D2ee523a2206206994597C13D831ec7;
        address public DMDR_address=0xC427f19DeA9e7C967fb3c49bFb4f3D8A8CDcd2Ea;

        uint public DMDR_price = 770 ether;
        AggregatorV3Interface internal priceFeed;

        constructor()
        {
            owner=payable(msg.sender);
            priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419); //Mainnet

            
            
        }
        


        function getLatestPrice() public view returns (int) {
            // prettier-ignore
            (
                /* uint80 roundID */,
                int price,
                /*uint startedAt*/,
                /*uint timeStamp*/,
                /*uint80 answeredInRound*/
            ) = priceFeed.latestRoundData();
            return price*10**10;
            }



        function getConversionRate(int dollar_amount) public view returns (int) {

            int MaticPrice = getLatestPrice();
            int UsdToMatic = (( dollar_amount *10**18 ) / (MaticPrice));

            return UsdToMatic;

        }

        function get_ethPrice()  public view returns(uint ){
            uint price;
            price = uint256(getConversionRate( int256(DMDR_price)));

            return price;

        }



        function buy_token(uint amount , uint choosed_token)  public payable returns(bool){
            
            require(choosed_token >=0 && choosed_token <2);
                uint bought_amount;


            if(choosed_token==0)             // ETHER
            {
                 bought_amount= ((amount* 10**9) / get_ethPrice()) ;
                require(bought_amount >= min_amount);
                require(TOKEN(DMDR_address).balanceOf(address(this)) >= (bought_amount));

                owner.transfer(msg.value);  
                   
                TOKEN(DMDR_address).transfer(msg.sender,bought_amount);
               



            }
            else if(choosed_token==1)        // USDT
            {
                bought_amount=((( amount * (10**9)) / DMDR_price)) ;

                require(bought_amount >= min_amount);

                require(TOKEN(USDT_token).balanceOf(msg.sender) >=  amount/10**12 ,"not enough usdt");
                require(TOKEN(USDT_token).allowance(msg.sender,address(this))>=amount/10**12,"less allowance");    //uncomment

                require(TOKEN(DMDR_address).balanceOf(address(this))>=bought_amount,"contract have less tokens");
                
                TOKEN(USDT_token).transferFrom(msg.sender,owner,amount/10**12);

                TOKEN(DMDR_address).transfer(msg.sender,bought_amount);
                

            }

            return true;
        }


        function set_DMDR_Price(uint _val)  public
        {
            require(msg.sender==owner);
            DMDR_price = _val;
        }


        function set_minAmount(uint _val)  public
        {
            require(msg.sender==owner);
            min_amount = _val;
        }

        function transferOwnership(address _owner)  public
        {
            require(msg.sender==owner);
            owner = payable(_owner);
        }

       function withdraw_DMDRV1(uint _amount)  public
        {
            require(msg.sender==owner);
            uint bal = TOKEN(DMDR_address).balanceOf(address(this));
            require(bal>=_amount);
            TOKEN(DMDR_address).transfer(owner,_amount); 
        }


    }
