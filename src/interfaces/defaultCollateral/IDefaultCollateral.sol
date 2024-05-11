// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {ICollateral} from "src/interfaces/ICollateral.sol";

interface IDefaultCollateral is ICollateral {
    error InsufficientDeposit();
    error InsufficientWithdraw();
    error InsufficientIssueDebt();

    /**
     * @notice Deposit a given amount of the underlying asset, and mint the collateral to a particular recipient.
     * @param recipient address of the collateral's recipient
     * @param amount amount of the underlying asset
     * @return amount of the collateral minted
     */
    function deposit(address recipient, uint256 amount) external returns (uint256);

    /**
     * @notice Deposit a given amount of the underlying asset using a permit functionality, and mint the collateral to a particular recipient.
     * @param recipient address of the collateral's recipient
     * @param amount amount of the underlying asset
     * @param deadline timestamp of the signature's deadline
     * @param v v component of the signature
     * @param r r component of the signature
     * @param s s component of the signature
     * @return amount of the collateral minted
     */
    function deposit(
        address recipient,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256);

    /**
     * @notice Withdraw a given amount of the underlying asset, and transfer it to a particular recipient.
     * @param recipient address of the underlying asset's recipient
     * @param amount amount of the underlying asset
     */
    function withdraw(address recipient, uint256 amount) external;
}
