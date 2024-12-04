// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SymbioticCollateralInit.sol";

contract SymbioticCollateralIntegration is SymbioticCollateralInit {
    address[] public tokens_SymbioticCollateral;

    address[] public defaultCollaterals_SymbioticCollateral;
    Vm.Wallet[] public stakers_SymbioticCollateral;

    address[] public existingTokens_SymbioticCollateral;
    address[] public existingDefaultCollaterals_SymbioticCollateral;

    uint256 public SYMBIOTIC_COLLATERAL_NUMBER_OF_STAKERS = 30;

    uint256 public SYMBIOTIC_COLLATERAL_DEPOSIT_INTO_COLLATERAL_CHANCE = 1; // lower -> higher probability
    uint256 public SYMBIOTIC_COLLATERAL_WITHDRAW_FROM_COLLATERAL_CHANCE = 3;

    function setUp() public virtual override {
        SymbioticCollateralInit.setUp();

        _addPossibleTokens_SymbioticCollateral();

        _loadExistingEntities_SymbioticCollateral();
        if (SYMBIOTIC_COLLATERAL_USE_EXISTING_DEPLOYMENT) {
            _addExistingEntities_SymbioticCollateral();
        }

        if (SYMBIOTIC_COLLATERAL_USE_EXISTING_DEPLOYMENT) {
            _createStakers_SymbioticCollateral(SYMBIOTIC_COLLATERAL_NUMBER_OF_STAKERS);
        } else {
            _createEnvironment_SymbioticCollateral();
        }
    }

    function _loadExistingEntities_SymbioticCollateral() internal virtual {
        _loadExistingDefaultCollateralsAndTokens_SymbioticCollateral();
    }

    function _loadExistingDefaultCollateralsAndTokens_SymbioticCollateral() internal virtual {
        if (SYMBIOTIC_COLLATERAL_USE_EXISTING_DEPLOYMENT) {
            uint256 numberOfDefaultCollaterals = symbioticDefaultCollateralFactory.totalEntities();
            for (uint256 i; i < numberOfDefaultCollaterals; ++i) {
                address defaultCollateral = symbioticDefaultCollateralFactory.entity(i);
                existingDefaultCollaterals_SymbioticCollateral.push(defaultCollateral);
                address asset = ISymbioticDefaultCollateral(defaultCollateral).asset();
                if (!_contains_Symbiotic(existingTokens_SymbioticCollateral, asset)) {
                    existingTokens_SymbioticCollateral.push(asset);
                }
            }
        }
    }

    function _addPossibleTokens_SymbioticCollateral() internal virtual {
        address[] memory supportedTokens = _getSupportedTokens_SymbioticCollateral();
        for (uint256 i; i < supportedTokens.length; ++i) {
            if (_supportsDeal_Symbiotic(supportedTokens[i])) {
                tokens_SymbioticCollateral.push(supportedTokens[i]);
            }
        }
        if (!SYMBIOTIC_COLLATERAL_USE_EXISTING_DEPLOYMENT) {
            tokens_SymbioticCollateral.push(_getToken_SymbioticCore());
            tokens_SymbioticCollateral.push(_getFeeOnTransferToken_SymbioticCore());
        }
    }

    function _addExistingEntities_SymbioticCollateral() internal virtual {
        _addExistingTokens_SymbioticCollateral();
        _addExistingDefaultCollaterals_SymbioticCollateral();
    }

    function _addExistingTokens_SymbioticCollateral() internal virtual {
        for (uint256 i; i < existingTokens_SymbioticCollateral.length; ++i) {
            if (
                !_contains_Symbiotic(tokens_SymbioticCollateral, existingTokens_SymbioticCollateral[i])
                    && _supportsDeal_Symbiotic(existingTokens_SymbioticCollateral[i])
            ) {
                tokens_SymbioticCollateral.push(existingTokens_SymbioticCollateral[i]);
            }
        }
    }

    function _addExistingDefaultCollaterals_SymbioticCollateral() internal virtual {
        for (uint256 i; i < existingDefaultCollaterals_SymbioticCollateral.length; ++i) {
            address asset = ISymbioticDefaultCollateral(existingDefaultCollaterals_SymbioticCollateral[i]).asset();
            if (
                !_contains_Symbiotic(
                    defaultCollaterals_SymbioticCollateral, existingDefaultCollaterals_SymbioticCollateral[i]
                ) && _supportsDeal_Symbiotic(asset)
            ) {
                defaultCollaterals_SymbioticCollateral.push(existingDefaultCollaterals_SymbioticCollateral[i]);
            }
        }
    }

    function _createEnvironment_SymbioticCollateral() internal virtual {
        _createParties_SymbioticCollateral(SYMBIOTIC_COLLATERAL_NUMBER_OF_STAKERS);

        _depositIntoDefaultCollaterals_SymbioticCollateral();
        _withdrawFromDefaultCollaterals_SymbioticCollateral();
    }

    function _createParties_SymbioticCollateral(
        uint256 numberOfStakers
    ) internal virtual {
        _createDefaultCollaterals_SymbioticCollateral();
        _createStakers_SymbioticCollateral(numberOfStakers);
    }

    function _createDefaultCollaterals_SymbioticCollateral() internal virtual {
        for (uint256 i; i < tokens_SymbioticCollateral.length; ++i) {
            defaultCollaterals_SymbioticCollateral.push(
                _getDefaultCollateralRandom_SymbioticCollateral(tokens_SymbioticCollateral[i])
            );
        }
    }

    function _createStakers_SymbioticCollateral(
        uint256 numberOfStakers
    ) internal virtual {
        for (uint256 i; i < numberOfStakers; ++i) {
            stakers_SymbioticCollateral.push(_getStaker_SymbioticCollateral(tokens_SymbioticCollateral));
        }
    }

    function _depositIntoDefaultCollaterals_SymbioticCollateral() internal virtual {
        for (uint256 i; i < stakers_SymbioticCollateral.length; ++i) {
            for (uint256 j; j < defaultCollaterals_SymbioticCollateral.length; ++j) {
                if (_randomChoice_Symbiotic(SYMBIOTIC_COLLATERAL_DEPOSIT_INTO_COLLATERAL_CHANCE)) {
                    _stakerDepositRandom_SymbioticCollateral(
                        stakers_SymbioticCollateral[i].addr, defaultCollaterals_SymbioticCollateral[j]
                    );
                }
            }
        }
    }

    function _withdrawFromDefaultCollaterals_SymbioticCollateral() internal virtual {
        for (uint256 i; i < stakers_SymbioticCollateral.length; ++i) {
            for (uint256 j; j < defaultCollaterals_SymbioticCollateral.length; ++j) {
                if (_randomChoice_Symbiotic(SYMBIOTIC_COLLATERAL_WITHDRAW_FROM_COLLATERAL_CHANCE)) {
                    _stakerWithdrawRandom_SymbioticCollateral(
                        stakers_SymbioticCollateral[i].addr, defaultCollaterals_SymbioticCollateral[j]
                    );
                }
            }
        }
    }
}
