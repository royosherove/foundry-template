// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Test } from "forge-std/Test.sol";
import { Cheats } from "forge-std/Cheats.sol";
import { console } from "forge-std/console.sol";
import "./../src/Treasury.sol";

contract TreasuryTest is Test {

    function test_receive_SendingFunds_updatesBalance() public {
        Treasury t = new Treasury();

        address(t).call{value: 0.1 ether}("");
        
        assertEq(address(t).balance, 0.1 ether);
    }

    event Joined(address indexed who, uint256 indexed contribution);
    function test_joinTwice_RevertsSecondTime() public {
        Treasury t = new Treasury();
        t.join{value:0.1 ether}();

        vm.expectRevert(Treasury.ErrorAlreadyJoined.selector);
        t.join{value:0.1 ether}();
    }

    function test_join_withPaymentUnderThhreshold_Reverts() public {
        Treasury t = new Treasury();


        vm.expectRevert(Treasury.ErrorNotPaid.selector);
        t.join{ value: 0.01 ether }();
    }

    function test_join_isMemberReturnsTrue() public {
        Treasury t = new Treasury();

        t.join{ value: 0.1 ether }();

        assertTrue(t.isMember(address(this)));
    }

    function test_setMaxMembers_JoineAboveThreshod_reverts() public {
        Treasury t = new Treasury();
        t.setMaxMembers(2);

        address alice = vm.addr(100); vm.deal(alice, 1 ether);
        address bob = vm.addr(200); vm.deal(bob, 1 ether);
        address mike = vm.addr(300); vm.deal(mike, 1 ether);

        vm.prank(alice);
        t.join{ value: 0.1 ether }();
        vm.prank(bob);
        t.join{ value: 0.1 ether }();

        vm.expectRevert(Treasury.ErrorClubIsFull.selector);
        vm.prank(mike);
        t.join{ value: 0.1 ether }();
    }

    function testfuzz_join_emitsJoinedEvent(uint256 amount) public {
        vm.assume(amount < 100 ether);
        vm.assume(amount > 0.1 ether);

        Treasury t = new Treasury();
        console.log(amount);

        vm.expectEmit(true, true, false, true);
        emit Joined(address(this), amount);

        t.join{ value: amount }();

        assertTrue(t.isMember(address(this)));
    }
}
