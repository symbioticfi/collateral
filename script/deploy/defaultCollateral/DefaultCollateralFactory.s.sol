// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Script} from "forge-std/Script.sol";

import {DefaultCollateralFactory} from "src/contracts/defaultCollateral/DefaultCollateralFactory.sol";

contract DefaultCollateralFactoryScript is Script {
    function run() external {
        vm.startBroadcast();

        new DefaultCollateralFactory();

        vm.stopBroadcast();
    }
}
