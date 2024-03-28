Slither
INFO:Detectors:
Treasure.withdraw(uint256) (src/treasure.sol#47-65) uses timestamp for comparisons
Dangerous comparisons: - block.timestamp < lastWithdrawalTime + interval (src/treasure.sol#48)
Treasure.designateHeir(address) (src/treasure.sol#66-79) uses timestamp for comparisons
Dangerous comparisons: - block.timestamp < lastWithdrawalTime + interval (src/treasure.sol#67)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#block-timestamp
INFO:Detectors:
Different versions of Solidity are used: - Version used: ['0.8.24', '^0.8.20'] - 0.8.24 (src/treasure.sol#2) - ^0.8.20 (lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol#4)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used
INFO:Detectors:
Pragma version^0.8.20 (lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol#4) necessitates a version too recent to be trusted. Consider deploying with 0.8.18.
Pragma version0.8.24 (src/treasure.sol#2) necessitates a version too recent to be trusted. Consider deploying with 0.8.18.
solc-0.8.24 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity
INFO:Detectors:
Low level call in Treasure.withdraw(uint256) (src/treasure.sol#47-65): - (success) = owner.call{value: amount}() (src/treasure.sol#62)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls
INFO:Detectors:
Event Treasure.withdrew(uint256,address) (src/treasure.sol#19) is not in CapWords
Event Treasure.ownershipUpdated(address,address) (src/treasure.sol#20) is not in CapWords
Parameter Treasure.designateHeir(address).\_newHeir (src/treasure.sol#66) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
