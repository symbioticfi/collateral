// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SymbioticCollateralImports.sol";

import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {Test} from "forge-std/Test.sol";

contract SymbioticCollateralBindings is Test {
    using SafeERC20 for IERC20;

    function _createDefaultCollateral_SymbioticCollateral(
        ISymbioticDefaultCollateralFactory symbioticDefaultCollateralFactory,
        address who,
        address asset,
        uint256 initialLimit,
        address limitIncreaser
    ) internal virtual returns (address defaultCollateral) {
        vm.startPrank(who);
        defaultCollateral = symbioticDefaultCollateralFactory.create(asset, initialLimit, limitIncreaser);
        vm.stopPrank();
    }

    function _deposit_SymbioticCollateral(
        address who,
        address defaultCollateral,
        address recipient,
        uint256 amount
    ) internal virtual returns (uint256 collateralAmount) {
        vm.startPrank(who);
        IERC20(ISymbioticDefaultCollateral(defaultCollateral).asset()).forceApprove(defaultCollateral, amount);
        collateralAmount = ISymbioticDefaultCollateral(defaultCollateral).deposit(recipient, amount);
        vm.stopPrank();
    }

    function _deposit_SymbioticCollateral(
        address who,
        address defaultCollateral,
        uint256 amount
    ) internal virtual returns (uint256 collateralAmount) {
        _deposit_SymbioticCollateral(who, defaultCollateral, who, amount);
    }

    function _deposit_SymbioticCollateral(
        address who,
        address defaultCollateral,
        address recipient,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal virtual returns (uint256 collateralAmount) {
        vm.startPrank(who);
        IERC20(ISymbioticDefaultCollateral(defaultCollateral).asset()).forceApprove(defaultCollateral, amount);
        collateralAmount = ISymbioticDefaultCollateral(defaultCollateral).deposit(recipient, amount, deadline, v, r, s);
        vm.stopPrank();
    }

    function _deposit_SymbioticCollateral(
        address who,
        address defaultCollateral,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal virtual returns (uint256 collateralAmount) {
        _deposit_SymbioticCollateral(who, defaultCollateral, who, amount, deadline, v, r, s);
    }

    function _withdraw_SymbioticCollateral(
        address who,
        address defaultCollateral,
        address recipient,
        uint256 amount
    ) internal virtual {
        vm.startPrank(who);
        ISymbioticDefaultCollateral(defaultCollateral).withdraw(recipient, amount);
        vm.stopPrank();
    }

    function _withdraw_SymbioticCollateral(address who, address defaultCollateral, uint256 amount) internal virtual {
        _withdraw_SymbioticCollateral(who, defaultCollateral, who, amount);
    }

    function _increaseLimit_SymbioticCollateral(
        address who,
        address defaultCollateral,
        uint256 amount
    ) internal virtual {
        vm.startPrank(who);
        ISymbioticDefaultCollateral(defaultCollateral).increaseLimit(amount);
        vm.stopPrank();
    }

    function _setLimitIncreaser_SymbioticCollateral(
        address who,
        address defaultCollateral,
        address limitIncreaser
    ) internal virtual {
        vm.startPrank(who);
        ISymbioticDefaultCollateral(defaultCollateral).setLimitIncreaser(limitIncreaser);
        vm.stopPrank();
    }
}
