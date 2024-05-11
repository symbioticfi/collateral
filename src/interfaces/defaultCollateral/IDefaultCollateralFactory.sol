// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {IFactory} from "src/interfaces/IFactory.sol";

interface IDefaultCollateralFactory is IFactory {
    /**
     * @notice Create a default collateral with a given asset.
     * @param asset address of the underlying asset
     * @return address of the created collateral
     */
    function create(address asset) external returns (address);
}
