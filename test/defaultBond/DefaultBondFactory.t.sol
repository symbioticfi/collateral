// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console2} from "forge-std/Test.sol";

import {DefaultBondFactory} from "src/contracts/defaultBond/DefaultBondFactory.sol";
import {DefaultBond} from "src/contracts/defaultBond/DefaultBond.sol";

import {Token} from "test/mocks/Token.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DefaultPropertyTest is Test {
    address owner;
    address alice;
    uint256 alicePrivateKey;
    address bob;
    uint256 bobPrivateKey;

    DefaultBondFactory defaultBondFactory;
    DefaultBond defaultBond;

    IERC20 token;

    function setUp() public {
        owner = address(this);
        (alice, alicePrivateKey) = makeAddrAndKey("alice");
        (bob, bobPrivateKey) = makeAddrAndKey("bob");

        token = IERC20(new Token("Token"));
    }

    function test_Create() public {
        defaultBondFactory = new DefaultBondFactory();

        address defaultBondAddress = defaultBondFactory.create(address(token));
        defaultBond = DefaultBond(defaultBondAddress);
        assertEq(defaultBondFactory.isEntity(defaultBondAddress), true);

        assertEq(defaultBond.asset(), address(token));
    }
}
