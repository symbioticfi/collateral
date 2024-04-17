// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {DefaultBondFactory} from "src/contracts/defaultBond/DefaultBondFactory.sol";

contract DefaultBondScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new DefaultBondFactory();

        vm.stopBroadcast();
    }
}
