// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console2} from "forge-std/Test.sol";

import {Factory} from "src/contracts/Factory.sol";

contract RegistryTest is Test {
    address owner;
    address alice;
    uint256 alicePrivateKey;
    address bob;
    uint256 bobPrivateKey;

    Factory factory;

    function setUp() public {
        owner = address(this);
        (alice, alicePrivateKey) = makeAddrAndKey("alice");
        (bob, bobPrivateKey) = makeAddrAndKey("bob");

        factory = new Factory();
    }

    function test_Init() public {
        assertEq(factory.totalEntities(), 0);
        assertEq(factory.isEntity(alice), false);
        vm.expectRevert();
        factory.entity(0);
    }
}
