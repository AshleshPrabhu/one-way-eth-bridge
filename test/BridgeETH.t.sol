// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/BridgeETH.sol"; 
import "src/USDT.sol";

event Deposit(address indexed depositor, uint amount);

contract BridgeETHTest is Test {
    BridgeETH bridge;
    USDT usdt ;

    function setUp() public {
        usdt = new USDT();
        bridge = new BridgeETH(address(usdt));
    }

    function testDeposit() public {
        address user = 0x2966473D85A76A190697B5b9b66b769436EFE8e5;
        usdt.mint(user, 200);

        vm.startPrank(user);
        usdt.approve(address(bridge), 100);
        assertEq(usdt.allowance(user, address(bridge)), 100);

        vm.expectEmit(true, false, false, false);
        emit Deposit(user, 100);
        bridge.deposit(usdt, 100);
        
        assertEq(usdt.balanceOf(user), 100);
        assertEq(usdt.balanceOf(address(bridge)), 100);

        vm.stopPrank();
        bridge.burnedOnOppositeChain(user, 50);

        vm.startPrank(user);
        bridge.withdraw(usdt, 50);
        assertEq(usdt.balanceOf(user), 150);
        assertEq(usdt.balanceOf(address(bridge)), 50);
    }



}