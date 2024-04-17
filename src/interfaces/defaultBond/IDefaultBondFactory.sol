// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {IFactory} from "src/interfaces/IFactory.sol";

interface IDefaultBondFactory is IFactory {
    /**
     * @notice Create a default bond with a given asset.
     * @param asset address of the underlying asset
     * @return address of the created bond
     */
    function create(address asset) external returns (address);
}
