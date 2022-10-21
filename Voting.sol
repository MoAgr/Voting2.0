// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

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
        uint duration;
        uint endTime;
    }

    Poll[] public polls;
    mapping(address=>Voter) public regVoters;

    Option temp;
    Poll tempPoll;

    modifier preventTwice(){
        require(keccak256(abi.encodePacked(regVoters[msg.sender].name))==keccak256(abi.encodePacked("")),"Already Registered");
        _;
    }
 
    modifier votable(uint pollIndex){ //add out of index check also
        require(block.timestamp<polls[pollIndex].endTime,"Voting Period is Over!");
        require(polls[pollIndex].creator!=msg.sender,"Creator cannot vote!");
        require(keccak256(abi.encodePacked(regVoters[msg.sender].name))!=keccak256(abi.encodePacked("")),"Not registered!");
        require(regVoters[msg.sender].voted==false,"Account already voted!");
        _;
    }

    function returnTime()public view returns(uint){
        return block.timestamp;
    }

    function register(string memory name)public preventTwice{
        regVoters[msg.sender]=Voter(name,msg.sender,false);
    }

    function createPoll(string[] memory options, uint duration)public{ //check memory or storage
        globalPollNo++;

        Poll storage _tempPoll=tempPoll;
        tempPoll.creator=msg.sender;
        tempPoll.pollNo=globalPollNo;
        tempPoll.duration=duration * 1 minutes; //duration currently only supports minutes
        // uint time=block.timestamp;
        console.log(duration);
        tempPoll.endTime=block.timestamp+duration;

        //check this code snippet for gas

        Option storage _temp=temp;
        for(uint8 i=0;i<options.length;i++){
            _temp.name=options[i];
            _tempPoll.options.push(_temp);
        }

        //end of snippet

        polls.push(_tempPoll);

    }

    function vote(uint8 pollIndex,uint8 optnIndex) public votable(pollIndex){ 
        Poll storage poll=polls[pollIndex];
        Option storage option=poll.options[optnIndex];
        option.votes++;
        option.voters.push(regVoters[msg.sender]);
        regVoters[msg.sender].voted=true;
    }

}