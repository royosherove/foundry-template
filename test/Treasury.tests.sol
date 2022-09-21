// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "forge-std/Test.sol";
// import { console } from "forge-std/console.sol";
// import { PRBTest } from "@prb/test/PRBTest.sol";
import "./../src/Treasury.sol";


/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract TreasuryTest is Test {
    event Joined(address indexed who,uint256 indexed contribution);

    function testfuzz_join_emitsJoinedEvent(uint amount) public {
        vm.assume(amount < 100 ether);
        vm.assume(amount > 0.1 ether);
    
        Treasury t = new Treasury();
        console.log(amount);

        vm.expectEmit(true,true,false,true);
        emit Joined(address(this),amount);

        t.join{value:amount}();
        
        assertTrue(t.isMember(address(this)));
    }
}
