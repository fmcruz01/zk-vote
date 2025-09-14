// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

contract Zkvote {
    struct Voter {
        bool registered;
        bool voted;
        bytes32 commitment;
    }

    mapping(address => Voter) public voters;
    bool public votingOpen = true;
    uint public yesVotes;
    uint public noVotes;

    modifier onlyWhileOpen() {
        require(votingOpen, "Voting is closed.");
        _;
    }

    function registerVoter(bytes32 _commitment) public onlyWhileOpen {
        require(!voters[msg.sender].registered, "User already reigstered.");
        voters[msg.sender] = Voter(true, false, _commitment);
    }

    function submitVote(bool _vote) public onlyWhileOpen {
        Voter memory voter = voters[msg.sender];
        require(voter.registered, "User not registered.");
        require(!voter.voted, "User already voted.");

        voter.voted = true;
        if (_vote) {
            yesVotes++;
        } else {
            noVotes++;
        }
    }

    function closeVoting() public {
        votingOpen = false;
    }

    function getResults() public view returns (uint yes, uint no) {
        return (yesVotes, noVotes);
    }

    function hasVoted() public view returns (bool) {
        return voters[msg.sender].voted;
    }

    function isRegistered() public view returns (bool) {
        return voters[msg.sender].registered;
    }
}
