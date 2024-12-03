// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SymbioticCollateralIntegration.sol";

import {console2} from "forge-std/Test.sol";

contract SymbioticCollateralIntegrationExample is SymbioticCollateralIntegration {
    function setUp() public override {
        SYMBIOTIC_COLLATERAL_PROJECT_ROOT = "";
        // vm.selectFork(vm.createFork(vm.rpcUrl("mainnet")));
        // SYMBIOTIC_INIT_BLOCK = 21_227_029;
        // SYMBIOTIC_COLLATERAL_USE_EXISTING_DEPLOYMENT = true;

        super.setUp();
    }

    function test_Simple() public {
        console2.log("Default Collaterals:", defaultCollaterals_SymbioticCollateral.length);

        for (uint256 i; i < defaultCollaterals_SymbioticCollateral.length; i++) {
            console2.log("Default Collateral:", defaultCollaterals_SymbioticCollateral[i]);

            console2.log(
                "Total stake before new staker:",
                ISymbioticDefaultCollateral(defaultCollaterals_SymbioticCollateral[i]).totalSupply()
            );

            Vm.Wallet memory newStaker = _getStakerWithStake_SymbioticCollateral(
                tokens_SymbioticCollateral, defaultCollaterals_SymbioticCollateral[i]
            );

            console2.log(
                "Total stake after new staker:",
                ISymbioticDefaultCollateral(defaultCollaterals_SymbioticCollateral[i]).totalSupply()
            );
            console2.log(
                "User stake:",
                ISymbioticDefaultCollateral(defaultCollaterals_SymbioticCollateral[i]).balanceOf(newStaker.addr)
            );
        }
    }
}
