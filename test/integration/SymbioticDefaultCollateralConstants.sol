// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SymbioticDefaultCollateralImports.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

library SymbioticDefaultCollateralConstants {
    using Strings for string;

    function defaultCollateralFactory() internal view returns (ISymbioticDefaultCollateralFactory) {
        if (block.chainid == 1) {
            // mainnet
            return ISymbioticDefaultCollateralFactory(0x1BC8FCFbE6Aa17e4A7610F51B888f34583D202Ec);
        } else if (block.chainid == 17_000) {
            // holesky
            return ISymbioticDefaultCollateralFactory(0x7224eeF9f38E9240beA197970367E0A8CBDFDD8B);
        } else {
            revert("SymbioticDefaultCollateralConstants.defaultCollateralFactory(): chainid not supported");
        }
    }

    function defaultCollateral(
        string memory symbol
    ) internal view returns (address) {
        if (symbol.equal("DC_wstETH")) {
            return DC_wstETH();
        } else if (symbol.equal("DC_cbETH")) {
            return DC_cbETH();
        } else if (symbol.equal("DC_wBETH")) {
            return DC_wBETH();
        } else if (symbol.equal("DC_rETH")) {
            return DC_rETH();
        } else if (symbol.equal("DC_mETH")) {
            return DC_mETH();
        } else if (symbol.equal("DC_swETH")) {
            return DC_swETH();
        } else if (symbol.equal("DC_sfrxETH")) {
            return DC_sfrxETH();
        } else if (symbol.equal("DC_ETHx")) {
            return DC_ETHx();
        } else if (symbol.equal("DC_ENA")) {
            return DC_ENA();
        } else if (symbol.equal("DC_sUSDe")) {
            return DC_sUSDe();
        } else if (symbol.equal("DC_WBTC")) {
            return DC_WBTC();
        } else if (symbol.equal("DC_tBTC")) {
            return DC_tBTC();
        } else if (symbol.equal("DC_LsETH")) {
            return DC_LsETH();
        } else if (symbol.equal("DC_osETH")) {
            return DC_osETH();
        } else if (symbol.equal("DC_ETHFI")) {
            return DC_ETHFI();
        } else if (symbol.equal("DC_FXS")) {
            return DC_FXS();
        } else if (symbol.equal("DC_LBTC")) {
            return DC_LBTC();
        } else {
            revert("SymbioticDefaultCollateralConstants.defaultCollateral(): symbol not supported");
        }
    }

    function defaultCollateralSupported(
        string memory symbol
    ) internal view returns (bool) {
        if (symbol.equal("DC_wstETH")) {
            return DC_wstETHSupported();
        } else if (symbol.equal("DC_cbETH")) {
            return DC_cbETHSupported();
        } else if (symbol.equal("DC_wBETH")) {
            return DC_wBETHSupported();
        } else if (symbol.equal("DC_rETH")) {
            return DC_rETHSupported();
        } else if (symbol.equal("DC_mETH")) {
            return DC_mETHSupported();
        } else if (symbol.equal("DC_swETH")) {
            return DC_swETHSupported();
        } else if (symbol.equal("DC_sfrxETH")) {
            return DC_sfrxETHSupported();
        } else if (symbol.equal("DC_ETHx")) {
            return DC_ETHxSupported();
        } else if (symbol.equal("DC_ENA")) {
            return DC_ENASupported();
        } else if (symbol.equal("DC_sUSDe")) {
            return DC_sUSDeSupported();
        } else if (symbol.equal("DC_WBTC")) {
            return DC_WBTCSupported();
        } else if (symbol.equal("DC_tBTC")) {
            return DC_tBTCSupported();
        } else if (symbol.equal("DC_LsETH")) {
            return DC_LsETHSupported();
        } else if (symbol.equal("DC_osETH")) {
            return DC_osETHSupported();
        } else if (symbol.equal("DC_ETHFI")) {
            return DC_ETHFISupported();
        } else if (symbol.equal("DC_FXS")) {
            return DC_FXSSupported();
        } else if (symbol.equal("DC_LBTC")) {
            return DC_LBTCSupported();
        } else {
            revert("SymbioticDefaultCollateralConstants.defaultCollateralSupported(): symbol not supported");
        }
    }

    function DC_wstETH() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0xC329400492c6ff2438472D4651Ad17389fCb843a;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_wstETH(): chainid not supported");
        }
    }

    function DC_cbETH() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0xB26ff591F44b04E78de18f43B46f8b70C6676984;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_cbETH(): chainid not supported");
        }
    }

    function DC_wBETH() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x422F5acCC812C396600010f224b320a743695f85;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_wBETH(): chainid not supported");
        }
    }

    function DC_rETH() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x03Bf48b8A1B37FBeAd1EcAbcF15B98B924ffA5AC;
        } else if (block.chainid == 17_000) {
            // holesky
            return 0x7322c24752f79c05FFD1E2a6FCB97020C1C264F1;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_rETH(): chainid not supported");
        }
    }

    function DC_mETH() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x475D3Eb031d250070B63Fa145F0fCFC5D97c304a;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_mETH(): chainid not supported");
        }
    }

    function DC_swETH() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x38B86004842D3FA4596f0b7A0b53DE90745Ab654;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_swETH(): chainid not supported");
        }
    }

    function DC_sfrxETH() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x5198CB44D7B2E993ebDDa9cAd3b9a0eAa32769D2;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_sfrxETH(): chainid not supported");
        }
    }

    function DC_ETHx() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0xBdea8e677F9f7C294A4556005c640Ee505bE6925;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_ETHx(): chainid not supported");
        }
    }

    function DC_ENA() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0xe39B5f5638a209c1A6b6cDFfE5d37F7Ac99fCC84;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_ENA(): chainid not supported");
        }
    }

    function DC_sUSDe() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x19d0D8e6294B7a04a2733FE433444704B791939A;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_sUSDe(): chainid not supported");
        }
    }

    function DC_WBTC() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x971e5b5D4baa5607863f3748FeBf287C7bf82618;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_WBTC(): chainid not supported");
        }
    }

    function DC_tBTC() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x0C969ceC0729487d264716e55F232B404299032c;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_tBTC(): chainid not supported");
        }
    }

    function DC_LsETH() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0xB09A50AcFFF7D12B7d18adeF3D1027bC149Bad1c;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_LsETH(): chainid not supported");
        }
    }

    function DC_osETH() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x52cB8A621610Cc3cCf498A1981A8ae7AD6B8AB2a;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_osETH(): chainid not supported");
        }
    }

    function DC_ETHFI() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x21DbBA985eEA6ba7F27534a72CCB292eBA1D2c7c;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_ETHFI(): chainid not supported");
        }
    }

    function DC_FXS() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x940750A267c64f3BBcE31B948b67CD168f0843fA;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_FXS(): chainid not supported");
        }
    }

    function DC_LBTC() internal view returns (address) {
        if (block.chainid == 1) {
            // mainnet
            return 0x9C0823D3A1172F9DdF672d438dec79c39a64f448;
        } else {
            revert("SymbioticDefaultCollateralConstants.DC_LBTC(): chainid not supported");
        }
    }

    function DC_wstETHSupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function DC_cbETHSupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function DC_wBETHSupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function DC_rETHSupported() internal view returns (bool) {
        return (block.chainid == 1 || block.chainid == 17_000);
    }

    function DC_mETHSupported() internal view returns (bool) {
        return (block.chainid == 1 || block.chainid == 17_000 || block.chainid == 11_155_111);
    }

    function DC_swETHSupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function DC_sfrxETHSupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function DC_ETHxSupported() internal view returns (bool) {
        return (block.chainid == 1 || block.chainid == 17_000);
    }

    function DC_ENASupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function DC_sUSDeSupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function DC_WBTCSupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function DC_tBTCSupported() internal view returns (bool) {
        return (block.chainid == 1 || block.chainid == 11_155_111);
    }

    function DC_LsETHSupported() internal view returns (bool) {
        return (block.chainid == 1 || block.chainid == 17_000);
    }

    function DC_osETHSupported() internal view returns (bool) {
        return (block.chainid == 1 || block.chainid == 17_000);
    }

    function DC_ETHFISupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function DC_FXSSupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function DC_LBTCSupported() internal view returns (bool) {
        return block.chainid == 1;
    }

    function allDefaultCollaterals() internal view returns (string[] memory result) {
        result = new string[](17);
        result[0] = "DC_wstETH";
        result[1] = "DC_cbETH";
        result[2] = "DC_wBETH";
        result[3] = "DC_rETH";
        result[4] = "DC_mETH";
        result[5] = "DC_swETH";
        result[6] = "DC_sfrxETH";
        result[7] = "DC_ETHx";
        result[8] = "DC_ENA";
        result[9] = "DC_sUSDe";
        result[10] = "DC_WBTC";
        result[11] = "DC_tBTC";
        result[12] = "DC_LsETH";
        result[13] = "DC_osETH";
        result[14] = "DC_ETHFI";
        result[15] = "DC_FXS";
        result[16] = "DC_LBTC";
    }

    function supportedDefaultCollaterals() internal view returns (string[] memory result) {
        string[] memory defaultCollaterals = allDefaultCollaterals();
        result = new string[](defaultCollaterals.length);

        uint256 count;
        for (uint256 i; i < defaultCollaterals.length; ++i) {
            if (defaultCollateralSupported(defaultCollaterals[i])) {
                result[count] = defaultCollaterals[i];
                ++count;
            }
        }

        assembly ("memory-safe") {
            mstore(result, count)
        }
    }
}
