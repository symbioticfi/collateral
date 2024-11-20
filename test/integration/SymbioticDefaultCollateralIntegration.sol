// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SymbioticDefaultCollateralInit.sol";

contract SymbioticDefaultCollateralIntegration is SymbioticDefaultCollateralInit {
    address[] public tokens_SymbioticDefaultCollateral;

    address[] public defaultCollaterals_SymbioticDefaultCollateral;
    Vm.Wallet[] public stakers_SymbioticDefaultCollateral;

    address[] public existingTokens_SymbioticDefaultCollateral;
    address[] public existingDefaultCollaterals_SymbioticDefaultCollateral;

    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_NUMBER_OF_STAKERS = 30;

    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_DEPOSIT_INTO_DEFAULT_COLLATERAL_CHANCE = 1; // lower -> higher probability
    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_WITHDRAW_FROM_DEFAULT_COLLATERAL_CHANCE = 3;

    function setUp() public virtual override {
        super.setUp();

        _addPossibleTokens_SymbioticDefaultCollateral();

        _loadExistingEntities_SymbioticDefaultCollateral();
        if (SYMBIOTIC_DEFAULT_COLLATERAL_USE_EXISTING_DEPLOYMENT) {
            _addExistingEntities_SymbioticDefaultCollateral();
        }

        if (SYMBIOTIC_DEFAULT_COLLATERAL_USE_EXISTING_DEPLOYMENT) {
            _createStakers_SymbioticDefaultCollateral(SYMBIOTIC_DEFAULT_COLLATERAL_NUMBER_OF_STAKERS);
        } else {
            _createEnvironment_SymbioticDefaultCollateral();
        }
    }

    function _loadExistingEntities_SymbioticDefaultCollateral() internal virtual {
        _loadExistingDefaultCollateralsAndTokens_SymbioticDefaultCollateral();
    }

    function _loadExistingDefaultCollateralsAndTokens_SymbioticDefaultCollateral() internal virtual {
        if (SYMBIOTIC_DEFAULT_COLLATERAL_USE_EXISTING_DEPLOYMENT) {
            uint256 numberOfDefaultCollaterals =
                ISymbioticFactoryLegacy(symbioticDefaultCollateralFactory).totalEntities();
            for (uint256 i; i < numberOfDefaultCollaterals; ++i) {
                address defaultCollateral = ISymbioticFactoryLegacy(symbioticDefaultCollateralFactory).entity(i);
                existingDefaultCollaterals_SymbioticDefaultCollateral.push(defaultCollateral);
                address asset = ISymbioticDefaultCollateral(defaultCollateral).asset();
                if (!_contains_Symbiotic(existingTokens_SymbioticDefaultCollateral, asset)) {
                    existingTokens_SymbioticDefaultCollateral.push(asset);
                }
            }
        }
    }

    function _addPossibleTokens_SymbioticDefaultCollateral() internal virtual {
        address[] memory supportedTokens = _getSupportedTokens_SymbioticDefaultCollateral();
        for (uint256 i; i < supportedTokens.length; i++) {
            if (_supportsDeal_Symbiotic(supportedTokens[i])) {
                tokens_SymbioticDefaultCollateral.push(supportedTokens[i]);
            }
        }
        if (!SYMBIOTIC_DEFAULT_COLLATERAL_USE_EXISTING_DEPLOYMENT) {
            tokens_SymbioticDefaultCollateral.push(_getToken_SymbioticDefaultCollateral());
            tokens_SymbioticDefaultCollateral.push(_getFeeOnTransferToken_SymbioticDefaultCollateral());
        }
    }

    function _addExistingEntities_SymbioticDefaultCollateral() internal virtual {
        _addExistingTokens_SymbioticDefaultCollateral();
        _addExistingDefaultCollaterals_SymbioticDefaultCollateral();
    }

    function _addExistingTokens_SymbioticDefaultCollateral() internal virtual {
        for (uint256 i; i < existingTokens_SymbioticDefaultCollateral.length; ++i) {
            if (
                !_contains_Symbiotic(tokens_SymbioticDefaultCollateral, existingTokens_SymbioticDefaultCollateral[i])
                    && _supportsDeal_Symbiotic(existingTokens_SymbioticDefaultCollateral[i])
            ) {
                tokens_SymbioticDefaultCollateral.push(existingTokens_SymbioticDefaultCollateral[i]);
            }
        }
    }

    function _addExistingDefaultCollaterals_SymbioticDefaultCollateral() internal virtual {
        for (uint256 i; i < existingDefaultCollaterals_SymbioticDefaultCollateral.length; ++i) {
            address asset =
                ISymbioticDefaultCollateral(existingDefaultCollaterals_SymbioticDefaultCollateral[i]).asset();
            if (
                !_contains_Symbiotic(
                    defaultCollaterals_SymbioticDefaultCollateral,
                    existingDefaultCollaterals_SymbioticDefaultCollateral[i]
                ) && _supportsDeal_Symbiotic(asset)
            ) {
                defaultCollaterals_SymbioticDefaultCollateral.push(
                    existingDefaultCollaterals_SymbioticDefaultCollateral[i]
                );
            }
        }
    }

    function _createEnvironment_SymbioticDefaultCollateral() internal virtual {
        _createParties_SymbioticDefaultCollateral(SYMBIOTIC_DEFAULT_COLLATERAL_NUMBER_OF_STAKERS);

        _depositIntoDefaultCollaterals_SymbioticDefaultCollateral();
        _withdrawFromDefaultCollaterals_SymbioticDefaultCollateral();
    }

    function _createParties_SymbioticDefaultCollateral(
        uint256 numberOfStakers
    ) internal virtual {
        _createDefaultCollaterals_SymbioticDefaultCollateral();
        _createStakers_SymbioticDefaultCollateral(numberOfStakers);
    }

    function _createDefaultCollaterals_SymbioticDefaultCollateral() internal virtual {
        for (uint256 i; i < tokens_SymbioticDefaultCollateral.length; ++i) {
            defaultCollaterals_SymbioticDefaultCollateral.push(
                _getDefaultCollateralRandom_SymbioticDefaultCollateral(tokens_SymbioticDefaultCollateral[i])
            );
        }
    }

    function _createStakers_SymbioticDefaultCollateral(
        uint256 numberOfStakers
    ) internal virtual {
        for (uint256 i; i < numberOfStakers; ++i) {
            stakers_SymbioticDefaultCollateral.push(
                _getStaker_SymbioticDefaultCollateral(tokens_SymbioticDefaultCollateral)
            );
        }
    }

    function _depositIntoDefaultCollaterals_SymbioticDefaultCollateral() internal virtual {
        for (uint256 i; i < stakers_SymbioticDefaultCollateral.length; ++i) {
            for (uint256 j; j < defaultCollaterals_SymbioticDefaultCollateral.length; ++j) {
                if (_randomChoice_Symbiotic(SYMBIOTIC_DEFAULT_COLLATERAL_DEPOSIT_INTO_DEFAULT_COLLATERAL_CHANCE)) {
                    _stakerDepositRandom_SymbioticDefaultCollateral(
                        stakers_SymbioticDefaultCollateral[i].addr, defaultCollaterals_SymbioticDefaultCollateral[j]
                    );
                }
            }
        }
    }

    function _withdrawFromDefaultCollaterals_SymbioticDefaultCollateral() internal virtual {
        for (uint256 i; i < stakers_SymbioticDefaultCollateral.length; ++i) {
            for (uint256 j; j < defaultCollaterals_SymbioticDefaultCollateral.length; ++j) {
                if (_randomChoice_Symbiotic(SYMBIOTIC_DEFAULT_COLLATERAL_WITHDRAW_FROM_DEFAULT_COLLATERAL_CHANCE)) {
                    _stakerWithdrawRandom_SymbioticDefaultCollateral(
                        stakers_SymbioticDefaultCollateral[i].addr, defaultCollaterals_SymbioticDefaultCollateral[j]
                    );
                }
            }
        }
    }
}
