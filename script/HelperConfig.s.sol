// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "test/mocks/MockV3Aggregator.sol";
//why helperConfig?
//1. Deploy mocks when we are on a local anvil chain
//2. keep track of contract address across different chains
//sepolia eth/usd
//mainnet eth/usd 

contract HelperConfig is Script{
    //if we are on a local anvil, we deploy  ocks 
    // otherwise, grab the existing address from the live network

    //as these functions can be used to get multiple info from the live network 
    // we will use a struct 
    struct NetworkConfig {
        address priceFeed;
    }
    uint8 public constant DECIMALS =8;
    int256 public constant INITIAL_PRICE = 2000e8;


    NetworkConfig public activeNetworkConfig;

    constructor(){
        //Sepolia -> chainId = 11155111
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if(block.chainid == 1){
            activeNetworkConfig = getMainnetEthConfig();
        }
        else{
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        //price feed address 
        // vrf address 
        // etc. 
        // but for now we will restrict to pricefeed address
        NetworkConfig memory sepoliaconfig = NetworkConfig({
            priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaconfig;
        
    }

    function getMainnetEthConfig() public pure returns(NetworkConfig memory) {
        //price feed address 
        // vrf address 
        // etc. 
        // but for now we will restrict to pricefeed address
        NetworkConfig memory ethconfig = NetworkConfig({
            priceFeed:0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        });
        return ethconfig;
        
    }


    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory) {
        //this checks if we have already made a pricefeed before
        if(activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }
        //1. Deploy the mocks
        //2. return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        vm.stopBroadcast();
        
        NetworkConfig memory anvilconfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilconfig;

    }
}