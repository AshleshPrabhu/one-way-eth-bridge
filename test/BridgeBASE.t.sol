// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/BridgeBASE.sol"; 
import "src/BUSDT.sol";

event Burn(address indexed burner, uint amount);

contract BridgeBASETest is Test {
    BridgeBASE bridge;
    BUSDT busdt ;

    function setUp() public {
        busdt = new BUSDT();
        bridge = new BridgeBASE(address(busdt));
        busdt.transferOwnership(address(bridge));
    }

    function testBurnAndWithdraw() public {
        address user = 0x2966473D85A76A190697B5b9b66b769436EFE8e5;

        bridge.depositedOnOtherSide(user, 200);
        vm.startPrank(user);


        bridge.withdraw(IBUSDT(address(busdt)), 100); 
        assertEq(busdt.balanceOf(user), 100);

        vm.expectEmit(true, false, false, false);
        emit Burn(user, 50);

        bridge.burn(IBUSDT(address(busdt)), 50); 
        assertEq(busdt.balanceOf(user), 50);
    }
}
