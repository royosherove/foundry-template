// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Test } from "forge-std/Test.sol";
import { Cheats } from "forge-std/Cheats.sol";
import { console } from "forge-std/console.sol";
import "./../src/Treasury.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract TreasuryTest is Cheats, Test {
    event Joined(address indexed who, uint256 indexed contribution);

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

        vm.expectRevert(Treasury.ClubIsFull.selector);
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
