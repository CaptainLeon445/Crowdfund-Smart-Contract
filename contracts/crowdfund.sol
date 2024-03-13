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

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping (address => bool) voters;
    }

    mapping (uint => Request) public requests;
    uint public numRequests;

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

    modifier getRefundValidators() {
        require(block.timestamp > deadline && raisedAmount < goal, "The target is met!");
        require(contributors[msg.sender] > 0, "You are not in the contributors list");
        _;
    }

    modifier onlyAdmin(){
        require(msg.sender == admin, "Only admin can call the function");
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

    function getRefund () public getRefundValidators{
        payable(msg.sender).transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin{
      Request storage newRequest = requests[numRequests];
      numRequests++;

      newRequest.description = _description;
      newRequest.recipient = _recipient;
      newRequest.value = _value;
      newRequest.completed = false;
      newRequest.noOfVoters = 0;
    }

    function voteRequest(uint _requestNo) public {
        require(contributors[msg.sender] > 0, "You are not in the contributors list");
        
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.voters[msg.sender]==false, "You have already voted!");
        
        thisRequest.voters[msg.sender]==true;
        thisRequest.noOfVoters++;
    }
}