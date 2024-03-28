//SPDX-License-Identifier:MIT
pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import "../src/treasure.sol";


contract TreasureTest is Test {
    Treasure public treasure;
    address public OWNER = address(1);
    address public HEIR = address(2);
    uint256 public STARTINGBALANCE = 10 ether;
    uint256 immutable public interval = 4 weeks;

    event WithdrawalComplete(uint256 indexed amt, address indexed owner);
    event OwnershipUpdated(address indexed owner, address indexed heir);
    event DepositReceived(address indexed sender, uint256 indexed despositAmount);

function setUp() public {
   treasure = new Treasure(OWNER,HEIR);
   (bool ok, ) = address(treasure).call{value: 10 ether}("");
  require(ok, "Funding Treasure contract failed");



}
//constructor tests
function testInvalidConstructorArgumentOwner() public {
    
    address validHeir = makeAddr("validHeir");
    vm.expectRevert();
    new Treasure(address(0),validHeir);
}
function testInvalidConstructorArgumentHeir() public {
    
    address validOwner = makeAddr("validOwner");
    vm.expectRevert();
    new Treasure(address(0),validOwner);
}
function testConstructorArgumentAssignment() public {
    address expectedOwner = makeAddr("expectedOwner");
    address expectedHeir = makeAddr("expectedHeir");
    Treasure treasure1 = new Treasure(expectedOwner, expectedHeir);
    assertEq(treasure1.getOwner(), expectedOwner);
    assertEq(treasure1.getHeir(), expectedHeir);

}
//deposit test
function testDepositEvent() public {
    uint256 initialBalance = treasure.getBalance();
    vm.expectEmit(true, true, false, false);
    emit DepositReceived(address(this),1000000000000000000);
    (bool ok, ) = address(treasure).call{value: 1 ether }("");
    require(ok, "send ETH failed");
    assertEq(treasure.getBalance(), initialBalance + 1000000000000000000);

}
//withdrawal tests
function testwithdrawalbyNotOwner() public{ 

    //onlyowner
    vm.startPrank(HEIR);
    vm.expectRevert();
    treasure.withdraw(1 ether);
    vm.stopPrank();
}
function testwithdrawalafterInterval() public{ 
    vm.startPrank(OWNER);
    vm.warp(block.timestamp + 1 days);
    vm.expectRevert();
    treasure.withdraw(address(treasure).balance);
    vm.stopPrank();
}

function testMorethanBalWithdrawal() public
{
    vm.startPrank(OWNER);
    vm.expectRevert();
    uint256 moreEth = address(treasure).balance + 1 ether;
    treasure.withdraw(moreEth);
    vm.stopPrank();

}
function testValidWithdrawalGreaterThanZero() public 
{ 
    uint256 initialBalance = treasure.getBalance();
    vm.startPrank(OWNER);
    vm.warp(block.timestamp + interval + 10 minutes);
     vm.expectEmit(true, true, false, false);
     emit WithdrawalComplete(1000000000000000000,OWNER);
    treasure.withdraw(1000000000000000000);
    vm.stopPrank();
    assertEq(treasure.lastWithdrawalTime(),block.timestamp);
    assertEq(treasure.getBalance(),initialBalance - 1 ether);
    


}
function testValidWithdrawalAmountZero() public{
    uint256 initialBalance = treasure.getBalance();
    vm.startPrank(OWNER);
    vm.warp(block.timestamp + interval + 10 minutes);
     vm.expectEmit(true, true, false, false);
     emit WithdrawalComplete(0,OWNER);
    treasure.withdraw(0);
    vm.stopPrank();
    assertEq(treasure.lastWithdrawalTime(),block.timestamp);
    assertEq(treasure.getBalance(),initialBalance);

}
//heirdesignation tests
function testDesignateHeirbyNotHeir() public{ 
    //onlyHeir
    vm.startPrank(address(3));
    address InvalidHeir = makeAddr("InvalidHeir");
    vm.expectRevert();
    treasure.designateHeir(InvalidHeir);
    vm.stopPrank();
} 
function testDesignateHeirBeforeInterval() public {
    vm.startPrank(HEIR);
    address validHeir = makeAddr("validHeir");
    vm.warp(block.timestamp + interval - 3 hours);
    vm.expectRevert();
    treasure.designateHeir(validHeir);
    vm.stopPrank();
}
function testDesignateHeirtoSelf() public {
      vm.startPrank(HEIR);
    vm.warp(block.timestamp + interval + 1 days);
    vm.expectRevert();
    treasure.designateHeir(HEIR);
    vm.stopPrank();
}

function testDesignateHeirValid() public {
     vm.startPrank(HEIR);
    address validHeir = makeAddr("validHeir");
    vm.warp(block.timestamp + interval + 3 hours);
    vm.expectEmit(true, true, false, false);
    emit OwnershipUpdated(HEIR,validHeir);
    treasure.designateHeir(validHeir);
    vm.stopPrank();
    assertEq(treasure.getHeir(),validHeir);

}
function testGetBalance() public view {
    uint256 expectedBalance = 10 ether;
    assertEq(treasure.getBalance(), expectedBalance);
}
function testGetOwner() public view {
    assertEq(treasure.getOwner(),OWNER);
}
function testGetInterval() public view {
    assertEq(treasure.getInterval(),interval);
}

}

