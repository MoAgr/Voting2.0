// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{

    struct voter{
        string name;
        address addr;
        bool voted;
    }

    struct option{
        string name;
        uint8 votes;
        voter[] voters;
    }

    struct poll{
        address creator;
        uint8 pollNo;
        uint8 nOptn;
        option[] options;
        uint startTime;
        uint endTime;
    }

    poll[] public polls;


    function createPoll(option[] memory options, uint start, uint end)public{

    }

}