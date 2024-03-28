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

    event WithdrawalComplete(uint256 indexed amt, address indexed owner);
    event OwnershipUpdated(address indexed owner, address indexed heir);
    event DepositReceived(address indexed sender, uint256 indexed despositAmount);

    constructor(address _owner, address _heir){
        if(_owner == address(0) || _heir == address(0)){
            revert treasure__EnterValidAddress();
        }
    owner = payable(_owner);
    heir = payable(_heir);
    lastWithdrawalTime = block.timestamp;
    }
    receive() external payable {
        emit DepositReceived(msg.sender, msg.value);
    }
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

    function withdraw(uint256 amount) external onlyOwner nonReentrant {
        if(amount > address(this).balance)
        {
            revert treasure__Insufficientbalance();
        }
        if(block.timestamp < lastWithdrawalTime + interval)
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