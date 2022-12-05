// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {

  mapping(address => uint) public contributions;
  address public owner;

  constructor() {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable { // 1) call contribute()...
    require(msg.value < 0.001 ether); // ...with < 0.001 ether
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner { // 3) [insert "Look at me - I'm the captaain now" meme] call withdraw() and buy lambo
    payable(owner).transfer(address(this).balance);
  }

  receive() external payable { // 2) the receive() fallback function can set msg.sender to owner...
    require(msg.value > 0 && contributions[msg.sender] > 0); // ...once these conditions are set; you have already called contribute() to meet the second condition...
    owner = msg.sender; // ...send a tiny amount of ether using calldata transaction (not callable function, it's fallback only)
  }
}