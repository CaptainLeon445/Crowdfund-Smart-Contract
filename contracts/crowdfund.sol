// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract crowdfund{
    address public admin;
    mapping (address=>uint) public contributors;
    uint public noOfContributors;
    uint public minimumContribution;
    uint public deadline; //timestamp
    uint public goal;
    uint public raisedAmount;

    constructor(uint _goal, uint _deadline){
        admin = msg.sender;
        goal = _goal;
        deadline =block.timestamp + _deadline;
        minimumContribution = 100 wei;
    }

    // function modifiers
    modifier validateDeadline(){
        require(block.timestamp < deadline, "Deadline has passed!");
        _;
    }

    modifier validateMinimumContribution(){
        require(msg.value >= minimumContribution, "Minimum contribution not met!");
        _;
    }

    function contribute() public payable validateDeadline validateMinimumContribution{
        if(contributors[msg.sender] == 0){
            noOfContributors++;
        }
        contributors[msg.sender] == msg.value;
        raisedAmount += msg.value;
    }

    receive() external payable {
        contribute();
     }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
}