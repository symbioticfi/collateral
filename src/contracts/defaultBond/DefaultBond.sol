// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {IDefaultBond} from "src/interfaces/defaultBond/IDefaultBond.sol";
import {IBond} from "src/interfaces/IBond.sol";
import {Permit2Lib} from "src/contracts/libraries/Permit2Lib.sol";

import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract DefaultBond is ERC20Upgradeable, ReentrancyGuardUpgradeable, IDefaultBond {
    using SafeERC20 for IERC20;
    using Permit2Lib for IERC20;

    uint8 private DECIMALS;

    /**
     * @inheritdoc IBond
     */
    address public asset;

    /**
     * @inheritdoc IBond
     */
    uint256 public totalRepaidDebt;

    /**
     * @inheritdoc IBond
     */
    mapping(address issuer => uint256 amount) public issuerRepaidDebt;

    /**
     * @inheritdoc IBond
     */
    mapping(address recipient => uint256 amount) public recipientRepaidDebt;

    /**
     * @inheritdoc IBond
     */
    mapping(address issuer => mapping(address recipient => uint256 amount)) public repaidDebt;

    /**
     * @inheritdoc IBond
     */
    uint256 public totalDebt;

    /**
     * @inheritdoc IBond
     */
    mapping(address issuer => uint256 amount) public issuerDebt;

    /**
     * @inheritdoc IBond
     */
    mapping(address recipient => uint256 amount) public recipientDebt;

    /**
     * @inheritdoc IBond
     */
    mapping(address issuer => mapping(address recipient => uint256 amount)) public debt;

    constructor() {
        _disableInitializers();
    }

    function initialize(address asset_) external virtual initializer {
        __ERC20_init(
            string.concat("DefaultBond_", IERC20Metadata(asset_).name()),
            string.concat("DB_", IERC20Metadata(asset_).symbol())
        );
        __ReentrancyGuard_init();

        asset = asset_;

        DECIMALS = IERC20Metadata(asset).decimals();
    }

    /**
     * @inheritdoc ERC20Upgradeable
     */
    function decimals() public view override returns (uint8) {
        return DECIMALS;
    }

    /**
     * @inheritdoc IDefaultBond
     */
    function deposit(address recipient, uint256 amount) public override nonReentrant returns (uint256) {
        uint256 balanceBefore = IERC20(asset).balanceOf(address(this));
        IERC20(asset).transferFrom2(msg.sender, address(this), amount);
        uint256 toMint = IERC20(asset).balanceOf(address(this)) - balanceBefore;

        if (toMint == 0) {
            revert InsufficientDeposit();
        }

        _mint(recipient, toMint);

        return toMint;
    }

    /**
     * @inheritdoc IDefaultBond
     */
    function deposit(
        address recipient,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override returns (uint256) {
        IERC20(asset).tryPermit2(msg.sender, address(this), amount, deadline, v, r, s);

        return deposit(recipient, amount);
    }

    /**
     * @inheritdoc IDefaultBond
     */
    function withdraw(address recipient, uint256 amount) external override {
        if (amount == 0) {
            revert InsufficientWithdraw();
        }

        _burn(msg.sender, amount);

        IERC20(asset).safeTransfer(recipient, amount);
    }

    /**
     * @inheritdoc IBond
     */
    function issueDebt(address recipient, uint256 amount) external override {
        if (amount == 0) {
            revert InsufficientIssueDebt();
        }

        _burn(msg.sender, amount);

        emit IssueDebt(msg.sender, recipient, amount);

        totalRepaidDebt += amount;
        issuerRepaidDebt[msg.sender] += amount;
        recipientRepaidDebt[recipient] += amount;
        repaidDebt[msg.sender][recipient] += amount;

        IERC20(asset).safeTransfer(recipient, amount);

        emit RepayDebt(msg.sender, recipient, amount);
    }
}
