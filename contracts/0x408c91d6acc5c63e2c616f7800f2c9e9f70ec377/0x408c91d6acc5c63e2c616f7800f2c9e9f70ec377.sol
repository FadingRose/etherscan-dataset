// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external;
    function transfer(address recipient, uint256 amount) external;
    function balanceOf(address account) external view returns (uint256);
}

contract Lottery {
    IERC20 public usdtToken;
    address public owner;
    uint256 public ticketPrice = 1 * 10**6; // 1 USDT (assuming USDT has 6 decimals)
    uint256 public minTickets = 1; // Minimum number of tickets to purchase
    uint256 public jackpotThreshold = 10000 * 10**6; // Default jackpot threshold 10000 USDT
    uint256 public winnersCount = 3; // Default number of winners
    uint256 public feePercentage = 10; // Default fee percentage (10%)

    struct Participant {
        address addr;
        uint256 amount;
    }

    struct LotteryRound {
        Participant[] winners;
        uint256 amountPerWinner;
    }

    mapping(uint256 => LotteryRound) public lotteryRounds;
    uint256 public currentRound;
    mapping(address => uint256) public participants;
    address[] public participantAddresses;

    event TicketPurchased(address indexed user, uint256 amount);
    event WinnersAnnounced(uint256 round, Participant[] winners, uint256 amountPerWinner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier onlyOwnerOrContract() {
        require(msg.sender == owner || msg.sender == address(this), "Caller is not the owner or contract");
        _;
    }

    constructor(address _usdtAddress) {
        usdtToken = IERC20(_usdtAddress);
        owner = msg.sender;
    }

    function buyTickets(uint256 ticketCount) external {
        require(ticketCount >= minTickets, "Must purchase at least the minimum number of tickets");
        uint256 totalCost = ticketPrice * ticketCount;

        // Transfer USDT from user to contract
        usdtToken.transferFrom(msg.sender, address(this), totalCost);

        if (participants[msg.sender] == 0) {
            participantAddresses.push(msg.sender);
        }
        participants[msg.sender] += totalCost;

        emit TicketPurchased(msg.sender, totalCost);

        // Check if the jackpot threshold is reached and enough participants
        if (usdtToken.balanceOf(address(this)) >= jackpotThreshold && participantAddresses.length >= winnersCount) {
            drawWinners();
        }
    }

    function drawWinners() internal onlyOwnerOrContract {
        require(participantAddresses.length >= winnersCount, "Not enough participants");

        Participant[] memory winners = new Participant[](winnersCount);

        // Calculate total weight
        uint256 totalWeight = 0;
        for (uint256 i = 0; i < participantAddresses.length; i++) {
            totalWeight += participants[participantAddresses[i]];
        }

        // Pick winners based on their purchase weight
        for (uint256 i = 0; i < winnersCount; i++) {
            uint256 randomValue = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, i))) % totalWeight;
            uint256 cumulativeWeight = 0;
            for (uint256 j = 0; j < participantAddresses.length; j++) {
                cumulativeWeight += participants[participantAddresses[j]];
                if (randomValue < cumulativeWeight) {
                    winners[i] = Participant(participantAddresses[j], participants[participantAddresses[j]]);
                    totalWeight -= participants[participantAddresses[j]];
                    participants[participantAddresses[j]] = 0;
                    participantAddresses[j] = participantAddresses[participantAddresses.length - 1];
                    participantAddresses.pop();
                    break;
                }
            }
        }

        uint256 totalBalance = usdtToken.balanceOf(address(this));
        uint256 fee = (totalBalance * feePercentage) / 100;
        uint256 amountPerWinner = (totalBalance - fee) / winnersCount;

        // Transfer fee to the owner
        usdtToken.transfer(owner, fee);

        for (uint256 i = 0; i < winnersCount; i++) {
            usdtToken.transfer(winners[i].addr, amountPerWinner);
        }

        // Store the results of this round
        lotteryRounds[currentRound].amountPerWinner = amountPerWinner;
        for (uint256 i = 0; i < winners.length; i++) {
            lotteryRounds[currentRound].winners.push(winners[i]);
        }

        emit WinnersAnnounced(currentRound, winners, amountPerWinner);

        // Reset participants and participantAddresses
        for (uint256 i = 0; i < participantAddresses.length; i++) {
            delete participants[participantAddresses[i]];
        }
        delete participantAddresses;

        // Reset lottery for the next round
        currentRound++;
    }

    function setMinTickets(uint256 _minTickets) external onlyOwner {
        minTickets = _minTickets;
    }

    function setJackpotThreshold(uint256 _jackpotThreshold) external onlyOwner {
        jackpotThreshold = _jackpotThreshold;
    }

    function setWinnersCount(uint256 _winnersCount) external onlyOwner {
        winnersCount = _winnersCount;
    }

    function setFeePercentage(uint256 _feePercentage) external onlyOwner {
        require(_feePercentage <= 20, "Fee percentage cannot be more than 20");
        feePercentage = _feePercentage;
    }

    // Function to withdraw any remaining USDT in the contract (onlyOwner)
    function withdrawRemainingUSDT(uint256 amount) external onlyOwner {
        usdtToken.transfer(owner, amount);
    }

    function getLotteryRound(uint256 round) external view returns (Participant[] memory winners, uint256 amountPerWinner) {
        LotteryRound storage lotteryRound = lotteryRounds[round];
        return (lotteryRound.winners, lotteryRound.amountPerWinner);
    }

    // Function to get the list of participants and their total purchase amounts
    function getParticipants() external view returns (Participant[] memory) {
        Participant[] memory participantList = new Participant[](participantAddresses.length);
        for (uint256 i = 0; i < participantAddresses.length; i++) {
            participantList[i] = Participant(participantAddresses[i], participants[participantAddresses[i]]);
        }
        return participantList;
    }

    function getCurrentParticipantCount() external view returns (uint256) {
        return participantAddresses.length;
    }

    function getCurrentPoolAmount() external view returns (uint256) {
        return usdtToken.balanceOf(address(this));
    }
}
