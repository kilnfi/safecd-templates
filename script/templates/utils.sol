// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";

contract SCDU is Test {
    function fromHexChar(uint8 c) internal pure returns (uint8) {
        if (bytes1(c) >= bytes1("0") && bytes1(c) <= bytes1("9")) {
            return c - uint8(bytes1("0"));
        }
        if (bytes1(c) >= bytes1("a") && bytes1(c) <= bytes1("f")) {
            return 10 + c - uint8(bytes1("a"));
        }
        if (bytes1(c) >= bytes1("A") && bytes1(c) <= bytes1("F")) {
            return 10 + c - uint8(bytes1("A"));
        }
        return 0;
    }

    function hexStringToAddress(string memory s) internal pure returns (bytes memory) {
        bytes memory ss = bytes(s);
        require(ss.length % 2 == 0); // length must be even
        bytes memory r = new bytes(ss.length/2);
        for (uint256 i = 0; i < ss.length / 2; ++i) {
            r[i] = bytes1(fromHexChar(uint8(ss[2 * i])) * 16 + fromHexChar(uint8(ss[2 * i + 1])));
        }

        return r;
    }

    function toAddress(string memory s) internal pure returns (address) {
        bytes memory _bytes = hexStringToAddress(s);
        require(_bytes.length >= 1 + 20, "toAddress_outOfBounds");
        address tempAddress;

        assembly {
            tempAddress := div(mload(add(add(_bytes, 0x20), 1)), 0x1000000000000000000000000)
        }

        return tempAddress;
    }

    function setupLabels() internal {
        try vm.envString("SAFECD_SIMULATION_LABELS", ",") returns (string[] memory labels) {
            assertTrue(labels.length % 2 == 0, "labels must be even (address, label)");
            for (uint256 i = 0; i < labels.length; i += 2) {
                vm.label(toAddress(labels[i]), labels[i + 1]);
            }
        } catch {
            return;
        }
    }

    function setup() internal {
        setupLabels();
    }
}
