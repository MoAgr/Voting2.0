// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{

    uint8 globalPollNo=0; 

    struct Voter{
        string name;
        address addr;
        bool voted;
    }

    struct Option{
        string name;
        uint8 votes;
        Voter[] voters;
    }

    struct Poll{
        address creator;
        uint8 pollNo;
        uint8 nOptn;
        Option[] options;
        uint startTime;
        uint endTime;
    }

    Poll[] public polls;
    mapping(address=>Voter) public voters;

    Option temp;
    Poll tempPoll;

    modifier preventTwice(){
        require(keccak256(abi.encodePacked(voters[msg.sender].name))==keccak256(abi.encodePacked("")),"Already Registered");
        _;
    }

    modifier votable(uint pollIndex){
        require(polls[pollIndex].creator!=msg.sender,"Creator cannot vote!");
        require(keccak256(abi.encodePacked(voters[msg.sender].name))!=keccak256(abi.encodePacked("")),"Not registered!");
        require(voters[msg.sender].voted==false,"Account already voted!");
        _;
    }

    function register(string memory name)public preventTwice{
        voters[msg.sender]=Voter(name,msg.sender,false);
    }

    function createPoll(string[] memory options, uint start, uint end)public{ //check memory or storage
        globalPollNo++;

        Poll storage _tempPoll=tempPoll;
        tempPoll.creator=msg.sender;
        tempPoll.pollNo=globalPollNo;
        tempPoll.startTime=start;
        tempPoll.endTime=end;

        //check this code snippet for gas

        Option storage _temp=temp;
        for(uint8 i=0;i<options.length;i++){
            _temp.name=options[i];
            _tempPoll.options.push(_temp);
        }

        //end of snippet

        polls.push(_tempPoll);

    }

    function vote(uint8 pollIndex,Option memory option) public votable(pollIndex){

    }

}