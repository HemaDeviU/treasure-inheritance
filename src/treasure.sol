//SPDX-License-Identifier:MIT
pragma solidity 0.8.24;
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
//@title Inheritance contract
contract Treasure is ReentrancyGuard {
//state variables
    address payable private owner;
    address payable private heir;
    uint256 immutable public interval = 4 weeks;
    uint256 public lastWithdrawalTime;
//errors
    error treasure__EnterValidAddress();
    error treasure__OnlyOwnerpermitted();
    error treasure__OnlyHeirPermitted();
    error treasure__Intervaltimeexceded();
    error treasure__Intervaltimenotexceeded();
    error treasure__Insufficientbalance();
    error treasure__YouCantBeYourHeir();

//events
    event WithdrawalComplete(uint256 indexed amt, address indexed owner);
    event OwnershipUpdated(address indexed owner, address indexed heir);

//@dev assigns initial owner and heir for the contract and updates withdrawaltime to now
//@param _owner : address of the owner
//@param _heir : address of the heir
    constructor(address _owner, address _heir){
        if(_owner == address(0) || _heir == address(0)){ //checks for zero address
            revert treasure__EnterValidAddress();
        }
    owner = payable(_owner);
    heir = payable(_heir);
    lastWithdrawalTime = block.timestamp;
    }
    receive() external payable {
    }
    fallback() external payable {}

//modifiers
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

//functions
//@dev allow withdrawals by owner if 'now' is between lastwithdrawaltime and interval. Transfer the amount to owner and set lastwithdrawaltime.
//@param amount: amount to withdraw from the contract.
//notice Call this function to withdraw amount from the contract balance. Specify the amount to withdraw. 0 withdrawals are allowed.
    function withdraw(uint256 amount) external onlyOwner nonReentrant { //nonreentrant to avoid change of state
        if(amount > address(this).balance) //security check
        {
            revert treasure__Insufficientbalance();
        }
        if(block.timestamp >= lastWithdrawalTime + interval) //withdrawal allowed before interval expiry
        {
            revert treasure__Intervaltimeexceded();
        }
        
        
        emit WithdrawalComplete(amount, msg.sender);
        lastWithdrawalTime = block.timestamp;
        if(amount > 0)
        {
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to withdraw");
        }
    }

//@dev called by heir to designate oneself as owner and assigns unique heir. 
//@param _newHeir: address of the newheir to be designated as heir.
//@notice The heir can call this function to become the owner, but only after the withdrawal interval has passed.

    function designateHeir(address _newHeir) external onlyHeir {
        if(block.timestamp < lastWithdrawalTime + interval)
        {
            revert treasure__Intervaltimenotexceeded();

        }
        if(heir == _newHeir)
        {
            revert treasure__YouCantBeYourHeir();
        }
        emit OwnershipUpdated(msg.sender, _newHeir);
         owner = heir;
         heir = payable(_newHeir);
         
    }
//getter functions
    function getBalance() public view returns (uint256 bal)
    {
        return address(this).balance;
    }
    function getOwner() public view returns (address){
        return owner;
    }
    function getHeir() public view returns(address){
        return heir;
    }
    function getInterval() public pure returns(uint256){
        return interval;
    }
}
