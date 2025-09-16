// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

import {Groth16Verifier} from "../contracts/Verifier.sol";
import {Zkvote} from "../contracts/Zkvote.sol";
import {Test} from "forge-std/Test.sol";

contract ZkvoteTest is Test {
    Zkvote zkvote;
    Groth16Verifier verifier;

    function setUp() public {
        verifier = new Groth16Verifier();
        zkvote = new Zkvote(address(verifier));
    }

    function testRegisterUser_newUser(uint256 commitment) public {
        zkvote.registerVoter(commitment);
        assertEq(zkvote.hasVoted(msg.sender), false);
    }

    function testRegisterUser_alreadyRegistered() public {
        uint256 commitment = 2938701;
        zkvote.registerVoter(commitment);
        vm.expectRevert();
        zkvote.registerVoter(commitment);
    }
}
