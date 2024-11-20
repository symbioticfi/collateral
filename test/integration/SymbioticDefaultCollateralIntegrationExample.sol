// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SymbioticDefaultCollateralIntegration.sol";

import {console2} from "forge-std/Test.sol";

contract SymbioticDefaultCollateralIntegrationExample is SymbioticDefaultCollateralIntegration {
    function setUp() public override {
        SYMBIOTIC_DEFAULT_COLLATERAL_PROJECT_ROOT = "";
        // vm.selectFork(vm.createFork(vm.rpcUrl("mainnet")));
        // SYMBIOTIC_INIT_BLOCK = 21_227_029;
        // SYMBIOTIC_DEFAULT_COLLATERAL_USE_EXISTING_DEPLOYMENT = true;

        super.setUp();
    }

    function test_Simple() public {
        console2.log("Default Collaterals:", defaultCollaterals_SymbioticDefaultCollateral.length);

        for (uint256 i; i < defaultCollaterals_SymbioticDefaultCollateral.length; i++) {
            console2.log("Default Collateral:", defaultCollaterals_SymbioticDefaultCollateral[i]);

            console2.log(
                "Total stake before new staker:",
                ISymbioticDefaultCollateral(defaultCollaterals_SymbioticDefaultCollateral[i]).totalSupply()
            );

            Vm.Wallet memory newStaker = _getStakerWithStake_SymbioticDefaultCollateral(
                tokens_SymbioticDefaultCollateral, defaultCollaterals_SymbioticDefaultCollateral[i]
            );

            console2.log(
                "Total stake after new staker:",
                ISymbioticDefaultCollateral(defaultCollaterals_SymbioticDefaultCollateral[i]).totalSupply()
            );
            console2.log(
                "User stake:",
                ISymbioticDefaultCollateral(defaultCollaterals_SymbioticDefaultCollateral[i]).balanceOf(newStaker.addr)
            );
        }
    }
}
