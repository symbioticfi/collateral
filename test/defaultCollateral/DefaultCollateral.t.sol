// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console2} from "forge-std/Test.sol";

import {DefaultCollateralFactory} from "src/contracts/defaultCollateral/DefaultCollateralFactory.sol";
import {DefaultCollateral} from "src/contracts/defaultCollateral/DefaultCollateral.sol";
import {IDefaultCollateral} from "src/interfaces/defaultCollateral/IDefaultCollateral.sol";

import {Token} from "test/mocks/Token.sol";
import {PermitToken} from "test/mocks/PermitToken.sol";
import {DAILikeToken} from "test/mocks/DAILikeToken.sol";

import {Permit2Lib} from "permit2/src/libraries/Permit2Lib.sol";
import {IPermit2} from "permit2/src/interfaces/IPermit2.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract DefaultCollateralTest is Test {
    address public DEAD = address(0xdEaD);

    bytes32 public constant _PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    bytes32 public constant _PERMIT_DETAILS_TYPEHASH =
        keccak256("PermitDetails(address token,uint160 amount,uint48 expiration,uint48 nonce)");

    bytes32 public constant _PERMIT_SINGLE_TYPEHASH = keccak256(
        "PermitSingle(PermitDetails details,address spender,uint256 sigDeadline)PermitDetails(address token,uint160 amount,uint48 expiration,uint48 nonce)"
    );

    address owner;
    address alice;
    uint256 alicePrivateKey;
    address bob;
    uint256 bobPrivateKey;

    DefaultCollateralFactory defaultCollateralFactory;

    DefaultCollateral defaultCollateralToken;
    DefaultCollateral defaultCollateralPermitToken;
    DefaultCollateral defaultCollateralDaiLikeToken;

    IERC20 token;
    IERC20 permitToken;
    IERC20 daiLikeToken;

    function setUp() public {
        uint256 mainnetFork = vm.createFork(vm.rpcUrl("mainnet"));
        vm.selectFork(mainnetFork);

        owner = address(this);
        (alice, alicePrivateKey) = makeAddrAndKey("alice");
        (bob, bobPrivateKey) = makeAddrAndKey("bob");

        token = IERC20(new Token("Token"));
        permitToken = IERC20(new PermitToken("PermitToken"));
        daiLikeToken = IERC20(new DAILikeToken(block.chainid));

        defaultCollateralFactory = new DefaultCollateralFactory();

        address defaultCollateralAddress = defaultCollateralFactory.create(address(token));
        defaultCollateralToken = DefaultCollateral(defaultCollateralAddress);

        defaultCollateralAddress = defaultCollateralFactory.create(address(permitToken));
        defaultCollateralPermitToken = DefaultCollateral(defaultCollateralAddress);

        defaultCollateralAddress = defaultCollateralFactory.create(address(daiLikeToken));
        defaultCollateralDaiLikeToken = DefaultCollateral(defaultCollateralAddress);

        token.transfer(alice, 100 * 1e18);
        token.transfer(bob, 100 * 1e18);
        permitToken.transfer(alice, 100 * 1e18);
        permitToken.transfer(bob, 100 * 1e18);
        daiLikeToken.transfer(alice, 100 * 1e18);
        daiLikeToken.transfer(bob, 100 * 1e18);

        vm.startPrank(alice);
        token.approve(address(defaultCollateralToken), type(uint256).max);
        token.approve(address(Permit2Lib.PERMIT2), type(uint256).max);
        permitToken.approve(address(Permit2Lib.PERMIT2), type(uint256).max);
        daiLikeToken.approve(address(Permit2Lib.PERMIT2), type(uint256).max);
        vm.stopPrank();
        vm.startPrank(bob);
        token.approve(address(defaultCollateralToken), type(uint256).max);
        token.approve(address(Permit2Lib.PERMIT2), type(uint256).max);
        permitToken.approve(address(Permit2Lib.PERMIT2), type(uint256).max);
        daiLikeToken.approve(address(Permit2Lib.PERMIT2), type(uint256).max);
        vm.stopPrank();
    }

    function test_ReinitRevert() public {
        vm.expectRevert();
        defaultCollateralToken.initialize(address(token));
    }

    function test_Deposit(uint256 amount) public {
        amount = bound(amount, 10, 50 * 1e18);
        _deposit(alice, token, amount);

        assertEq(defaultCollateralToken.balanceOf(alice), amount);
    }

    function test_DepositRevertInsufficientDeposit() public {
        vm.expectRevert(IDefaultCollateral.InsufficientDeposit.selector);
        _deposit(alice, token, 0);
    }

    function test_DepositWithPermit(uint256 amount) public {
        amount = bound(amount, 10, 50 * 1e18);
        _depositWithPermit(alice, amount, type(uint32).max);

        assertEq(defaultCollateralPermitToken.balanceOf(alice), amount);
    }

    function test_DepositWithPermit2(uint256 amount) public {
        amount = bound(amount, 10, 50 * 1e18);
        _depositWithPermit2(alice, amount, type(uint32).max);

        assertEq(defaultCollateralToken.balanceOf(alice), amount);
    }

    function test_DepositWithDAIPermit(uint256 amount) public {
        amount = bound(amount, 10, 50 * 1e18);
        _depositWithDAIPermit(alice, amount, type(uint32).max);

        assertEq(defaultCollateralDaiLikeToken.balanceOf(alice), amount);
    }

    function test_DepositOnBehalfOf(uint256 amount) public {
        amount = bound(amount, 10, 50 * 1e18);
        vm.startPrank(alice);
        defaultCollateralToken.deposit(bob, amount);
        vm.stopPrank();

        assertEq(defaultCollateralToken.balanceOf(alice), 0);
        assertEq(defaultCollateralToken.balanceOf(bob), amount);
    }

    function test_DepositTwice(uint256 amount1, uint256 amount2) public {
        amount1 = bound(amount1, 10, 50 * 1e18);
        amount2 = bound(amount2, 10, 50 * 1e18);
        _deposit(alice, token, amount1);
        assertEq(defaultCollateralToken.balanceOf(alice), amount1);
        _deposit(alice, token, amount2);
        assertEq(defaultCollateralToken.balanceOf(alice), amount1 + amount2);
    }

    function test_DepositBoth(uint256 amount1, uint256 amount2) public {
        amount1 = bound(amount1, 10, 50 * 1e18);
        amount2 = bound(amount2, 10, 50 * 1e18);
        _deposit(alice, token, amount1);
        _deposit(bob, token, amount2);

        assertEq(defaultCollateralToken.balanceOf(alice), amount1);
        assertEq(defaultCollateralToken.balanceOf(bob), amount2);
    }

    function test_Withdraw(uint256 amount) public {
        amount = bound(amount, 10, 50 * 1e18);
        _deposit(alice, token, amount);
        uint256 aliceBalance = token.balanceOf(alice);
        uint256 amount_ = defaultCollateralToken.balanceOf(alice);
        _withdraw(alice, alice, token, amount);

        assertEq(token.balanceOf(alice) - aliceBalance, amount);
        assertEq(token.balanceOf(alice) - aliceBalance, amount_);
        assertEq(defaultCollateralToken.balanceOf(alice), 0);
    }

    function test_WithdrawRevertInsufficientWithdraw(uint256 amount) public {
        amount = bound(amount, 10, 50 * 1e18);
        _deposit(alice, token, amount);
        vm.expectRevert(IDefaultCollateral.InsufficientWithdraw.selector);
        _withdraw(alice, alice, token, 0);
    }

    function test_WithdrawRevertERC20InsufficientBalance(uint256 amount) public {
        amount = bound(amount, 10, 50 * 1e18);
        _deposit(alice, token, amount);
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InsufficientBalance.selector, alice, amount, type(uint240).max)
        );
        _withdraw(alice, alice, token, type(uint240).max);
    }

    function test_WithdrawTwice(uint256 amount1, uint256 amount2) public {
        amount1 = bound(amount1, 10, 50 * 1e18);
        amount2 = bound(amount2, 10, 50 * 1e18);
        _deposit(alice, token, amount1 + amount2);
        uint256 aliceBalance = token.balanceOf(alice);
        _withdraw(alice, alice, token, amount1);
        assertEq(token.balanceOf(alice) - aliceBalance, amount1);
        assertEq(defaultCollateralToken.balanceOf(alice), amount2);
        _withdraw(alice, alice, token, amount2);
        assertEq(token.balanceOf(alice) - aliceBalance, amount1 + amount2);
        assertEq(defaultCollateralToken.balanceOf(alice), 0);
    }

    function test_WithdrawBoth(uint256 amount1, uint256 amount2) public {
        amount1 = bound(amount1, 10, 50 * 1e18);
        amount2 = bound(amount2, 10, 50 * 1e18);
        _deposit(alice, token, amount1);
        _deposit(bob, token, amount2);
        uint256 aliceBalance = token.balanceOf(alice);
        _withdraw(alice, alice, token, amount1);
        uint256 bobBalance = token.balanceOf(bob);
        _withdraw(bob, bob, token, amount2);

        assertEq(token.balanceOf(alice) - aliceBalance, amount1);
        assertEq(defaultCollateralToken.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob) - bobBalance, amount2);
        assertEq(defaultCollateralToken.balanceOf(bob), 0);
    }

    function test_Issue(uint256 toMint, uint256 toIssue) public {
        toMint = bound(toMint, 10, 50 * 1e18);
        toIssue = bound(toIssue, 10, 50 * 1e18);
        vm.assume(toMint >= toIssue);

        _deposit(alice, token, toMint);

        assertEq(defaultCollateralToken.totalRepaidDebt(), 0);
        assertEq(defaultCollateralToken.issuerRepaidDebt(alice), 0);
        assertEq(defaultCollateralToken.recipientRepaidDebt(DEAD), 0);
        assertEq(defaultCollateralToken.repaidDebt(alice, DEAD), 0);
        assertEq(defaultCollateralToken.totalDebt(), 0);
        assertEq(defaultCollateralToken.issuerDebt(alice), 0);
        assertEq(defaultCollateralToken.recipientDebt(DEAD), 0);
        assertEq(defaultCollateralToken.debt(alice, DEAD), 0);

        uint256 aliceBalance = token.balanceOf(alice);
        uint256 deadBalance = token.balanceOf(DEAD);
        _issueDebt(alice, DEAD, token, toIssue);

        assertEq(token.balanceOf(alice) - aliceBalance, 0);
        assertEq(token.balanceOf(DEAD) - deadBalance, toIssue);
        assertEq(defaultCollateralToken.balanceOf(alice), toMint - toIssue);

        assertEq(defaultCollateralToken.totalRepaidDebt(), toIssue);
        assertEq(defaultCollateralToken.issuerRepaidDebt(alice), toIssue);
        assertEq(defaultCollateralToken.issuerRepaidDebt(bob), 0);
        assertEq(defaultCollateralToken.recipientRepaidDebt(DEAD), toIssue);
        assertEq(defaultCollateralToken.recipientRepaidDebt(alice), 0);
        assertEq(defaultCollateralToken.repaidDebt(alice, DEAD), toIssue);
        assertEq(defaultCollateralToken.repaidDebt(alice, alice), 0);
        assertEq(defaultCollateralToken.totalDebt(), 0);
        assertEq(defaultCollateralToken.issuerDebt(alice), 0);
        assertEq(defaultCollateralToken.recipientDebt(DEAD), 0);
        assertEq(defaultCollateralToken.debt(alice, DEAD), 0);
    }

    function test_IssueRevertInsufficientIssueDebt(uint256 amount) public {
        amount = bound(amount, 10, 50 * 1e18);
        _deposit(alice, token, amount);
        vm.expectRevert(IDefaultCollateral.InsufficientIssueDebt.selector);
        _issueDebt(alice, alice, token, 0);
    }

    function test_IssueRevertERC20InsufficientBalance(uint256 amount) public {
        amount = bound(amount, 10, 50 * 1e18);
        _deposit(alice, token, amount);
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InsufficientBalance.selector, alice, amount, type(uint240).max)
        );
        _issueDebt(alice, alice, token, type(uint240).max);
    }

    function test_IssueTwice(uint256 amount1, uint256 amount2) public {
        amount1 = bound(amount1, 10, 50 * 1e18);
        amount2 = bound(amount2, 10, 50 * 1e18);
        _deposit(alice, token, amount1 + amount2);
        uint256 aliceBalance = token.balanceOf(alice);
        _issueDebt(alice, alice, token, amount1);
        assertEq(token.balanceOf(alice) - aliceBalance, amount1);
        assertEq(defaultCollateralToken.balanceOf(alice), amount2);
        _issueDebt(alice, alice, token, amount2);
        assertEq(token.balanceOf(alice) - aliceBalance, amount1 + amount2);
        assertEq(defaultCollateralToken.balanceOf(alice), 0);
    }

    function test_IssueBoth(uint256 amount1, uint256 amount2) public {
        amount1 = bound(amount1, 10, 50 * 1e18);
        amount2 = bound(amount2, 10, 50 * 1e18);
        _deposit(alice, token, amount1);
        _deposit(bob, token, amount2);
        uint256 aliceBalance = token.balanceOf(alice);
        _issueDebt(alice, alice, token, amount1);
        uint256 bobBalance = token.balanceOf(bob);
        _issueDebt(bob, bob, token, amount2);

        assertEq(token.balanceOf(alice) - aliceBalance, amount1);
        assertEq(defaultCollateralToken.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob) - bobBalance, amount2);
        assertEq(defaultCollateralToken.balanceOf(bob), 0);
    }

    function _deposit(address user, IERC20 token_, uint256 amount) internal {
        vm.startPrank(user);
        if (address(token_) == address(token)) {
            defaultCollateralToken.deposit(user, amount);
        } else if (address(token_) == address(permitToken)) {
            defaultCollateralPermitToken.deposit(user, amount);
        } else if (address(token_) == address(daiLikeToken)) {
            defaultCollateralDaiLikeToken.deposit(user, amount);
        }
        vm.stopPrank();
    }

    function _depositWithPermit(address user, uint256 amount, uint256 deadline) internal {
        uint256 nonce = IERC20Permit(address(permitToken)).nonces(user);

        bytes32 DOMAIN_SEPARATOR = IERC20Permit(address(permitToken)).DOMAIN_SEPARATOR();

        bytes32 msgHash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(_PERMIT_TYPEHASH, user, address(defaultCollateralPermitToken), amount, nonce, deadline)
                )
            )
        );

        uint8 v;
        bytes32 r;
        bytes32 s;
        if (user == alice) {
            (v, r, s) = vm.sign(alicePrivateKey, msgHash);
        } else if (user == bob) {
            (v, r, s) = vm.sign(bobPrivateKey, msgHash);
        }

        vm.startPrank(user);
        defaultCollateralPermitToken.deposit(user, amount, deadline, v, r, s);
        vm.stopPrank();
    }

    function _depositWithPermit2(address user, uint256 amount, uint256 deadline) internal {
        (,, uint48 nonce) =
            IPermit2(address(Permit2Lib.PERMIT2)).allowance(user, address(token), address(defaultCollateralToken));

        IAllowanceTransfer.PermitDetails memory details = IAllowanceTransfer.PermitDetails({
            token: address(token),
            amount: uint160(amount),
            expiration: type(uint48).max,
            nonce: nonce
        });

        IAllowanceTransfer.PermitSingle memory permit = IAllowanceTransfer.PermitSingle({
            details: details,
            spender: address(defaultCollateralToken),
            sigDeadline: deadline
        });

        bytes32 DOMAIN_SEPARATOR = IPermit2(address(Permit2Lib.PERMIT2)).DOMAIN_SEPARATOR();

        bytes32 permitHash = keccak256(abi.encode(_PERMIT_DETAILS_TYPEHASH, permit.details));

        bytes32 msgHash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(_PERMIT_SINGLE_TYPEHASH, permitHash, permit.spender, permit.sigDeadline))
            )
        );

        uint8 v;
        bytes32 r;
        bytes32 s;
        if (user == alice) {
            (v, r, s) = vm.sign(alicePrivateKey, msgHash);
        } else if (user == bob) {
            (v, r, s) = vm.sign(bobPrivateKey, msgHash);
        }

        vm.startPrank(user);
        defaultCollateralToken.deposit(user, amount, deadline, v, r, s);
        vm.stopPrank();
    }

    function _depositWithDAIPermit(address user, uint256 amount, uint256 deadline) internal {
        uint256 nonce = DAILikeToken(address(daiLikeToken)).nonces(user);

        bytes32 PERMIT_TYPEHASH = DAILikeToken(address(daiLikeToken)).PERMIT_TYPEHASH();
        bytes32 DOMAIN_SEPARATOR = DAILikeToken(address(daiLikeToken)).DOMAIN_SEPARATOR();

        bytes32 msgHash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(PERMIT_TYPEHASH, user, address(defaultCollateralDaiLikeToken), nonce, deadline, true)
                )
            )
        );

        uint8 v;
        bytes32 r;
        bytes32 s;
        if (user == alice) {
            (v, r, s) = vm.sign(alicePrivateKey, msgHash);
        } else if (user == bob) {
            (v, r, s) = vm.sign(bobPrivateKey, msgHash);
        }

        vm.startPrank(user);
        defaultCollateralDaiLikeToken.deposit(user, amount, deadline, v, r, s);
        vm.stopPrank();
    }

    function _withdraw(address user, address recipient, IERC20 token_, uint256 amount) internal {
        vm.startPrank(user);
        if (address(token_) == address(token)) {
            defaultCollateralToken.withdraw(recipient, amount);
        } else if (address(token_) == address(permitToken)) {
            defaultCollateralPermitToken.withdraw(recipient, amount);
        } else if (address(token_) == address(daiLikeToken)) {
            defaultCollateralDaiLikeToken.withdraw(recipient, amount);
        }
        vm.stopPrank();
    }

    function _issueDebt(address user, address recipient, IERC20 token_, uint256 amount) internal {
        vm.startPrank(user);
        if (address(token_) == address(token)) {
            defaultCollateralToken.issueDebt(recipient, amount);
        } else if (address(token_) == address(permitToken)) {
            defaultCollateralPermitToken.issueDebt(recipient, amount);
        } else if (address(token_) == address(daiLikeToken)) {
            defaultCollateralDaiLikeToken.issueDebt(recipient, amount);
        }
        vm.stopPrank();
    }
}
