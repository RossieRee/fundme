// SPDX-License-Identifier: MIT
/*
Unit testing is a software testing method by which individual units of source code are tested, testing minimal portions of the code to see if things are working as intended (Local Testing)

Unit test are done locally:
local hardhat
forked hardhat

//Staging Test is when you run your code on an actual testnet (LAST STOP before DEPLOYING)
*/
pragma solidity ^0.8.7;
//2. Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";
//3. Error Codes
error FundMe__NotOwner();

//4. Interfaces, Libraries
/*
//5. Contracts
//natspec... automatically creates documentation (solc --userdoc --devdoc exl.sol)
/** @title A contract for crowd funding
 *  @auther David Rosser
 *  @notice This contract is to demo a sample funding contract
 *  @dev This implements price feeds as our library
 */
contract FundMe {
    //1. Type Declarations
    using PriceConverter for uint256;

    //2. State Variables
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner;
    uint256 public constant MINIMUM_USD = 50 * 10 ** 18;
    AggregatorV3Interface public priceFeed;
    
    //3. Modifiers
    modifier onlyOwner {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }
    
    //4. Functions
    /*Function Order:
    1. Constructor
    2. recieve
    3. fallback
    4. external
    5. public
    6. internal
    7. private
    8. view/pure
    */
    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress); //accuring pricefeed address depending on what network we are on
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
/*
    /**
     *  @notice This function funds this contract
     *  @dev This implements price feeds as our library
     *  @parameter ...
     *  @returns ...
     */ 
    function fund() public payable {
        require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
    function withdraw() public onlyOwner {
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()
}

// Concepts we didn't cover yet (will cover in later sections)
// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly
