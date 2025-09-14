// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

import {Zkvote} from "../contracts/Zkvote.sol";
import {Test} from "forge-std/Test.sol";

contract ZkvoteTest is Test {
    Zkvote zkvote;

    function setUp() public {
        zkvote = new Zkvote();
    }

    function testRegisterUser_newUser(bytes32 commitment) public {
        zkvote.registerVoter(commitment);
        assertEq(zkvote.isRegistered(), true);
        assertEq(zkvote.hasVoted(), false);
    }

    function testRegisterUser_alreadyRegistered(bytes32 commitment) public {
        zkvote.registerVoter(commitment);
        vm.expectRevert();
        zkvote.registerVoter(commitment);
    }
}
