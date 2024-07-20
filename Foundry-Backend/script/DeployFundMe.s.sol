// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {FundMe} from "src/FundMe.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract DeployFundMe is Script{
    function run() external returns(FundMe){

        //as we dont want to send haper config as a real txn. we are instantiating it before startBroadcast();
        HelperConfig helperConfig = new HelperConfig();
        address ethusdPriceFeed = helperConfig.activeNetworkConfig();
        //if there were more than one entries in the NetworkConfig
        // (address ethusdPriceFeed,,,,) = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethusdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}


