## Bond

### General Overview

Any operator wishing to operate in a Proof of Stake (POS) system must have a stake. This stake must be locked in some manner, somewhere. There are solutions that make such a stake liquid, yet the original funds remain locked, and in exchange, depositors/delegators receive LST tokens. They can then operate with these LST tokens. The reasons for locking the original funds include the need for immediate slashing if an operator misbehaves. This requirement for instant action necessitates having the stake locked, a limitation imposed by the current design of POS systems.

BondToken introduces a new type of asset that allows stakeholders to hold onto their funds and earn yield from them without needing to lock these funds in direct manner or convert them to another type of asset. BondToken represents an asset but does not require physically holding or locking this asset. The collateral backing the BondToken can be in various forms, such as a liquidity pool position, some real-world asset, or generally any type of asset. Depending on the implementation of BondToken, this collateral asset can be held within the BondToken itself or elsewhere.

1. BondToken represents an asset, which can be obtained through the asset() method of BondToken.
2. Holding any amount of BondToken signifies a commitment that an equal amount of the BondToken.asset() exists and is accessible by the holder. In other words, holding x amount of BondToken means that a user holds x amount of what BondToken.asset() represents. BondToken is an ERC20 token.
3. It is unspecified how BondToken backs the BondToken.asset(). It might hold some internal funds convertible to BondToken.asset(), or it might not hold such funds at all and back it in another way.

Any holder of BondToken can convert BondToken to BondToken.asset(). Moreover, x amount of BondToken is convertible to x amount of BondToken.asset(). To do this, the holder must call the issueDebt method with a given amount and recipient.

1. The only way to obtain BondToken.asset() is through the issueDebt method.
2. This method reduces the balanceOf(sender) by the specified amount, effectively creating a so-called debt.
3. The process for repaying this debt remains unspecified.

### Technical Overview

Every BondToken must satisfy the following interface:

#### IBond

```solidity
interface IBond is IERC20 {
    /**
     * @notice Emitted when debt is issued.
     * @param issuer address of the debt's issuer
     * @param recipient address that should receive the underlying asset
     * @param debtIssued amount of the debt issued
     */
    event IssueDebt(address indexed issuer, address indexed recipient, uint256 debtIssued);

    /**
     * @notice Emitted when debt is repaid.
     * @param issuer address of the debt's issuer
     * @param recipient address that received the underlying asset
     * @param debtRepaid amount of the debt repaid
     */
    event RepayDebt(address indexed issuer, address indexed recipient, uint256 debtRepaid);

    /**
     * @notice Get the bond's underlying asset.
     * @return asset address of the underlying asset
     */
    function asset() external view returns (address);

    /**
     * @notice Get a total amount of repaid debt.
     * @return total repaid debt
     */
    function totalRepaidDebt() external view returns (uint256);

    /**
     * @notice Get an amount of repaid debt created by a particular issuer.
     * @param issuer address of the debt's issuer
     * @return particular issuer's repaid debt
     */
    function issuerRepaidDebt(address issuer) external view returns (uint256);

    /**
     * @notice Get an amount of repaid debt to a particular recipient.
     * @param recipient address that received the underlying asset
     * @return particular recipient's repaid debt
     */
    function recipientRepaidDebt(address recipient) external view returns (uint256);

    /**
     * @notice Get an amount of repaid debt for a particular issuer-recipient pair.
     * @param issuer address of the debt's issuer
     * @param recipient address that received the underlying asset
     * @return particular pair's repaid debt
     */
    function repaidDebt(address issuer, address recipient) external view returns (uint256);

    /**
     * @notice Get a total amount of debt.
     * @return total debt
     */
    function totalDebt() external view returns (uint256);

    /**
     * @notice Get a current debt created by a particular issuer.
     * @param issuer address of the debt's issuer
     * @return particular issuer's debt
     */
    function issuerDebt(address issuer) external view returns (uint256);

    /**
     * @notice Get a current debt to a particular recipient.
     * @param recipient address that should receive the underlying asset
     * @return particular recipient's debt
     */
    function recipientDebt(address recipient) external view returns (uint256);

    /**
     * @notice Get a current debt for a particular issuer-recipient pair.
     * @param issuer address of the debt's issuer
     * @param recipient address that should receive the underlying asset
     * @return particular pair's debt
     */
    function debt(address issuer, address recipient) external view returns (uint256);

    /**
     * @notice Burn a given amount of the bond, and increase a debt of the underlying asset for the caller.
     * @param recipient address that should receive the underlying asset
     * @param amount amount of the bond
     */
    function issueDebt(address recipient, uint256 amount) external;
}
```

Next, we outline several invariants and technical limitations, what BondToken must implement, and what behavior is unspecified by the standard.

### Invariants

#### Definitions

- `IBond:asset()` - $asset$
- `IBond:debt(issuer, recipient)` - $debt_{ir}$
- `IBond:recipientDebt(recipient)` - $recipientDebt_{r}$
- `IBond:issuerDebt(issuer)` - $issuerDebt_{i}$
- `IBond:totalDebt()` - $totalDebt$
- `IBond:repaidDebt(issuer, recipient)` - $repaidDebt_{ir}$
- `IBond:recipientRepaidDebt(recipient)` - $recipientRepaidDebt_{r}$
- `IBond:issuerRepaidDebt(issuer)` - $issuerRepaidDebt_{i}$
- `IBond:totalRepaidDebt()` - $totalRepaidDebt$

#### Constraints

- $asset$ - **immutable**
- $bond.decimals() == asset.decimals()$
- $1$ $bond$ == $1$ $debt$ == $1$ $asset$
- $recipientDebt_{r}$ = $\sum_{i} debt_{ir}$
- $issuerDebt_{i}$ = $\sum_{r} debt_{ir}$
- $totalDebt$ = $\sum_{i}\sum_{r} debt_{ir}$
- $recipientRepaidDebt_{r}$ = $\sum_{i} repaidDebt_{ir}$
- $issuerRepaidDebt_{i}$ = $\sum_{r} repaidDebt_{ir}$
- $totalRepaidDebt$ = $\sum_{i}\sum_{r} repaidDebt_{ir}$
- $issuedDebt(i, r)$ = $debt_{ir}$ + $repaidDebt_{ir}$

<br/>

`IBond:issueDebt(recipient, amount)` behavior:

- $amount$ of `sender`'s Bond tokens **MUST** be burned from ERC20 perspective, where $amount$ **MUST** be less or equal than `IERC20:balanceOf(sender)`.
- $debt_{ir}$, $recipientDebt_{r}$, $issuerDebt_{i}$, $totalDebt$ **MUST** increase by $amount$.
- `IBond:IssueDebt(issuer, recipient, debtIssued)` **MUST** be emitted.

Debt repayment behavior:

- Standard doesn't specify the way how debt should be repaid but specifies the state changes
- $debt_{ir}$, $recipientDebt_{r}$, $issuerDebt_{i}$, $totalDebt$ **MUST** decrease by $repaidAmount$, where $debt_{ir}$ **MUST** be greater or equal than $repaidAmount$.
- $repaidDebt_{ir}$, $recipientRepaidDebt_{r}$, $issuerRepaidDebt_{i}$, $totalRepaidDebt$ **MUST** increase by $repaidAmount$.
- $repaidAmount$ amount of the $asset$ should be transferred to $recipient$
- `IBond:RepayDebt(issuer, recipient, debtRepaid)` **MUST** be emitted.

### Deploy

```shell
$ forge script script/deploy/DefaultBond.s.sol:DefaultBondScript --broadcast --rpc-url=$RPC_MAINNET
```
