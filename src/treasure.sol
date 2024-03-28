//SPDX-License-Identifier:MIT
pragma solidity 0.8.24;
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Treasure is ReentrancyGuard {
    address payable private owner;
    address payable private heir;
    uint256 immutable public interval = 4 weeks;
    uint256 public lastWithdrawalTime;

    error treasure__EnterValidAddress();
    error treasure__OnlyOwnerpermitted();
    error treasure__OnlyHeirPermitted();
    error treasure__Intervaltimeexceded();
    error treasure__Intervaltimenotexceeded();
    error treasure__Insufficientbalance();
    error treasure__YouCantBeYourHeir();

    event Withdrew(uint256 indexed amt, address indexed owner);
    event OwnershipUpdated(address indexed owner, address indexed heir);

    constructor(address _owner, address _heir){
        if(_owner == address(0) || _heir == address(0)){
            revert treasure__EnterValidAddress();
        }
    owner = payable(_owner);
    heir = payable(_heir);
    lastWithdrawalTime = block.timestamp;
    }
    receive() external payable {}
    fallback() external payable {}

    modifier onlyOwner() {
        if(msg.sender != owner)
        {
            revert treasure__OnlyOwnerpermitted();
        }
        _;
    }
    modifier onlyHeir(){
        if(msg.sender != heir){
            revert treasure__OnlyHeirPermitted();
        }
        _;
    }

    function withdraw(uint256 amount) external payable onlyOwner nonReentrant {
        if(block.timestamp < lastWithdrawalTime + interval)
        {
            revert treasure__Intervaltimeexceded();
        }
        
        
        if(amount > address(this).balance)
        {
            revert treasure__Insufficientbalance();
        }
        emit Withdrew(amount, msg.sender);
        lastWithdrawalTime = block.timestamp;
        if(amount > 0)
        {
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to withdraw");
        }
    }
    function designateHeir(address _newHeir) external onlyHeir {
        if(block.timestamp < lastWithdrawalTime + interval)
        {
            revert treasure__Intervaltimenotexceeded();

        }
        if(heir == _newHeir)
        {
            revert treasure__YouCantBeYourHeir();
        }
         owner = heir;
         heir = payable(_newHeir);
         emit OwnershipUpdated(owner, heir);
    }
    function getBalance() public view returns (uint256 bal)
    {
        return address(this).balance;
    }
}