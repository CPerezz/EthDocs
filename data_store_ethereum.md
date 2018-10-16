# ETH

## How Ethereum Stores data.

**There are 2 types of data:** Permanent(Once a tx is fully confirmed, it's recorded in the transaction tree and it's never alterated) and ephemeral (balance of a particular address).

It's reasonable to store sapparately the different types of data. And Ethereum uses tree data structures to manage data.

#### State tree.

There is only and one-only global state tree in ethereum which is constantly updated and contains a key-value pair for each account that exists on the Eth Chain.
key: Consists on a 160 bit identifier (Eth address).
value: Is created by encoding the following account details using the (Recursive-Length Prefix encoding (RPL) method):
- nonce
- balance
 


