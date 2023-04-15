// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract lottery{
    
//state variables
    address public manager;
    address payable[] public players;
    address[] public winners;


//constructor
    constructor(){
        manager = msg.sender;
    }


// modifiers
modifier onlyManager {
    require(msg.sender == manager, "Only manager can call this function");
    _;
}    


//other functions
    function enterPlayer() public payable {
        require(msg.value >= 0.1 ether,"Atleast 0.1 eth needed");
        players.push(payable(msg.sender));
    }

    function pickWinner() public onlyManager{
        require(players.length >= 3, "at least 3 players needed");
        uint index = getrandomnumber() % players.length;
        players[index].transfer(address(this).balance);
        winners.push(players[index]);
        players = new address payable[](0);
    }

    function getBalance() view public onlyManager returns(uint){
        return address(this).balance;
    }

    function getPlayers() view public returns(address payable[] memory){
        return players;
    }
 
    function getWinners() public view returns(address[] memory){
        return winners;
    }

    function getrandomnumber() public view returns(uint){
        return uint(keccak256(abi.encodePacked(manager, block.timestamp)));
    }


}