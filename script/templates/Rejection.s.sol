// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

contract Proposal is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        (bool success,) = address(msg.sender).call{value: 0}("");
        if (!success) {
            revert("rejection failed");
        }
    }
}
