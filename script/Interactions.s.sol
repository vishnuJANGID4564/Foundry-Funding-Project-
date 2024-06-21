// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//we will have 2 scripts
// fund 
// withdraw 
import {Script,console} from "lib/forge-std/src/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address mostRecentDeployed) public {
        FundMe(payable(mostRecentDeployed)).fund{value:SEND_VALUE}();
        console.log("Funded FundMe with %s",SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {

    function withdrawFundMe(address mostRecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        // vm.startBroadcast();
        withdrawFundMe(mostRecentDeployed);
        // vm.stopBroadcast();
    }
}