// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@symbioticfi/core/test/integration/SymbioticInit.sol";
import {SymbioticCoreConstants} from "@symbioticfi/core/test/integration/SymbioticCoreConstants.sol";

import "./SymbioticDefaultCollateralImports.sol";

import {SymbioticDefaultCollateralConstants} from "./SymbioticDefaultCollateralConstants.sol";
import {SymbioticDefaultCollateralBindings} from "./SymbioticDefaultCollateralBindings.sol";

import {Token} from "../mocks/Token.sol";
import {FeeOnTransferToken} from "../mocks/FeeOnTransferToken.sol";

import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract SymbioticDefaultCollateralInit is SymbioticInit, SymbioticDefaultCollateralBindings {
    using SafeERC20 for IERC20;
    using Math for uint256;

    // General config

    string public SYMBIOTIC_DEFAULT_COLLATERAL_PROJECT_ROOT = "";
    bool public SYMBIOTIC_DEFAULT_COLLATERAL_USE_EXISTING_DEPLOYMENT = false;

    // DefaultCollateral-related config

    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_HAS_LIMIT_CHANCE = 1;
    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_MIN_TOKENS_LIMIT_TIMES_1e18 = 0 * 1e18;
    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_MAX_TOKENS_LIMIT_TIMES_1e18 = 1_000_000_000 * 1e18;

    // Staker-related config

    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_TOKENS_TO_SET_TIMES_1e18 = 100_000_000 * 1e18;
    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_MIN_TOKENS_TO_DEPOSIT_TIMES_1e18 = 0.001 * 1e18;
    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_MAX_TOKENS_TO_DEPOSIT_TIMES_1e18 = 10_000 * 1e18;

    // LimitIncreaser-related config

    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_MIN_INCREASE_LIMIT_TIMES_1e18 = 0.1 * 1e18;
    uint256 public SYMBIOTIC_DEFAULT_COLLATERAL_MAX_INCREASE_LIMIT_TIMES_1e18 = 1_000_000_000 * 1e18;

    ISymbioticDefaultCollateralFactory symbioticDefaultCollateralFactory;

    function setUp() public virtual override {
        super.setUp();

        _initDefaultCollateral_SymbioticDefaultCollateral(SYMBIOTIC_DEFAULT_COLLATERAL_USE_EXISTING_DEPLOYMENT);
    }

    // ------------------------------------------------------------ GENERAL HELPERS ------------------------------------------------------------ //

    function _initDefaultCollateral_SymbioticDefaultCollateral() internal virtual {
        symbioticDefaultCollateralFactory = SymbioticDefaultCollateralConstants.defaultCollateralFactory();
    }

    function _initDefaultCollateral_SymbioticDefaultCollateral(
        bool useExisting
    ) internal virtual {
        if (useExisting) {
            _initDefaultCollateral_SymbioticDefaultCollateral();
        } else {
            symbioticDefaultCollateralFactory = ISymbioticDefaultCollateralFactory(
                deployCode(
                    string.concat(
                        SYMBIOTIC_DEFAULT_COLLATERAL_PROJECT_ROOT,
                        "out/DefaultCollateralFactory.sol/DefaultCollateralFactory.json"
                    )
                )
            );
        }
    }

    // ------------------------------------------------------------ TOKEN-RELATED HELPERS ------------------------------------------------------------ //

    function _getToken_SymbioticDefaultCollateral() internal virtual returns (address) {
        return address(new Token("Token"));
    }

    function _getFeeOnTransferToken_SymbioticDefaultCollateral() internal virtual returns (address) {
        return address(new FeeOnTransferToken("Token"));
    }

    function _getSupportedTokens_SymbioticDefaultCollateral()
        internal
        virtual
        returns (address[] memory supportedTokens)
    {
        string[] memory supportedTokensStr = SymbioticCoreConstants.supportedTokens();
        supportedTokens = new address[](supportedTokensStr.length);
        for (uint256 i; i < supportedTokensStr.length; i++) {
            supportedTokens[i] = SymbioticCoreConstants.token(supportedTokensStr[i]);
        }
    }

    // ------------------------------------------------------------ DEFAULT-COLLATERAL-RELATED HELPERS ------------------------------------------------------------ //

    function _getDefaultCollateral_SymbioticDefaultCollateral(
        address asset
    ) internal virtual returns (address) {
        return _createDefaultCollateral_SymbioticDefaultCollateral(
            symbioticDefaultCollateralFactory, address(this), asset, type(uint256).max, address(0)
        );
    }

    function _getDefaultCollateral_SymbioticDefaultCollateral(
        address asset,
        uint256 initialLimit,
        address limitIncreaser
    ) internal virtual returns (address) {
        return _createDefaultCollateral_SymbioticDefaultCollateral(
            symbioticDefaultCollateralFactory, address(this), asset, initialLimit, limitIncreaser
        );
    }

    function _getDefaultCollateralRandom_SymbioticDefaultCollateral(
        address asset
    ) internal virtual returns (address) {
        bool hasLimit = _randomChoice_Symbiotic(SYMBIOTIC_DEFAULT_COLLATERAL_HAS_LIMIT_CHANCE);
        uint256 limit = hasLimit
            ? _randomWithBounds_Symbiotic(
                _normalizeForToken_Symbiotic(SYMBIOTIC_DEFAULT_COLLATERAL_MIN_TOKENS_LIMIT_TIMES_1e18, asset),
                _normalizeForToken_Symbiotic(SYMBIOTIC_DEFAULT_COLLATERAL_MAX_TOKENS_LIMIT_TIMES_1e18, asset)
            )
            : type(uint256).max;
        return _getDefaultCollateral_SymbioticDefaultCollateral(asset, limit, address(this));
    }

    // ------------------------------------------------------------ STAKER-RELATED HELPERS ------------------------------------------------------------ //

    function _getStaker_SymbioticDefaultCollateral(
        address[] memory possibleTokens
    ) internal virtual returns (Vm.Wallet memory) {
        Vm.Wallet memory staker = _getAccount_Symbiotic();

        for (uint256 i; i < possibleTokens.length; ++i) {
            deal(
                possibleTokens[i],
                staker.addr,
                _normalizeForToken_Symbiotic(SYMBIOTIC_DEFAULT_COLLATERAL_TOKENS_TO_SET_TIMES_1e18, possibleTokens[i]),
                true
            ); // should cover most cases
        }

        return staker;
    }

    function _getStakerWithStake_SymbioticDefaultCollateral(
        address[] memory possibleTokens,
        address defaultCollateral
    ) internal virtual returns (Vm.Wallet memory) {
        Vm.Wallet memory staker = _getStaker_SymbioticDefaultCollateral(possibleTokens);

        _stakerDepositRandom_SymbioticDefaultCollateral(staker.addr, defaultCollateral);

        return staker;
    }

    function _getStakerWithStake_SymbioticDefaultCollateral(
        address[] memory possibleTokens,
        address[] memory defaultCollaterals
    ) internal virtual returns (Vm.Wallet memory) {
        Vm.Wallet memory staker = _getStaker_SymbioticDefaultCollateral(possibleTokens);

        for (uint256 i; i < defaultCollaterals.length; ++i) {
            _stakerDepositRandom_SymbioticDefaultCollateral(staker.addr, defaultCollaterals[i]);
        }

        return staker;
    }

    function _stakerDeposit_SymbioticDefaultCollateral(
        address staker,
        address defaultCollateral,
        uint256 amount
    ) internal virtual {
        _deposit_SymbioticDefaultCollateral(staker, defaultCollateral, amount);
    }

    function _stakerDepositRandom_SymbioticDefaultCollateral(
        address staker,
        address defaultCollateral
    ) internal virtual {
        address asset = ISymbioticDefaultCollateral(defaultCollateral).asset();

        uint256 minAmount =
            _normalizeForToken_Symbiotic(SYMBIOTIC_DEFAULT_COLLATERAL_MIN_TOKENS_TO_DEPOSIT_TIMES_1e18, asset);
        uint256 amount = _randomWithBounds_Symbiotic(
            minAmount,
            _normalizeForToken_Symbiotic(SYMBIOTIC_DEFAULT_COLLATERAL_MAX_TOKENS_TO_DEPOSIT_TIMES_1e18, asset)
        );

        amount = Math.min(
            amount,
            ISymbioticDefaultCollateral(defaultCollateral).limit()
                - ISymbioticDefaultCollateral(defaultCollateral).totalSupply()
        );

        if (amount >= minAmount) {
            _stakerDeposit_SymbioticDefaultCollateral(staker, defaultCollateral, amount);
        }
    }

    function _stakerWithdraw_SymbioticDefaultCollateral(
        address staker,
        address defaultCollateral,
        uint256 amount
    ) internal virtual {
        _withdraw_SymbioticDefaultCollateral(staker, defaultCollateral, amount);
    }

    function _stakerWithdrawRandom_SymbioticDefaultCollateral(
        address staker,
        address defaultCollateral
    ) internal virtual {
        uint256 balance = ISymbioticDefaultCollateral(defaultCollateral).balanceOf(staker);

        if (balance == 0) {
            return;
        }

        uint256 amount = _randomWithBounds_Symbiotic(1, balance);

        _stakerWithdraw_SymbioticDefaultCollateral(staker, defaultCollateral, amount);
    }

    // ------------------------------------------------------------ LIMIT-INCREASER-RELATED HELPERS ------------------------------------------------------------ //

    function _limitIncreaserIncreaseLimit_SymbioticDefaultCollateral(
        address limitIncreaser,
        address defaultCollateral,
        uint256 amount
    ) internal virtual {
        _increaseLimit_SymbioticDefaultCollateral(defaultCollateral, limitIncreaser, amount);
    }

    function _limitIncreaserIncreaseLimitRandom_SymbioticDefaultCollateral(
        address limitIncreaser,
        address defaultCollateral
    ) internal virtual {
        address asset = ISymbioticDefaultCollateral(defaultCollateral).asset();

        uint256 minAmount =
            _normalizeForToken_Symbiotic(SYMBIOTIC_DEFAULT_COLLATERAL_MIN_INCREASE_LIMIT_TIMES_1e18, asset);
        uint256 amount = _randomWithBounds_Symbiotic(
            minAmount, _normalizeForToken_Symbiotic(SYMBIOTIC_DEFAULT_COLLATERAL_MAX_INCREASE_LIMIT_TIMES_1e18, asset)
        );

        amount = Math.min(amount, type(uint256).max - ISymbioticDefaultCollateral(defaultCollateral).limit());

        if (amount >= minAmount) {
            _limitIncreaserIncreaseLimit_SymbioticDefaultCollateral(limitIncreaser, defaultCollateral, amount);
        }
    }
}
