## Collateral

### General Overview

Any operator wishing to operate in a Proof of Stake (POS) system must have a stake. This stake must be locked in some manner, somewhere. There are solutions that make such a stake liquid, yet the original funds remain locked, and in exchange, depositors/delegators receive LST tokens. They can then operate with these LST tokens. The reasons for locking the original funds include the need for immediate slashing if an operator misbehaves. This requirement for instant action necessitates having the stake locked, a limitation imposed by the current design of POS systems.

Collateral introduces a new type of asset that allows stakeholders to hold onto their funds and earn yield from them without needing to lock these funds in direct manner or convert them to another type of asset. Collateral represents an asset but does not require physically holding or locking this asset. The securities backing the Collateral can be in various forms, such as a liquidity pool position, some real-world asset, or generally any type of asset. Depending on the implementation of Collateral, this securing asset can be held within the Collateral itself or elsewhere.

Symbiotic allows collateral tokens to be deposited into vaults, which delegate collateral to operators across Symbiotic networks. Vaults define acceptable collateral and it's `Burner` (if vault supports slashing) and networks need to accept these and other vault terms such as slashing limits to receive rewards.

### Technical Overview

We do not specify the exact implementation of the Collateral, however, it must satisfy all the following requirement:

- Collateral token must support ERC-20 interface
- [OPTIONAL] Collateral token should be slashable i.e. native token or derivative that supports redeeming the underlying native token. (Only if collateral is used in slashable vaults).

### Deploy

```shell
source .env
```

#### Deploy factory

Deployment script: [click](../script/deploy/defaultCollateral/DefaultCollateralFactory.s.sol)

```shell
forge script script/deploy/defaultCollateral/DefaultCollateralFactory.s.sol:DefaultCollateralFactoryScript --broadcast --rpc-url=$ETH_RPC_URL
```

#### Deploy entity

Deployment script: [click](../script/deploy/defaultCollateral/DefaultCollateral.s.sol)

```shell
forge script script/deploy/defaultCollateral/DefaultCollateral.s.sol:DefaultCollateralScript 0x0000000000000000000000000000000000000000 0x0000000000000000000000000000000000000000 115792089237316195423570985008687907853269984665640564039457584007913129639935 0x0000000000000000000000000000000000000000 --sig "run(address,address,uint256,address)" --broadcast --rpc-url=$ETH_RPC_URL
```
