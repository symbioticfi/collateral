**[Symbiotic Protocol](https://symbiotic.fi) is an extremely flexible and permissionless shared security system.**

This repository contains a Default Symbiotic Collateral implementation.

## Collateral

**Collateral** - a concept introduced by Symbiotic that brings capital efficiency and scale by enabling assets used to secure Symbiotic networks to be held outside of the Symbiotic protocol itself - e.g. in DeFi positions on networks other than Ethereum itself.

Symbiotic achieves this by separating the ability to slash assets from the underlying asset itself, similar to how liquid staking tokens create tokenized representations of underlying staked positions. Technically, collateral positions in Symbiotic are ERC-20 tokens with extended functionality to handle slashing incidents if applicable. In other words, if the collateral token aims to support slashing, it should be possible to create a `Burner` responsible for proper burning of the asset.

## Default Collateral

Default Collateral is a simple implementation of the collateral token. Technically it's a wrapper over any ERC-20 token with additional slashing history functionality. These functionality is optional and not required in general case.

The implementation can be found [here](./src/contracts/defaultCollateral).

## Technical Documentation

Technical documentation can be found [here](./specs).

## Security

Security audits can be found [here](./audits).

## Usage

### Env

Create `.env` file using a template:

```
ETH_RPC_URL=
ETHERSCAN_API_KEY=
```

\* ETHERSCAN_API_KEY is optional.

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
