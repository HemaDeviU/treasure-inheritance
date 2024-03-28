//SPDX-License-Identifier:MIT
pragma solidity 0.8.24;

import "forge-std/Script.sol";
import "../src/treasure.sol";

contract DeployTreasure is Script{
    function run() public {
        address initialOwner = 0xaD8d4dde4705D7A588d522820316781B93926a6f;
        address initialHeir = 0x0F05831E0544c390C547109f5d9D72267727bD9A;
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        Treasure treasure = new Treasure(initialOwner,initialHeir);
        treasure.getBalance();
        vm.stopBroadcast();

    }
}