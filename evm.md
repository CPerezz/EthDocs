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

## Data management.

The EVM manages different kinds of data depending on their context, and it does that in different ways. We can distinguish at least four main types of data: stack, calldata, memory, and storage, besides the contract code. Let’s analyze each of these:
![](https://cdn-images-1.medium.com/max/800/1*vlPf6wUYH3LBBS2wwL00PA.png)

### Stack

The EVM is a stack machine, meaning that it doesn’t operate on registers but on a virtual stack. The stack has a maximum size of 1024. Stack items have a size of 256 bits; in fact, the EVM is a 256-bit word machine (this facilitates Keccak256 hash scheme and elliptic-curve computations but makes iterate through an array with a uint8 or add tho uint16 values much more hard). 
![](https://cdn-images-1.medium.com/max/800/1*-0srYYCvIVZf05FyFEEa8g.png)
The EVM provides many opcodes to modify the stack directly. Some of these include:

- `POP` removes item from the stack.
- `PUSHn` places the following n bytes item in the stack, with n from 1 to 32.
- `DUPn` duplicates the nth stack item, with n from 1 to 32.
- `SWAPn` exchanges the 1st and nth stack item, with n from 1 to 32.

### Calldata

The calldata is a **read-only byte-addressable space where the data parameter of a transaction or call is held**. Unlike the stack, **to use this data you have to specify an exact byte offset and number of bytes you want to read**. This is how an external function in Solidity manages it's data arguments.

The opcodes provided by the EVM to operate with the calldata include:

- `CALLDATASIZE` tells the size of the transaction data.
- `CALLDATALOAD` loads 32 bytes of the transaction data onto the stack.
- `CALLDATACOPY` copies a number of bytes of the transaction data to memory.

Solidity also provides an inline assembly version of these opcodes. These are `calldatasize`, `calldataload` and `calldatacopy` respectively. The last one expects three arguments `(t, f, s)`: it will copy `s` bytes of calldata at position `f` into memory at position `t`. In addition, Solidity lets you access to the calldata through `msg.data`.

------------------------------------------------------------------------------------


The first thing that happens when a new contract is deployed to the Ethereum blockchain is that its account is created (identified).

As the next step, **the data sent in with the transaction is executed as bytecode**. This will **initialize the state variables in storage, and determine the body of the contract being created**. This process is executed only once during the lifecycle of a contract. The initialization code **is not what is stored in the contract; it actually produces as its return value the bytecode to be stored**. Bear in mind that after a contract account has been created, there is no way to change its code.

Given the fact that the initialization process returns the code of the contract’s body to be stored, it makes sense that this code isn’t reachable from the constructor logic.
```solidity
contract Impossible {
  function Impossible() public {
    this.test();
  }

function test() public pure returns(uint256) {
    return 2;
  }
}
```

If you try to compile this contract, you will get a warning saying you’re referencing `this` within the constructor function, but it will compile. However, if you try to deploy a new instance, it will revert. This is because **it makes no sense to attempt to run code that is not stored yet.** (The EVM will check before calling an external function that the contract's address has bytecode in it. And otherwise, revert). On the other hand, we were able to access the address of the contract: the account exists, but it doesn’t have any code yet.

However, a code execution can produce other events, such as altering the storage, creating further accounts, or making further message calls.

Additionally, contracts can be created using the CREATE opcode, which is what the Solidity new construct compiles down to.

So this will be the example of a function call. In our case, Constructor function:
![](https://cdn-images-1.medium.com/max/1600/1*I33DzSpkzElt0Cc0OCwsmw.png)





