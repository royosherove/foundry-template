// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Cheats } from "forge-std/Cheats.sol";
import { Test } from "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";
import "./../src/Treasury.sol";


/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract TreasuryTest is PRBTest, Cheats {
    event Joined(address indexed who,uint256  contribution);

    function testExample() public {
        Treasury t = new Treasury();

        vm.expectEmit(true,false,false,false);
        emit Joined(address(this),0.2 ether);

        t.join{value:0.1 ether}();
        
        assertTrue(t.isMember(address(this)));
    }
}
