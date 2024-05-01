// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Factory} from "src/contracts/Factory.sol";
import {DefaultBond} from "./DefaultBond.sol";
import {IDefaultBondFactory} from "src/interfaces/defaultBond/IDefaultBondFactory.sol";

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

contract DefaultBondFactory is Factory, IDefaultBondFactory {
    using Clones for address;

    address private immutable BOND_IMPLEMENTATION;

    constructor() {
        BOND_IMPLEMENTATION = address(new DefaultBond());
    }

    /**
     * @inheritdoc IDefaultBondFactory
     */
    function create(address asset) external returns (address) {
        address bond = BOND_IMPLEMENTATION.clone();
        DefaultBond(bond).initialize(asset);

        _addEntity(bond);

        return bond;
    }
}
