// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Treasury {
    event Joined(address indexed who,uint256 indexed contribution);
    error NotPaid();
    error ClubIsFull();
    uint max = 10;
    uint count = 0;
    
    mapping (address => bool) members  ;

    function setMaxMembers(uint _max) public {
        max=_max;
    }
    function getBalance() public view  returns (uint256) {
        return address(this).balance;
    }

    function join() public payable {
        if(count+1>max) revert ClubIsFull();
        if(msg.value < 0.1 ether) revert NotPaid();
        members[msg.sender] = true; 
        count++;
        emit Joined(address(msg.sender),msg.value);

    }

    function isMember(address _address) public view returns (bool){
       return members[_address];
    }

    receive() external payable { }
}
