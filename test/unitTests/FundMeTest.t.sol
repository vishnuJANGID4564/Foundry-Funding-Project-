// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//std packages for making runnign the test easy
import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";


contract FundMeTest is Test {

    uint256 constant SEND_VALUE = 8e18; //8 ether
    uint256 constant STARTING_BALANCE = 10e18; //10 ether
    FundMe fundMe;

    address USER = makeAddr("user");

    function setUp() external {
        // us calling-> FundMeTest to deply FundMe
        // so the owner of the FundMe wouldn't be the msg.sender but FundMeTest
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        // as the constructor of FundMe.sol don't take any inputs

        //After making the scipt deploy environment ans test deploy environment same
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER,STARTING_BALANCE);
    }

    function testMinDollarisFive() public view {
        //we need to tske fundMe out of the scope of setUP()to access here
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwneridmsgSender() public view {
        // console.log(fundMe.i_owner());
        // console.log(msg.sender);
        // assertEq(fundMe.i_owner(),msg.sender);
        //this gives error because of the reason i mentioned above
        assertEq(fundMe.getOwner(),msg.sender);
    }

    function testPriceFeedisAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version,4);
    }

    function testFundfailswithoutEnoughEth() public {
        vm.expectRevert();
        //assert this txn. fails
        // uint256 cat = 1;
        // this test will fail because the above txn dont revert
        fundMe.fund(); // sending 0 value which is less than MINIMUM_USD => revert
    }

    function testFundUpadatesFundedDataStructure() public {
        vm.prank(USER);//this means that now the next txn will be sent by USER
        fundMe.fund{value : SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded,SEND_VALUE);
    }

    function testAddsFunderToArrayofFunders() public {
        vm.prank(USER);
        fundMe.fund{value : SEND_VALUE}();
        // as User should be the only funder thats why index=0
        address funder = fundMe.getFunders(0);
        assertEq(funder,USER);
    }

    modifier funded(){
        vm.prank(USER);
        fundMe.fund{value : SEND_VALUE}();
        _;
    }
    function testOnlyOwnerCanWithdraw() public funded {
        // first let fund it
        // vm.prank(USER);
        // fundMe.fund{value : SEND_VALUE}();
        // this is a repetitive thing 
        //best practise is to put it in a modifier

        vm.expectRevert();
        vm.prank(USER);// this is not a txn. so it moves down untill it founds the first txn.
        fundMe.withdraw();//this is a txn. which will revert as USER is not the owner
    }

    function testWithdrawwithaSingleFunder() public funded{
        //Arrange 
        //what is the current Balance
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //startingFundMeBalance means the current balance in the contract 
        //which would be SEND_VALUE for our test cause that is what has been funded till now

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw(); 

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance + startingOwnerBalance , endingOwnerBalance);
    }

    function testWithdrawwithaMultipleFunders() public funded {
        //Arrange
        uint160 numberofFunders =10;
        uint160 startingfunderIndex = 1; // avoid using 0 for address generation
        for(uint160 i =startingfunderIndex; i<numberofFunders;i++){
            //vm.prank(msgSender);
            //vm.deal(account, newBalance);
            // we can use hoax wheverver we have to prank and deal simultaneosly 
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value : SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw(); 

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance + startingOwnerBalance , endingOwnerBalance);

    }

    function testWithdrawwithaMultipleFundersCheaper() public funded {
        //Arrange
        uint160 numberofFunders =10;
        uint160 startingfunderIndex = 1; // avoid using 0 for address generation
        for(uint160 i =startingfunderIndex; i<numberofFunders;i++){
            //vm.prank(msgSender);
            //vm.deal(account, newBalance);
            // we can use hoax wheverver we have to prank and deal simultaneosly 
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value : SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw(); 

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance,0);
        assertEq(startingFundMeBalance + startingOwnerBalance , endingOwnerBalance);

    }
}