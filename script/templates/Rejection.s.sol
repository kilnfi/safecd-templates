// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SCDU} from "./utils.sol";

contract Proposal is SCDU {
    function setUp() public {
        setup();
    }

    function run() public {
        vm.broadcast();
        (bool success,) = address(msg.sender).call{value: 0}("");
        if (!success) {
            revert("rejection failed");
        }
    }
}
