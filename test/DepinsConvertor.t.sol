// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import "../src/DepinsConvertor.sol";
import "../src/DepinsToken.sol";

contract DepinsConvertorTest is Test {
    DepinsConvertor convertor;
    DepinsToken depins;

    address internal foundation;
    address internal fake;

    function setUp() public {
        foundation = address(0xff);
        foundation = address(0xfa);

        depins = new DepinsToken();
        convertor = new DepinsConvertor(
            0xd22ababf9f3c50dd78726bedaad69a7b9b1d5514bad6eb476e88a83e67777b97,
            address(depins),
            foundation,
            840000000000000000000000000
        );
    }

    function testMint() public {
        vm.startPrank(fake);
        vm.expectRevert("only minter");
        depins.mint(fake, 1 ether);

        vm.expectRevert("only minter");
        depins.changeMinter(foundation);
        vm.stopPrank();
    }

    function testClaim() public {
        vm.expectRevert("only minter");
        convertor.claimFoundation();

        address user = 0x000000002dEf59a571dDC1fa585b0F77654Fe66a;
        uint256 amount = 800000000000000000000000;
        bytes32[] memory proof = new bytes32[](13);
        proof[0] = 0x48f40c9c05fe0ed8afbf4d136035b04484a6829f9a1ef419c74204d0a775ab6b;
        proof[1] = 0x36fad9f637a90f58f1c9fc5d556f27d41c8797983da51ec105c76352f72dc526;
        proof[2] = 0x4df9e8d38f97a371715fb0d7eb06d00361d3b61142e06969c7e27db18d6bc864;
        proof[3] = 0xcfd16a61f4bea38a6bdb7a72ed8ea229fb770c05d030675082834b1c907ac6fa;
        proof[4] = 0xcf0398f3469b33c31cd7d32556d7fc043874bf1730b43b1766a12c75c9be8087;
        proof[5] = 0xaecfebacb35c968883ce5f5a9411c63435d0c44a2b953e72a99608adb8cd6f59;
        proof[6] = 0x53edee7961acc528cedaa2dec1b9f5481880a6a77cd7caa5f0e83ca339c1e27f;
        proof[7] = 0x2d0ceff86d31800d16949cac23d48fb82aba90ec4ae4270abac8abccd03e2556;
        proof[8] = 0xd158dc28b05ac4299ef4a937e49bc99ba4e41ab2f1be40136d7f420a3910aaf5;
        proof[9] = 0xc9540b4b125061580b26c70678bd69df7152a4c331ba973ef6dedd8d9ccb4b81;
        proof[10] = 0x4b514093a64a10f9e27e837a6b4e9a0bb13281df390c8f4df217b05aa0890b31;
        proof[11] = 0x0ee134ae657ef97e33b5ab7cef78bdf4613a2a2c34adedc577a19e87cb0308d6;
        proof[12] = 0x50df5a3aac9cf80e2a879049a2f021ed83e54018341d43556614c666ec083852;
        vm.expectRevert("only minter");
        convertor.claim(user, amount, proof);

        depins.changeMinter(address(convertor));

        convertor.claimFoundation();
        assertEq(depins.balanceOf(foundation), 840000000000000000000000000);
        vm.expectRevert("claimed");
        convertor.claimFoundation();

        convertor.claim(user, amount, proof);
        assertEq(depins.balanceOf(user), 720000000000000000000000);
        assertEq(depins.balanceOf(foundation), 840080000000000000000000000);
        vm.expectRevert("claimed");
        convertor.claim(user, amount, proof);
    }
}
