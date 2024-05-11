// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console2} from "forge-std/Test.sol";

import {DefaultCollateralFactory} from "src/contracts/defaultCollateral/DefaultCollateralFactory.sol";
import {DefaultCollateral} from "src/contracts/defaultCollateral/DefaultCollateral.sol";

import {Token} from "test/mocks/Token.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract DefaultCollateralFactoryTest is Test {
    address owner;
    address alice;
    uint256 alicePrivateKey;
    address bob;
    uint256 bobPrivateKey;

    DefaultCollateralFactory defaultCollateralFactory;
    DefaultCollateral defaultCollateral;

    IERC20 token;

    function setUp() public {
        owner = address(this);
        (alice, alicePrivateKey) = makeAddrAndKey("alice");
        (bob, bobPrivateKey) = makeAddrAndKey("bob");

        token = IERC20(new Token("Token"));
    }

    function test_Create() public {
        defaultCollateralFactory = new DefaultCollateralFactory();

        address defaultCollateralAddress = defaultCollateralFactory.create(address(token));
        defaultCollateral = DefaultCollateral(defaultCollateralAddress);
        assertEq(defaultCollateralFactory.isEntity(defaultCollateralAddress), true);

        assertEq(defaultCollateral.asset(), address(token));
        assertEq(defaultCollateral.decimals(), IERC20Metadata(address(token)).decimals());
    }
}
