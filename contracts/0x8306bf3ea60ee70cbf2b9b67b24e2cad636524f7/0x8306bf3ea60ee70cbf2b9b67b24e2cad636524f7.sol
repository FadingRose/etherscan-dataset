// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/* version : 18 July 2024 */

/*
    BUG BOUNTY : 
    -------------
    Found a flaw that can compromise all funds? We are offering a 10% bounty of the contracts funds. Let us know, and we will reward your efforts. Happy bug hunting!
    Contact email: ethbounty@duck.com

    Notes
    -----------
    first add token symbol, address

     before deploy:
     --------------
     
     check max_unlock_time, gnosis_safe address
     comment all emits to save gas
     enable optimizations in remix
     write [symbols, prices] in remarks as human readable, because show_box would not display lower_prices, remix is going crazy, so use "_" instead of space in remarks.

    security notes:
    ---------------
    no arithmetic overflows, underflows occur after solidity version 0.8.0
    */

interface I_ERC20 {
    function transfer(address recipient, uint256 amount) external;
    function transferFrom(address from, address to, uint256 value) external;
    function balanceOf(address account) external view returns (uint256);

    function approve(address spender, uint256 value) external;

    function allowance(address owner, address spender) external returns (uint256);
    function symbol() external returns (string memory);

    event Approval(address owner, address spender, uint256 value);
}

interface I_chainlink {
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

    function description() external view returns (string memory);
    function latestTimestamp() external view returns (uint256);
    function getRoundData(uint80 roundId) external view returns (uint80, int256, uint256, uint256, uint80);
    //returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

contract forced_HODL {
    event e_FundsReceived(address indexed from, uint256 amount);
    event e_ticker_price(string ticker_name, int256 price);
    event e_log_string(string);
    event e_box_created(string, uint256);
    event e_log_str_int(string log_name, int256);
    event e_unlockBox_event(uint256 box_number, uint256 box_amount);
    event e_str_int_log(string, uint256);

    struct Box {
        uint256 unlockTime;
        uint256 creationTime;
        mapping(string => int256) max_prices;
        uint256 deposit_amount;
        string remarks;
        bool alive;
    }

    // add new ticker feed to the db
    mapping(string => address) private tokenAddresses;

    mapping(uint256 => Box) private depositBoxes;

    address private gnosis_safe;
    address private WBTC;
    address private owner;
    address private kill_switch_owner;
    address private chainlink_BTC_USD;

    bool public kill_switch = false;
    uint256 private max_unlock_time;
    int256 private min_eth_btc_requirement;
    uint256 private hard_unlock_time;
    uint256 private total_boxes;
    uint256 private debug;

    I_ERC20 private wbtcToken;

    constructor(uint256 max_unlock_time_init, uint256 _debug, address kill_switch_address) {
        debug = _debug; //0 = no_debug. 1 = debug
        owner = msg.sender;
        gnosis_safe = msg.sender; // NOT gnosis safe
        total_boxes = 1;
        hard_unlock_time = 1830297600; //  January 1, 2028 12:00:00 AM
        min_eth_btc_requirement = 4500000; // 0.45 ETH / BTC

        require(max_unlock_time_init < hard_unlock_time, "Error_21, max_unlock_time_init should be < hard_unlock_time");
        max_unlock_time = max_unlock_time_init; // don't use block.timetsamp.. miner may tamper while deploying

        //test add BTC / USD
        chainlink_BTC_USD = 0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c;
        addToken("BTC / USD", chainlink_BTC_USD);

        //test if WBTC address is correct
        WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
        wbtcToken = I_ERC20(WBTC);
        require(
            keccak256(bytes(wbtcToken.symbol())) == keccak256(bytes("WBTC")),
            "Error_00, Entered WBTC address not maching with symbol : WBTC"
        );

        kill_switch_owner = kill_switch_address;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _; // Continue executing the function
    }

    //**** add a new token to the db. symbol format : BTC / USD, ETH / USD ( mind the gap )
    function addToken(string memory _tickerSymbol, address _tokenAddress) public onlyOwner {
        require(tokenAddresses[_tickerSymbol] == address(0), "Error_26, Token already added in db");

        //check if the symbols match with contract
        I_chainlink _chainlink = I_chainlink(_tokenAddress);
        require(
            keccak256(bytes(_chainlink.description())) == keccak256(bytes(_tickerSymbol)),
            "price_ticker_name not matching"
        );

        //add to db
        tokenAddresses[_tickerSymbol] = _tokenAddress;
    }

    //**** get price from chainlink
    function get_ticker_price(string memory _tickerSymbol) public view onlyOwner returns (int256) {
        address tokenAddress = tokenAddresses[_tickerSymbol];
        require(tokenAddress != address(0), "Error_4, Unable to get ticker_price. Token not found");

        I_chainlink ChainLink = I_chainlink(tokenAddress);

        //check if the price feed is written before atleast 25 hrs // some heartbeats are 24 hrs on chainlink
        if ((ChainLink.latestTimestamp() + (60 * 60 * 25)) < block.timestamp) {
            //emit e_log_string("Error_11, Ticker price is older than 25Hrs");
            return 0;
        }

        (, int256 price,,,) = ChainLink.latestRoundData();
        require(
            keccak256(bytes(ChainLink.description())) == keccak256(bytes(_tickerSymbol)),
            "Price ticker name not matching"
        );

        return price;
    }

    // ********** OK
    // transfer to this contract
    function get_funds(uint256 _amount) internal onlyOwner returns (bool) {
        // check if allowance is >= amount

        require(_amount > 0, "Error_13, WBTC transfer amount should be > 0");

        wbtcToken.transferFrom(owner, address(this), _amount);
        emit e_FundsReceived(owner, _amount);
        return true;
    }

    // ********** OK
    function create_box(
        uint256 _unlockTime,
        string[] memory _symbols,
        int256[] memory _prices,
        uint256 _amount,
        string memory _remarks
    ) external onlyOwner {
        require(_symbols.length == _prices.length, "ticker symbols inputs should be equal to lower_prices inputs");

        require(
            (_amount >= 0.01 * 10 ** 8) && (_amount <= 0.1 * 10 ** 8),
            "Error_23, amount should be between 0.01 <-> 0.1 BTC"
        );

        //check < max_unlock_time
        require(_unlockTime < max_unlock_time, "_unlockTime should be < max_unlock_time");
        require(_unlockTime > block.timestamp + 1 days, "unlocktime should be atleast 1 day in the future");
        require(block.timestamp < max_unlock_time, "Error_22, Current time must be < max_unlock_time");

        require(
            _unlockTime < (block.timestamp + 60 days),
            "Error_19, unlockTime should be < two months(60 days) from today."
        );

        //transfer WBTC
        require(get_funds(_amount), "Error_6, unable to transfer WBTC to this contract.");

        // create the box
        emit e_str_int_log("total boxes", total_boxes);
        Box storage newBox = depositBoxes[total_boxes];

        newBox.unlockTime = _unlockTime;
        newBox.creationTime = block.timestamp;
        newBox.deposit_amount += _amount;
        newBox.alive = true;

        for (uint256 i = 0; i < _symbols.length; i++) {
            emit e_log_string("Box creation . looking for symbol : ");
            emit e_log_string(_symbols[i]);

            address tokenAddress = tokenAddresses[_symbols[i]];
            require(tokenAddress != address(0), "Error_3, Unable to create box. Token not found");

            int256 current_price = get_ticker_price(_symbols[i]);

            require(current_price != 0, "Error_12, Box creation error. Ticker price is 0");

            //check if the prices are already greater than current ones. this will avoid above decimal shit
            require(_prices[i] > current_price, "Error_5, max_price should be greater than current price");
            // check if the lower_price is not less than 0.3 times of current_price
            require(_prices[i] < current_price * 2, "Error_15, heigher_price should be less than 2X of current price");
            require(_prices[i] != 0, "Error_14, max_price should be > 0");

            emit e_log_str_int(_symbols[i], _prices[i]);
            emit e_log_str_int("from chainlink", current_price);

            newBox.max_prices[_symbols[i]] = _prices[i];
        }

        total_boxes += 1;

        newBox.remarks = _remarks;
        emit e_box_created("New Box created. Amount : ", _amount);
    }

    // *********
    function show_box(uint256 _box_number)
        public
        view
        onlyOwner
        returns (
            uint256 UnlockTime,
            uint256 DepositAmount_WBTC,
            bool BoxAlive,
            string memory Remarks,
            address WBTC_Receiver,
            string memory TimeRemaining
        )
    {
        Box storage depositBox = depositBoxes[_box_number];

        uint256 unlockTime_remaining;

        if (block.timestamp < depositBox.unlockTime) unlockTime_remaining = depositBox.unlockTime - block.timestamp;
        else unlockTime_remaining = 0;

        TimeRemaining = convertSeconds(unlockTime_remaining);

        uint256 deposit_amount = depositBox.deposit_amount / 10 ** 6; // 6 = WBTC decimal places

        return (depositBox.unlockTime, deposit_amount, depositBox.alive, depositBox.remarks, gnosis_safe, TimeRemaining);
    }

    function convertSeconds(uint256 secondsValue) internal pure returns (string memory) {
        if (secondsValue >= 24 * 3600) {
            uint256 daysValue = secondsValue / (24 * 3600);
            uint256 remainingSeconds = secondsValue % (24 * 3600);
            uint256 hoursValue = remainingSeconds / 3600;
            remainingSeconds %= 3600;
            uint256 minutesValue = remainingSeconds / 60;
            return string(
                abi.encodePacked(
                    uint256ToString(daysValue),
                    " days, ",
                    uint256ToString(hoursValue),
                    " hours, ",
                    uint256ToString(minutesValue),
                    " minutes"
                )
            );
        } else if (secondsValue >= 3600) {
            uint256 hoursValue = secondsValue / 3600;
            uint256 remainingSeconds = secondsValue % 3600;
            uint256 minutesValue = remainingSeconds / 60;
            return string(
                abi.encodePacked(uint256ToString(hoursValue), " hours, ", uint256ToString(minutesValue), " minutes")
            );
        } else if (secondsValue >= 60) {
            uint256 minutesValue = secondsValue / 60;
            return string(abi.encodePacked(uint256ToString(minutesValue), " minutes"));
        } else {
            return string(abi.encodePacked(uint256ToString(secondsValue), " seconds"));
        }
    }

    function uint256ToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint256 temp = value;
        uint256 digits;

        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);

        while (value != 0) {
            digits--;
            buffer[digits] = bytes1(uint8(48 + (value % 10)));
            value /= 10;
        }

        return string(buffer);
    }

    // ********* OK
    function add_more_funds(uint256 _box_number, uint256 _amount) public onlyOwner {
        Box storage depositBox = depositBoxes[_box_number];
        require(depositBox.alive, "Error_8, depositing to not-alive box");

        require(get_funds(_amount), "Error_7 add_more_funds, unable to transfer funds to this contract");
        depositBox.deposit_amount += _amount;
    }

    // ********* OK
    function increase_box_unlocktime(uint256 _box_number, uint256 _new_unlock_time) public onlyOwner {
        Box storage depositBox = depositBoxes[_box_number];
        require(depositBox.alive, "Error_8, Box is not alive.");

        require(_new_unlock_time > depositBox.unlockTime, "Error_16, New unlockTime should be > previous unlockTime");

        require(
            _new_unlock_time < (block.timestamp + (60 * 60 * 24 * 60)),
            "Error_20, new unlockTime should be < two months(60 days) from today "
        );

        require(_new_unlock_time < max_unlock_time, "Error_17, New unlockTime should be < max_unlock_time");
        depositBox.unlockTime = _new_unlock_time;
    }

    //event e_block_timestamp(string, uint256);

    // ********* OK
    // This can only be done by a kill_switch address
    function flip_kill_switch() external {
        require(msg.sender == kill_switch_owner, "Error_35, only kill_swich_owner can call it.");
        if (kill_switch) kill_switch = false;
        else kill_switch = true;
    }

    // ********* OK
    function unlock_box(uint256 _box_number, string memory _ticker_symbol, uint80 _roundId) external onlyOwner {
        // check if ETH / BTC price is < 0.045
        int256 eth_btc_ticker_price = get_ticker_price("ETH / BTC");
        require(eth_btc_ticker_price < min_eth_btc_requirement, "Error_32, ETH / BTC price should be < 0.045"); // 8 = decimal places for ETH / BTC Price on chainlink

        //require(_box_number < total_boxes, "box_number should be < total_boxes");

        Box storage userBox = depositBoxes[_box_number];

        require(userBox.alive == true, "Error_28, box is not alive");

        int256 ticker_price;

        // if roundId == 0, then fetch current price
        if (_roundId == 0) {
            //you will get ticker_price 0 if price on chainlink is older than 25hrs
            ticker_price = get_ticker_price(_ticker_symbol);
        } else {
            uint256 historical_timestamp;
            (ticker_price, historical_timestamp) = getHistoricalData(_roundId, _ticker_symbol);

            require(historical_timestamp < block.timestamp, "Error_26, historical_timestamp should be < block.timstamp");

            require(
                historical_timestamp > userBox.creationTime,
                "Error_27, historical_timestamp shoulbe be > userBox.creationTime"
            );
        }

        //emit e_ticker_price("ticker price ", ticker_price);

        int256 unlock_price = userBox.max_prices[_ticker_symbol];

        //emit e_log_str_int("unlock price", unlock_price);

        //require(unlock_price > 0, "Error_1"); //verify if ticker symbol is present. :: already checking at 'create'

        //emit e_block_timestamp('Current time stamp', block.timestamp);

        if (debug == 0) {
            require(
                block.timestamp > userBox.unlockTime || ticker_price >= unlock_price,
                "Error_2, Unlocktime not met or unlock price not met"
            );
        }

        // send the WBTC funds to gnosis_safe
        wbtcToken.transfer(address(gnosis_safe), userBox.deposit_amount);

        // set alive to false
        userBox.alive = false;
        emit e_unlockBox_event(_box_number, userBox.deposit_amount);
    }

    // ********* OK
    function withdraw_except_WBTC(address _token_address, address _withdraw_dest) public onlyOwner {
        //Except WBTC, make it possible to withdraw every token.
        //ETH withdrawal not required. Since we are rejecting them.
        //since it got no receive() function

        require(
            block.timestamp > (max_unlock_time + 10 days),
            "Error_22, tokens other than WBTC can only be withdrawn after 10 days of max_unlock_time"
        ); //to avoid unknown attacks that may compromise WBTC

        require(_token_address != WBTC, "Error_8, withdrawal of WBTC not allowed"); //check this is not WBTC
        I_ERC20 erc20Token = I_ERC20(address(_token_address));
        uint256 balance = erc20Token.balanceOf(address(this));
        erc20Token.transfer(address(_withdraw_dest), balance); // withdraw TOKENS
    }

    // ********* OK
    function withdraw(uint256 _amount) external onlyOwner {
        // withdraw after max_unlock_time
        require(
            block.timestamp > max_unlock_time || kill_switch,
            "Error_9, max_unlock_time not reached or kill_switch is not active"
        );

        //withdraw all WBTC

        if (_amount == 0) {
            uint256 balance = wbtcToken.balanceOf(address(this));
            wbtcToken.transfer(address(gnosis_safe), balance); // withdraw TOKENS
        } else {
            wbtcToken.transfer(address(gnosis_safe), _amount);
        }

        kill_switch = false;
    }

    // ********* OK
    function getHistoricalData(uint80 _roundId, string memory _tickerSymbol)
        public
        view
        onlyOwner
        returns (int256, uint256)
    {
        address tokenAddress = tokenAddresses[_tickerSymbol];
        require(tokenAddress != address(0), "Error_4, Token not found");

        I_chainlink ChainLink = I_chainlink(tokenAddress);
        (, int256 price_,, uint256 timeStamp_,) = ChainLink.getRoundData(_roundId);

        return (price_, timeStamp_);
    }

    // ********* OK
    function get_details()
        public
        view
        onlyOwner
        returns (
            uint256 total_boxes_,
            address gnosis_safe_,
            address WBTC_,
            uint256 max_unlock_time_,
            uint256 hard_unlock_time_,
            address owner_
        )
    // get useful information
    {
        // total_boxes - 1; // i'm starting from 1.
        return (total_boxes - 1, gnosis_safe, WBTC, max_unlock_time, hard_unlock_time, owner);
    }

    // ********* OK
    function increase_max_unlock_time(uint256 new_max_unlock_time) public onlyOwner {
        //> ability to change max_unlock_time only if 1. the max_unlock time is about to expire in few days 2. there are 0 WBTC in contract 3. must be < hard_unlock_time

        // check if max_unlock_time is just about to expire in 10 days.
        if (debug == 0) {
            uint256 ten_days = 10 days;
            require((block.timestamp + ten_days) >= max_unlock_time, "Error_29");
        }

        // check if this contract got 0 WBTC
        uint256 current_balance = wbtcToken.balanceOf(address(this));
        require(current_balance == 0, "Error_30. Make sure this contracts WBTC is 0 before increasing max_unlock_time.");

        // must be < hard_unlock_time
        require(new_max_unlock_time < hard_unlock_time, "Error_31");

        max_unlock_time = new_max_unlock_time;
    }

    // ********
    // This function is called for plain Ether transfers, i.e., for every call with empty calldata.
    receive() external payable {
        // Revert the transaction to reject the Ether deposit
        revert("Error_33, Ether deposits are not accepted.");
    }

    // This fallback function is called when no other function matches the call or for non-empty calldata
    fallback() external payable {
        // Revert the transaction to reject the Ether deposit
        revert("Error_34, Ether deposits are not accepted.");
    }
}
