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

Let’s analyze another example using calldata:
```solidity
contract Calldata {

function add(uint256 _a, uint256 _b) public view 
  returns (uint256 result) 
  {
    assembly {
      let a := mload(0x40)
      let b := add(a, 32)
      calldatacopy(a, 4, 32)
      calldatacopy(b, add(4, 32), 32)
      result := add(mload(a), mload(b))
    }
  }
}
```

**Note** that we can writte assembly code on our Solidity code as wee see on the example avobe by typing assembly {..incomprensible instructions...}.

 What we are doing here is the following:
 - We are storing that memory pointer in the variable `a` and storing in `b` the following position which is 32-bytes right after `a`. 
 - Then we use `calldatacopy` to store the first parameter in `a`. You may have noticed we are copying it from the 4th position of the calldata instead of its beginning. This is because **the first 4 bytes of the calldata hold the signature of the function being called**, in this case `bytes4(keccak256("add(uint256,uint256)"))`.

**This `bytes4(keccak256("add(uint256,uint256)"))` is what EVM uses to identify which function has to be executed on the call.**
Then, we store the second parameter in b copying the following 32 bytes of the calldata. Finally, we just need to calculate the addition of both values loading them from memory.

## Memory
Memory is a volatile read-write byte-addressable space. It is mainly used to store data during execution, mostly for passing arguments to internal functions. Given this is volatile area, every message call starts with a cleared memory. All locations are initially defined as zero. As calldata, memory can be addressed at byte level, but can only read 32-byte words at a time. It's curious that is able to write 256-bit and 8-bit memmory positions, but just able to read 256-bit words.

![](https://cdn-images-1.medium.com/max/800/1*JHDYInm9Ca8b2revBuu8mw.png)


Memory is said to “expand” when we write to a word in it that was not previously used. Additionally to the cost of the write itself, **there is a cost to this expansion, which increases linearly for the first 724 bytes and quadratically after that**.

The EVM provides three opcodes to interact with the memory area:

    `MLOAD` loads a 32-byte word from memory into the stack.
    `MSTORE` saves a 32-byte word to memory.
    `MSTORE8` saves a byte to memory.

Solidity also provides an inline assembly version of these opcodes.
There is another key thing we need to know about memory.** Solidity always stores a free memory pointer at position 0x40**, i.e. a reference to the first unused word in memory. That’s why we load this word to operate with inline assembly on the example avobe. **Since the initial 64 bytes of memory are reserved for the EVM, this is how we can ensure that we are not overwriting memory that is used internally by Solidity**.

For instance, in the `delegatecall` example presented above, **we were loading this pointer to store the given calldata to forward it**. This is **because the inline-assembly opcode `delegatecall` needs to fetch its payload from memory**.

Additionally, if you pay attention to the bytecode output by the Solidity compiler, you will notice that all of them start with `0x6060604052…`, which means:
```
PUSH1   :  EVM opcode is 0x60
0x60    :  The free memory pointer
PUSH1   :  EVM opcode is 0x60
0x40    :  Memory position for the free memory pointer
MSTORE  :  EVM opcode is 0x52
```
We must be very careful when operating with memory at assembly level. Otherwise, we could overwrite a reserved space.

## Storage 
Storage is a persistent read-write word-addressable space. This is where each contract stores its persistent information. Unlike memory, storage is a persistent area and can only be addressed by words. It is a key-value mapping of 2²⁵⁶ slots of 32 bytes each. A contract can neither read nor write to any storage apart from its own. All locations are initially defined as zero.

The amount of gas required to save data into storage is one of the highest among operations of the EVM. This cost is not always the same. Modifying a storage slot from a zero value to a non-zero one costs 20,000. While storing the same non-zero value or setting a non-zero value to zero costs 5,000. However, in the last scenario when a non-zero value is set to zero, a refund of 15,000 will be given.

The EVM provides two opcodes to operate the storage:

    `SLOAD` loads a word from storage into the stack.
    `SSTORE` saves a word to storage.

These opcodes are also supported by the inline assembly of Solidity.

**Solidity will automatically map every defined state variable of your contract to a slot in storage**. The strategy is fairly simple — statically sized variables **(everything except mappings and dynamic arrays) are laid out contiguously in storage starting from position 0**.

For dynamic arrays, this slot `(p)` stores the length of the array and its data will be located at the slot number that results from hashing `p(keccak256(p))`. For mappings, this slot is unused and the value corresponding to a key k will be located at `keccak256(k,p)`. Bear in mind that the parameters of `keccak256 (k and p)` are always padded to 32 bytes.


------------------------------------------------------------------------------

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
´´´

If you try to compile this contract, you will get a warning saying you’re referencing `this` within the constructor function, but it will compile. However, if you try to deploy a new instance, it will revert. This is because **it makes no sense to attempt to run code that is not stored yet.** (The EVM will check before calling an external function that the contract's address has bytecode in it. And otherwise, revert). On the other hand, we were able to access the address of the contract: the account exists, but it doesn’t have any code yet.

However, a code execution can produce other events, such as altering the storage, creating further accounts, or making further message calls.

Additionally, contracts can be created using the CREATE opcode, which is what the Solidity new construct compiles down to.

So this will be the example of a function call. In our case, Constructor function:
![](https://cdn-images-1.medium.com/max/1600/1*I33DzSpkzElt0Cc0OCwsmw.png)







