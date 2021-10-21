// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalHappinessBites;

    uint256 private seed;

    // event HappinessBit(address user);

    event NewHappinessBite( address indexed from, uint256 timestamp, string message);

    struct Bite {
        address biter; // the address of the user who sent a bite
        string message; // the message the user sent
        uint256 timestamp; // the timesteamp when the user sent a bite
    }

    Bite[] happinessBites;

    // mapping (address => uint) ownerHappinessBiteCount;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastHappinessBitAt;

    constructor() payable {
        console.log("This smart contract is the beginning of something beautiful");
    }

    function happinessBite(string memory _message) public {

        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
          lastHappinessBitAt[msg.sender] + 15 minutes < block.timestamp, "Wait 15m"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastHappinessBitAt[msg.sender] = block.timestamp;

        totalHappinessBites += 1;
        console.log("%s has given you something to be happy about!", msg.sender);
        // incrementing count of specific user who sent a bite 
        // ownerHappinessBiteCount[msg.sender]++;
        // emit HappinessBit(msg.sender);

        happinessBites.push(Bite(msg.sender, _message, block.timestamp));

        /*
         * Generate a Psuedo random number between 0 and 100
         */
        uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);

        /*
         * Set the generated, random number as the seed for the next wave
         */
        seed = randomNumber;

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (randomNumber < 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewHappinessBite(msg.sender, block.timestamp, _message);

        // uint256 prizeAmount = 0.0001 ether;
        // require(
        //     prizeAmount <= address(this).balance,
        //     "Trying to withdraw more money than the contract has."
        // );
        // (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        // require(success, "Failed to withdraw money from contract.");
    }

    function getAllHappinessBites() public view returns (Bite[] memory) {
        return happinessBites;
    }

    function getTotalHappinessBites() public view returns (uint256) {
        console.log("We have %d total happiness bites!", totalHappinessBites);
        return totalHappinessBites;
    }
}