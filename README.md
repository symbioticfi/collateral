**[Symbiotic Protocol](https://symbiotic.fi) is an extremely flexible and permissionless shared security system.**

This repository contains a Default Symbiotic Collateral implementation.

## Collateral

**Collateral** - a concept introduced by Symbiotic that brings capital efficiency and scale by allowing assets used to secure Symbiotic networks to be held outside the Symbiotic protocol itself, such as in DeFi positions on networks other than Ethereum.

Symbiotic achieves this by separating the ability to slash assets from the underlying asset, similar to how liquid staking tokens create tokenized representations of underlying staked positions. Technically, collateral positions in Symbiotic are ERC-20 tokens with extended functionality to handle slashing incidents if applicable. In other words, if the collateral token supports slashing, it should be possible to create a `Burner` responsible for properly burning the asset.

## Default Collateral

Default Collateral is a simple implementation of the collateral token. Technically, it's a wrapper over any ERC-20 token with additional slashing history functionality. This functionality is optional and not required in most cases.

The implementation can be found [here](./src/contracts/defaultCollateral).

## Security

Security audits can be found [here](./audits).

## Usage

### Env

Create `.env` file using a template:

```
ETH_RPC_URL=
ETH_RPC_URL_HOLESKY=
ETHERSCAN_API_KEY=
```

\* ETH_RPC_URL_HOLESKY is optional.<br/>\* ETHERSCAN_API_KEY is optional.

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Format

```shell
forge fmt
```

### Gas Snapshots

```shell
forge snapshot
```
