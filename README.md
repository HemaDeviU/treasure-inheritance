# Treasure Inheritance

This project creates an inheritance contract in solidity.The contract allows the Owner to withdraw ETH from the contract.If the owner doesn't withdraw ETH from the contract for more than a month, an heir can take control of the contract and designate a new heir.It's possible for the owner to withdraw 0eth, just to reset the one month counter.

## Requirements

# Foundry

To get started with Foundry, run the following commands:

```curl -L https://foundry.paradigm.xyz | bash
foundryup
git clone https://github.com/HemaDeviU/StableCoin-Defi-Protocol
cd StableCoin-Defi-Protocol
forge build
```


