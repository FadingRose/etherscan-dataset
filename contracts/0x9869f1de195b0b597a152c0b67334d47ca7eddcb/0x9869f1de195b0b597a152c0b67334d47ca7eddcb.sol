// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Challenge {
    struct ChallengeDetails {
        string title;
        string description;
        uint256 reward;
        address creator;
        bool isCompleted;
    }

    ChallengeDetails[] public challenges;
    mapping(uint256 => address) public challengers;
    mapping(uint256 => bool) public challengeAccepted;
    mapping(address => uint256) public userChallengesCount;

    event ChallengeCreated(uint256 challengeId, string title, string description, uint256 reward, address creator);
    event ChallengeAccepted(uint256 challengeId, address challenger);
    event ChallengeCompleted(uint256 challengeId, address challenger, uint256 reward);

    function createChallenge(string memory _title, string memory _description) public payable {
        require(msg.value > 0, "Reward must be greater than zero");

        ChallengeDetails memory newChallenge = ChallengeDetails({
            title: _title,
            description: _description,
            reward: msg.value,
            creator: msg.sender,
            isCompleted: false
        });

        challenges.push(newChallenge);
        uint256 challengeId = challenges.length - 1;
        userChallengesCount[msg.sender] += 1;

        emit ChallengeCreated(challengeId, _title, _description, msg.value, msg.sender);
    }

    function acceptChallenge(uint256 _challengeId) public {
        require(_challengeId < challenges.length, "Challenge does not exist");
        require(!challengeAccepted[_challengeId], "Challenge already accepted");

        challengers[_challengeId] = msg.sender;
        challengeAccepted[_challengeId] = true;

        emit ChallengeAccepted(_challengeId, msg.sender);
    }

    function completeChallenge(uint256 _challengeId) public {
        require(_challengeId < challenges.length, "Challenge does not exist");
        require(challengeAccepted[_challengeId], "Challenge not accepted");
        require(challengers[_challengeId] == msg.sender, "Only challenger can complete the challenge");
        require(!challenges[_challengeId].isCompleted, "Challenge already completed");

        challenges[_challengeId].isCompleted = true;
        uint256 reward = challenges[_challengeId].reward;
        payable(msg.sender).transfer(reward);

        emit ChallengeCompleted(_challengeId, msg.sender, reward);
    }

    function getChallenge(uint256 _challengeId) public view returns (ChallengeDetails memory) {
        require(_challengeId < challenges.length, "Challenge does not exist");
        return challenges[_challengeId];
    }

    function getAllChallenges() public view returns (ChallengeDetails[] memory) {
        return challenges;
    }
}
