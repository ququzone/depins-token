// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";

import {DepinsToken} from "../src/DepinsToken.sol";
import {DepinsConvertor} from "../src/DepinsConvertor.sol";

contract Deployer is Script {
    function run() public {
        vm.startBroadcast();
        DepinsToken token = new DepinsToken();
        DepinsConvertor convertor = new DepinsConvertor(
            0xd22ababf9f3c50dd78726bedaad69a7b9b1d5514bad6eb476e88a83e67777b97,
            address(token),
            0x1B4508C227A55Fa0FD2165b3d0B6260379e8E752,
            840000000000000000000000000
        );
        vm.stopBroadcast();

        console.log("Depins token: ", address(token));
        console.log("DepinsConvertor: ", address(convertor));
    }
}
