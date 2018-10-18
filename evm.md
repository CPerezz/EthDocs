# EVM

## EVM seen with big perspective.
Before diving into understanding how EVM works and seeing it working via code examples, let’s see where EVM fits in the Ethereum and what are its components.

The below diagram shows where EVM fits into Ethereum.
![](https://cdn-images-1.medium.com/max/800/1*ajksoo8DEQl-COk84HdVvA.png)

The next one, shows the EVM architecture as a simple stack-based arch.
![](https://cdn-images-1.medium.com/max/800/1*34JdmUiX5ZeT2AESYPtPFw.png)

Finally we can see here the EVM execution model.
![](https://cdn-images-1.medium.com/max/800/1*5gNAMNT4csJdQuuj1a-R-Q.png)

## Ethereum Contracts.

Smart contracts **are just computer programs**, and we can say that Ethereum contracts are smart contracts **that run on the Ethereum Virtual Machine**. The EVM is the sandboxed runtime and a completely isolated environment for smart contracts in Ethereum. This means that **every smart contract running inside the EVM has no access to the network, file system, or other processes running on the computer hosting the VM**.

As we already know, there are two kinds of accounts: contracts and external accounts. Every account is identified by an address, and all accounts share the same address space. The EVM handles addresses of 160-bit length.

![](https://cdn-images-1.medium.com/max/800/1*zEEt3J7gnUiyOhzXVl1jHw.png)

Every account consists of a balance, a nonce, bytecode, and stored data (storage). However, there are some differences between these two kinds of accounts:
- Code and storage of external owned accounts are empty while contract ones store their bytecode and the merkle root hash of the entire state tree (WHY the root?).

- EOA are controlled by a Sk (Secret/Private key) while contracts are controlled by it's code, executed by the EVM.

![](https://cdn-images-1.medium.com/max/800/1*YC5PFXSJlZPw6zQWOuE7WQ.png)


---------------------------------------------------------------------

The first thing that happens when a new contract is deployed to the Ethereum blockchain is that its account is created.



