// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

import {Groth16Verifier} from "./Verifier.sol";

contract Zkvote {
    error InvalidCommitment(
        uint256 registeredCommitment,
        uint256 proofCommitment
    );

    struct Proof {
        uint[2] a;
        uint[2][2] b;
        uint[2] c;
        uint[2] input;
    }

    Groth16Verifier public verifier;
    mapping(address => uint256) public commitments;
    mapping(address => bool) public hasVoted;
    bool public votingOpen = true;
    uint public yesVotes;
    uint public noVotes;

    constructor(address _verifier) {
        verifier = Groth16Verifier(_verifier);
    }

    modifier onlyWhileOpen() {
        require(votingOpen, "Voting is closed.");
        _;
    }

    function registerVoter(uint256 _commitment) public onlyWhileOpen {
        require(commitments[msg.sender] == 0, "User already registered.");
        commitments[msg.sender] = _commitment;
    }

    function submitVote(Proof memory proof) external onlyWhileOpen {
        require(!hasVoted[msg.sender], "User already voted.");

        if (commitments[msg.sender] != proof.input[0])
            revert InvalidCommitment(commitments[msg.sender], proof.input[0]);

        require(
            verifier.verifyProof(proof.a, proof.b, proof.c, proof.input),
            "Invalid proof."
        );

        hasVoted[msg.sender] = true;
    }

    function closeVoting() public {
        votingOpen = false;
    }

    function getResults() public view returns (uint yes, uint no) {
        return (yesVotes, noVotes);
    }
}
