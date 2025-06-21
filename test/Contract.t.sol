// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/Contract.sol"; // adjust path if needed
import "src/USDT.sol";

contract DepositTest is Test {
    BridgeETH bridge;
    USDT usdt ;

    function setUp() public {
        usdt = new USDT();
        bridge = new BridgeETH(address(usdt));
    }

    function testDeposit () public{
        usdt.mint(0x2966473D85A76A190697B5b9b66b769436EFE8e5, 200);
        vm.startPrank(0x2966473D85A76A190697B5b9b66b769436EFE8e5);
        usdt.approve(address(bridge),100);
        uint amount = usdt.allowance(0x2966473D85A76A190697B5b9b66b769436EFE8e5,address(bridge));
        assertEq(amount, 100);
        bridge.deposit(usdt,100);
        assertEq(usdt.balanceOf(0x2966473D85A76A190697B5b9b66b769436EFE8e5),100);
        assertEq(usdt.balanceOf(address(bridge)), 100);
        bridge.withdraw(usdt,50);
        assertEq(usdt.balanceOf(0x2966473D85A76A190697B5b9b66b769436EFE8e5),150);
        assertEq(usdt.balanceOf(address(bridge)), 50);
    }

    

}