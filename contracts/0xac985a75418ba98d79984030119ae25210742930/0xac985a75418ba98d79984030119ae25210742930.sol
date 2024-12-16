// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external;
    function transfer(address recipient, uint256 amount) external;
    function balanceOf(address account) external view returns (uint256);
    function decimals() external view returns (uint8);
}

contract RealtimeLottery {
    IERC20 public token;
    address public owner;
    uint256 public ticketPrice;
    uint256 public minTickets = 1; // Minimum number of tickets to purchase
    uint256 public jackpotThreshold;
    uint256 public winnersCount = 3; // Default number of winners
    uint256 public feePercentage = 5; // Default fee percentage

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

    constructor(address _tokenAddress) {
        token = IERC20(_tokenAddress);
        owner = msg.sender;
        
        uint8 decimals = token.decimals();
        
        ticketPrice = 1 * 10 ** decimals;
        jackpotThreshold = 1000 * 10 ** decimals;
    }

    function buyTickets(uint256 ticketCount) external {
        require(ticketCount >= minTickets, "Must purchase at least the minimum number of tickets");
        uint256 totalCost = ticketPrice * ticketCount;

        // Transfer tokens from user to contract
        token.transferFrom(msg.sender, address(this), totalCost);

        if (participants[msg.sender] == 0) {
            participantAddresses.push(msg.sender);
        }
        participants[msg.sender] += totalCost;

        emit TicketPurchased(msg.sender, totalCost);

        // Check if the jackpot threshold is reached and enough participants
        if (token.balanceOf(address(this)) >= jackpotThreshold && participantAddresses.length >= winnersCount) {
            drawWinners();
        }
    }

    function drawWinners() public {
        require(token.balanceOf(address(this)) >= jackpotThreshold, "Jackpot threshold not reached");
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

        uint256 totalBalance = token.balanceOf(address(this));
        uint256 fee = totalBalance * feePercentage / 100;
        uint256 amountPerWinner = (totalBalance - fee) / winnersCount;

        // Transfer fee to owner
        token.transfer(owner, fee);

        for (uint256 i = 0; i < winnersCount; i++) {
            token.transfer(winners[i].addr, amountPerWinner);
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
        require(_feePercentage <= 10, "Fee percentage cannot exceed 10%");
        feePercentage = _feePercentage;
    }

    function getMinTickets() external view returns (uint256) {
        return minTickets;
    }

    function getJackpotThreshold() external view returns (uint256) {
        return jackpotThreshold;
    }

    function getWinnersCount() external view returns (uint256) {
        return winnersCount;
    }

    function getFeePercentage() external view returns (uint256) {
        return feePercentage;
    }

    function getCurrentParticipantCount() external view returns (uint256) {
        return participantAddresses.length;
    }

    function getCurrentPoolAmount() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function getLotteryRound(uint256 round) external view returns (Participant[] memory winners, uint256 amountPerWinner) {
        LotteryRound storage lotteryRound = lotteryRounds[round];
        return (lotteryRound.winners, lotteryRound.amountPerWinner);
    }

    function getParticipants() external view returns (Participant[] memory) {
        Participant[] memory participantList = new Participant[](participantAddresses.length);
        for (uint256 i = 0; i < participantAddresses.length; i++) {
            participantList[i] = Participant(participantAddresses[i], participants[participantAddresses[i]]);
        }
        return participantList;
    }
}
